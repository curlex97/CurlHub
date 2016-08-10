//
//  ACHubDataManager.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//


#import "ACHubDataManager.h"


@interface ACHubDataManager()

@end

static NSString* clientID =  @"07792de91a22f48d76a8";
static NSString* clientSecret = @"3ac64664dc2578449db4c617aefd5ee47c850f62";

@implementation ACHubDataManager


-(void) test
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:@"bio" forKey:@"something in your mouth"];
    
    
    // ?access_token=e37d4f5328e0048aa721e4e58558bc023a760029&client_id=07792de91a22f48d76a8&client_secret=3ac64664dc2578449db4c617aefd5ee47c850f62
    NSURL *URL = [NSURL URLWithString:@"https://api.github.com/user/following/fds?access_token=e37d4f5328e0048aa721e4e58558bc023a760029&client_id=07792de91a22f48d76a8&client_secret=3ac64664dc2578449db4c617aefd5ee47c850f62"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"PUT"];
    
   // [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  //  NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
   // [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"0"] forHTTPHeaderField:@"Content-Length"];
   // [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if(data.length){
                                          NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
                                          NSLog(@"%@", newStr);
                                      }
                                      else NSLog(@"204");
                                  }];
    
    [task resume];
}

-(ACUser*)userFromToken:(NSString*)token
{
    
    ACUser* user = [self userFromUrl:[ACHubDataManager userUrl:token]];
    user.accessToken = token;
    return user;
    return nil;
}

-(ACUser*) userFromUrl:(NSString*)url
{
    NSString* page = [ACNetworkManager stringByUrl:[ACHubDataManager anotherUrl:url]];
    
    if(page && page.length && ![page containsString:@"Bad credentials"])
    {
        NSError *jsonError = nil;
        NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
        if(!data) return nil;
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if(!jsonError)
        {
            NSString* avatarUrl = dictionary[@"avatar_url"];
            NSString* followingUrl = dictionary[@"following_url"];
            followingUrl = [followingUrl substringToIndex:[followingUrl rangeOfString:@"{"].location];
            ACUser *user = [[ACUser alloc] initWithID:dictionary[@"id"] andLogin:dictionary[@"login"] andAvatarUrl:avatarUrl andURL:dictionary[@"url"] andAccessToken:@"" andName:dictionary[@"name"] andCompany:dictionary[@"company"] andLocation:dictionary[@"location"] andEmail:dictionary[@"email"] andFollowers:dictionary[@"followers_url"] andFollowing:followingUrl andFollowersCount:[dictionary[@"followers"] longValue] andFollowingCount:[dictionary[@"following"] longValue]];
            return user;
        }
    }
    return nil;
}

-(NSArray<ACUser *> *)userFollowers:(ACUser *)user andPageNumber:(int)pageNumber
{
    NSMutableArray *array = [NSMutableArray array];
    NSString* path = [ACHubDataManager anotherUrl:user.followers withPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!data) return nil;
    
    NSArray* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if(!jsonError)
    {
        for(NSDictionary* eventDictionary in jsonDictionary)
        {
            ACUser* user = [self userFromUrl:[eventDictionary valueForKeyPath:@"url"]];
            [array addObject:user];
        }
    }
    
    return array;
}

-(NSArray<ACUser *> *)userFollowing:(ACUser *)user andPageNumber:(int)pageNumber
{
    NSMutableArray *array = [NSMutableArray array];
    NSString* path = [ACHubDataManager anotherUrl:user.following withPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!data) return nil;
    
    NSArray* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if(!jsonError)
    {
        for(NSDictionary* eventDictionary in jsonDictionary)
        {
            ACUser* user = [self userFromUrl:[eventDictionary valueForKeyPath:@"url"]];
            [array addObject:user];
        }
    }
    
    return array;
}

-(NSString *)tokenFromCode:(NSString *)code
{
    NSString* page = [ACNetworkManager stringByUrl:[ACHubDataManager tokenUrl:code]];
    if(page.length > 0 && [page characterAtIndex:0] == 'a')
    {
        page = [page substringToIndex:[page rangeOfString:@"&"].location];
        page = [page substringFromIndex:[page rangeOfString:@"="].location + 1];
        return page;
    }
    return nil;
}


-(NSArray<ACEvent *> *)eventsForUser:(ACUser *)user andPageNumber:(int)pageNumber
{
    
    NSMutableArray *array = [NSMutableArray array];
    NSString *path = [ACHubDataManager eventsUrl:user.login andPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!data) return nil;
    
    NSArray* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if(!jsonError)
    {
        for(NSDictionary* eventDictionary in jsonDictionary)
        {
            NSString* action = [eventDictionary valueForKeyPath:@"type"];
            NSString* login = [eventDictionary valueForKeyPath:@"actor.display_login"];
            NSString* avatarUrl = [eventDictionary valueForKeyPath:@"actor.avatar_url"];
            NSString* repoName = [eventDictionary valueForKeyPath: @"repo.name"];
            NSString* refType = [eventDictionary valueForKeyPath: @"payload.ref_type"];
            NSString* ref = [eventDictionary valueForKeyPath: @"payload.ref"];
            NSString* time = [NSString formatDateWithString:[eventDictionary valueForKeyPath: @"created_at"]];
            
            if(!refType) refType = @"";
            if(!login) login = user.login;
            
            
            
            ACEvent *event = [[ACEvent alloc] initWithLogin:login andAction:action andTime:time andRefType:refType andRepoName:repoName andRef:ref andAvatarUrl:avatarUrl];
            [array addObject:event];
            
        }
    }
    
    return array;
}


-(NSArray<ACRepo *> *)reposForUser:(ACUser *)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter
{
    NSString *path = [ACHubDataManager reposUrl:user.login andPageNumber:pageNumber andFilter:filter];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data){
    NSArray* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    return jsonError? nil : [self reposFromJsonDictionary:jsonDictionary];
    }
    return nil;
    
}

-(NSArray<ACRepo *> *)reposForQuery:(NSString *)query andPageNumber:(int)pageNumber
{
    NSString* formatedQuery = [query.lowercaseString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *path = [ACHubDataManager searchReposUrl:formatedQuery andPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data){
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSArray* reposArray = [jsonDictionary valueForKeyPath:@"items"];
    return (jsonError && reposArray) ? nil : [self reposFromJsonDictionary:reposArray];
    }
    return nil;
}

-(NSArray<ACUser *> *)usersForQuery:(NSString *)query andPageNumber:(int)pageNumber
{
    NSString* formatedQuery = [query.lowercaseString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *path = [ACHubDataManager searchUsersUrl:formatedQuery andPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data){
        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSArray* reposArray = [jsonDictionary valueForKeyPath:@"items"];
        
        if(reposArray)
        {
            NSMutableArray *users = [NSMutableArray array];
            for(NSDictionary* userDictionary in reposArray)
            {
                NSString* url = [userDictionary valueForKeyPath:@"url"];
                ACUser* user = [self userFromUrl:url];
                if(user)[users addObject:user];
            }
            return users;
        }
        
    }
    return nil;
}

// все методы получения списка репозиториев работают через него
-(NSArray*) reposFromJsonDictionary:(NSArray*)jsonDictionary
{
    NSMutableArray *array = [NSMutableArray array];

    for(NSDictionary* repoDictionary in jsonDictionary)
    {
        NSString* name = [repoDictionary valueForKeyPath:@"name"];
        NSString* ownerName = [repoDictionary valueForKeyPath:@"owner.login"];
        NSString* avatarUrl = [repoDictionary valueForKeyPath:@"owner.avatar_url"];
        NSString *language = [repoDictionary valueForKeyPath:@"language"];
        NSString* date = [NSString formatDateWithString:[repoDictionary valueForKeyPath:@"created_at"]];
        double size = [[repoDictionary valueForKeyPath:@"size"] doubleValue] / 1024;
        NSString* private = [repoDictionary valueForKeyPath:@"private"];
        NSString* issuesUrl = [repoDictionary valueForKeyPath:@"issues_url"];
        NSString* contentsUrl = [repoDictionary valueForKeyPath:@"contents_url"];
        NSString* ownerUrl = [repoDictionary valueForKeyPath:@"owner.url"];
        NSString* branchesUrl =[repoDictionary valueForKeyPath:@"branches_url"];
        
        contentsUrl = [contentsUrl substringToIndex:[contentsUrl rangeOfString:@"{"].location];
        issuesUrl = [issuesUrl substringToIndex:[issuesUrl rangeOfString:@"{"].location];
        branchesUrl = [branchesUrl substringToIndex:[branchesUrl rangeOfString:@"{"].location];

        
        NSString* htmlUrl = [repoDictionary valueForKeyPath:@"html_url"];
        int privateInt = [private intValue];
        BOOL isPrivate = privateInt > 0;
        long forksCount = [[repoDictionary valueForKeyPath:@"forks_count"] longValue];
        long watchersCount = [[repoDictionary valueForKeyPath:@"watchers_count"] longValue];
        long stargazersCount = [[repoDictionary valueForKeyPath:@"stargazers_count"] longValue];
        long branchesCount = 0, issuesCount = 0;
        
        ACRepo *repo = [[ACRepo alloc] initWithName:name andOwnerName:ownerName andOwnerAvatarUrl:avatarUrl andLanguage:language andCreateDate:date andSize:size andForksCount:forksCount andWatchersCount:watchersCount andBranchesCount:branchesCount andStargazersCount:stargazersCount andIssuesCount:issuesCount andPrivate:isPrivate andIssuesUrl:issuesUrl andContentsUrl:contentsUrl andHtmlUrl:htmlUrl andOwnerUrl:ownerUrl andBranchesUrl:branchesUrl];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSError *innerError;
            
            
            NSData *bData = [ACNetworkManager dataByUrl:repo.branchesUrl];
            if(bData)
            {
                NSArray* branchesArray = [NSJSONSerialization JSONObjectWithData:bData options:kNilOptions error:&innerError];
                if(!innerError) repo.branchesCount = branchesArray.count;
            }
            
            bData = [ACNetworkManager dataByUrl:repo.issuesUrl];
            
            if(bData)
            {
                NSArray* issuesArray = [NSJSONSerialization JSONObjectWithData:bData options:kNilOptions error:&innerError];
                if(!innerError) repo.issuesCount = issuesArray.count;
            }
        });
        
        [array addObject:repo];
        
    }
    
    return array;

}

-(NSArray<ACNews *> *)news
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *path = [ACHubDataManager newsUrl];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    if(page)
    {
        page = [page substringFromIndex:[page rangeOfString:@"<div class=\"time\">"].location + @"<div class=\"time\">".length];
        page = [page substringToIndex:[page rangeOfString:@"<div class=\"text-center\">"].location];
        
        NSArray *news = [page componentsSeparatedByString:@"<div class=\"time\">"];
        
        for(NSString* obn in news)
        {
            @try
            {
                NSString* modobn = obn;
                NSString* timeBlock = [modobn substringToIndex:[modobn rangeOfString:@"</div>"].location];
                modobn = [modobn substringFromIndex:[modobn rangeOfString:@"</div>"].location + 6];
                NSString* actionBLock = [[modobn substringToIndex:[modobn rangeOfString:@"</div>"].location] substringFromIndex:@"<div class=\"title\">".length + 2];
                modobn = [modobn substringFromIndex:[modobn rangeOfString:@"</div>"].location + 6];
                NSString* imageBlock =[modobn substringToIndex:[modobn rangeOfString:@"</div>"].location];
                
                NSString* image = [imageBlock substringFromIndex:[imageBlock rangeOfString:@"src=\""].location + 5];
                image = [image substringToIndex:[image rangeOfString:@"\""].location];
                
                NSString *time = [timeBlock substringFromIndex:[timeBlock rangeOfString:@">"].location + 1];
                time = [time substringToIndex:[time rangeOfString:@"<"].location];
            
                NSString* action = [[[actionBLock stringByStrippingHTML] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                ACNews *news = [[ACNews alloc] initWithActionText:action andDate:time andOwnerUrl:image];
                [array addObject:news];
            }
            @catch (NSException *exception) {
            }
        }
        
    }
    
    return array;
}

-(NSArray<ACIssue *> *)issuesForUser:(ACUser *)user andFilter:(NSString*)filter
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *userRepos = [self reposForUser:user andPageNumber:1 andFilter:@"all"];
    
    for(ACRepo* userRepo in userRepos)
    {
        
        NSString* page = [ACNetworkManager stringByUrl:[ACHubDataManager issuesUrlWithUrl:userRepo.issuesUrl andFilter:filter]];
        
        NSError *jsonError = nil;
        NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
        
        if(data){
            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if(!jsonError && jsonArray.count)
            {
                for(NSDictionary* issueDictionary in jsonArray)
                {
                    NSString* title = [issueDictionary valueForKeyPath:@"title"];
                    NSString* state = [issueDictionary valueForKeyPath:@"state"];
                    NSString* date = [NSString formatDateWithString:[issueDictionary valueForKeyPath:@"created_at"]];
                    long number = [[issueDictionary valueForKeyPath:@"number"] longValue];
                    NSString* eventsUrl = [issueDictionary valueForKeyPath:@"events_url"];
                    
                    ACIssue *issue = [[ACIssue alloc] initWithNumber:number andState:state andCreateDate:date andTitle:title andUser:nil andEvents:nil andLabelsCount:0 andEventsUrl:eventsUrl andRepo:userRepo];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSError *innerError;
                        NSData *bData = [ACNetworkManager dataByUrl:[issueDictionary valueForKeyPath:@"labels_url"]];
                        if(bData)
                        {
                            NSArray* labelsArray = [NSJSONSerialization JSONObjectWithData:bData options:kNilOptions error:&innerError];
                            if(!innerError) issue.labelsCount = labelsArray.count;
                        }
                        ACUser* user = [self userFromUrl:[issueDictionary valueForKeyPath:@"user.url"]];
                        issue.user = user;
                        issue.events = [self eventsForIssue:issue];
                    });
                    
                    [array addObject:issue];  
                }
            }
        }

    }
    
    return array;
}

-(NSArray*)filesAndDirectoriesFromUrl:(NSString *)url
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString* page = [ACNetworkManager stringByUrl:[ACHubDataManager anotherUrl:url]];
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data){
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(!jsonError && jsonArray.count)
        {
            for(NSDictionary* typefs in jsonArray)
            {
                NSString* type = [typefs valueForKeyPath:@"type"];
                if([type isEqualToString:@"dir"])
                {
                    ACRepoDirectory *dir = [[ACRepoDirectory alloc] initWithName:[typefs valueForKeyPath:@"name"] andUrl:[typefs valueForKeyPath:@"url"]];
                    [array addObject:dir];
                }
                else if([type isEqualToString:@"file"])
                {
                    ACRepoFile *file = [[ACRepoFile alloc] initWithName:[typefs valueForKeyPath:@"name"] andSize:[[typefs valueForKeyPath:@"size"] longValue] andDownloadUrl:[typefs valueForKeyPath:@"download_url"]];
                    [array addObject:file];
                }
            }
        }
    }
    
    return array;
}


-(NSArray<ACIssueEvent *> *)eventsForIssue:(ACIssue *)issue
{
    NSString* path = [ACHubDataManager anotherUrl:issue.eventsUrl];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data)
    {
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(!jsonError && jsonArray.count)
        {
            NSMutableArray* array = [NSMutableArray array];
            
            for(NSDictionary* issueEventDictionary in jsonArray)
            {
                NSString* event = [issueEventDictionary valueForKeyPath:@"event"];
                NSString* date = [NSString formatDateWithString:[issueEventDictionary valueForKeyPath:@"created_at"]];
                NSString* userUrl = [issueEventDictionary valueForKeyPath:@"actor.url"];
                ACIssueEvent* issueEvent = [[ACIssueEvent alloc] initWithEvent:event andUser:nil andDate:date];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    ACUser* user = [self userFromUrl:userUrl];
                    issueEvent.user = user;
                });
                [array addObject:issueEvent];
            }
            return array;
        }
    }
    return nil;
}

-(NSString *)textContentWithFile:(ACRepoFile *)file
{
    return [ACNetworkManager stringByUrl:file.downloadUrl];
}









+(NSString *)eventsUrl:(NSString *)userLogin andPageNumber:(int)pageNumber
{
    return [NSString stringWithFormat:@"https://api.github.com/users/%@/events?page=%i&per_page=10&client_id=%@&client_secret=%@", userLogin, pageNumber, clientID, clientSecret];
}

+(NSString *)verificationUrl
{
    return @"https://github.com/login/oauth/authorize?client_id=07792de91a22f48d76a8&scope=public_repo%20user%20repo";
}

+(NSString *)tokenUrl:(NSString *)code
{
    return [NSString stringWithFormat:@"https://github.com/login/oauth/access_token?code=%@&client_id=07792de91a22f48d76a8&client_secret=3ac64664dc2578449db4c617aefd5ee47c850f62", code];
}

+(NSString *)userUrl:(NSString *)token
{
    if(token && token.length){
    return [NSString stringWithFormat:@"https://api.github.com/user?access_token=%@&client_id=%@&client_secret=%@", token, clientID, clientSecret];
    }
    else
    {
        return [NSString stringWithFormat:@"https://api.github.com/user?client_id=%@&client_secret=%@", clientID, clientSecret];
    }
}

+(NSString *)reposUrl:(NSString *)userLogin andPageNumber:(int)pageNumber andFilter:(NSString*)filter
{
    return [NSString stringWithFormat:@"https://api.github.com/users/%@/repos?page=%i&per_page=10&client_id=%@&client_secret=%@&state=%@", userLogin, pageNumber, clientID, clientSecret, filter];
}

+(NSString *)searchReposUrl:(NSString *)query andPageNumber:(int)pageNumber
{
    return [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=stars&order=desc&page=%i&per_page=10&client_id=%@&client_secret=%@", query, pageNumber, clientID, clientSecret];
    
}

+(NSString *)searchUsersUrl:(NSString *)query andPageNumber:(int)pageNumber
{
    return [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&sort=followers&order=desc&page=%i&per_page=10&client_id=%@&client_secret=%@", query, pageNumber, clientID, clientSecret];
    
}

+(NSString *)newsUrl
{
    return @"https://github.com";
}

+(NSString *)issuesUrlWithUrl:(NSString *)issuesUrl andFilter:(NSString*)filter
{
    NSString* path = [issuesUrl substringToIndex:[issuesUrl rangeOfString:@"issues"].location + 6];
    return [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&state=%@", path, clientID, clientSecret, filter];
}

+(NSString *)callbackUrl
{
    return @"curlex.adr.com.ua";
}



//Not used
+(NSURLRequest *)contentTextUrlWithText:(NSString *)text
{
    NSString* path = [NSString stringWithFormat:@"http://curlex.adr.com.ua/hub.php"];
    
    //
    
    NSString *post = [NSString stringWithFormat:@"action=highlight&text=%@", text];
//stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    

    
    return request;
}

+(NSString *)anotherUrl:(NSString *)url
{
    NSString* sep = [url containsString:@"?"] ? @"&" : @"?";
    return [NSString stringWithFormat:@"%@%@client_id=%@&client_secret=%@", url, sep, clientID, clientSecret];
}

+(NSString *)anotherUrl:(NSString *)url withPageNumber:(int)pageNaumber;
{
    NSString* sep = [url containsString:@"?"] ? @"&" : @"?";
    return [NSString stringWithFormat:@"%@%@client_id=%@&client_secret=%@&page=%i&per_page=10", url, sep, clientID, clientSecret, pageNaumber];
}

+(NSString *)pageWithVerificationUrl
{
    return [ACNetworkManager stringByUrl:[ACHubDataManager verificationUrl]];
}



@end
