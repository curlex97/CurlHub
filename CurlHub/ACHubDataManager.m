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
            NSString* repoUrl = [eventDictionary valueForKeyPath:@"repo.url"];
            NSString* action = [eventDictionary valueForKeyPath:@"type"];
            NSString* login = [eventDictionary valueForKeyPath:@"actor.display_login"];
            NSString* avatarUrl = [eventDictionary valueForKeyPath:@"actor.avatar_url"];
            NSString* repoName = [eventDictionary valueForKeyPath: @"repo.name"];
            NSString* refType = [eventDictionary valueForKeyPath: @"payload.ref_type"];
            NSString* ref = [eventDictionary valueForKeyPath: @"payload.ref"];
            NSString* time = [NSString formatDateWithString:[eventDictionary valueForKeyPath: @"created_at"]];
            
            if(!refType) refType = @"";
            if(!login) login = user.login;
            
            ACEvent *event = [[ACEvent alloc] initWithLogin:login andAction:action andTime:time andRefType:refType andRepoName:repoName andRef:ref andAvatarUrl:avatarUrl andRepoUrl:repoUrl];
            [array addObject:event];
            
        }
    }
    
    return array;
}

-(ACRepo*) repoFromEvent:(ACEvent*)event andCurrentUser:(ACUser*)user
{
    NSString* page = [ACNetworkManager stringByUrl:event.repoUrl];
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    if(data){
        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(jsonDictionary)
            return [self repoFromJsonDictionary:jsonDictionary andCurrentUser:user];
    }
    return nil;
}


-(NSArray<ACRepo *> *)reposForUser:(ACUser *)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter andCurrentUser:(ACUser*)currentUser
{
    NSString *path = [ACHubDataManager reposUrl:user.login andPageNumber:pageNumber andFilter:filter];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data){
    NSArray* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    return jsonError? nil : [self reposFromJsonArray:jsonDictionary andCurrentUser:currentUser];
    }
    return nil;
    
}

-(NSArray<ACRepo *> *)reposForQuery:(NSString *)query andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)user
{
    NSString* formatedQuery = [query.lowercaseString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *path = [ACHubDataManager searchReposUrl:formatedQuery andPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data){
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSArray* reposArray = [jsonDictionary valueForKeyPath:@"items"];
    return (jsonError && reposArray) ? nil : [self reposFromJsonArray:reposArray andCurrentUser:user];
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
-(NSArray*) reposFromJsonArray:(NSArray*)jsonArray andCurrentUser:(ACUser*)user
{
    
    NSMutableArray *array = [NSMutableArray array];

    for(NSDictionary* repoDictionary in jsonArray)
    {
        [array addObject:[self repoFromJsonDictionary:repoDictionary andCurrentUser:user]];
    }
    
    return array;

}

-(ACRepo*) repoFromJsonDictionary:(NSDictionary*)repoDictionary andCurrentUser:(ACUser*)user
{
    NSString* name = [repoDictionary valueForKeyPath:@"name"];
    NSString* fullName = [repoDictionary valueForKeyPath:@"full_name"];
    NSString* ownerName = [repoDictionary valueForKeyPath:@"owner.login"];
    NSString* avatarUrl = [repoDictionary valueForKeyPath:@"owner.avatar_url"];
    NSString *language = [repoDictionary valueForKeyPath:@"language"];
    NSString* date = [NSString formatDateWithString:[repoDictionary valueForKeyPath:@"created_at"]];
    double size = [[repoDictionary valueForKeyPath:@"size"] doubleValue] / 1024;
    NSString* private = [repoDictionary valueForKeyPath:@"private"];
    NSString* issuesUrl = [repoDictionary valueForKeyPath:@"issues_url"];
    NSString* contentsUrl = [repoDictionary valueForKeyPath:@"contents_url"];
    NSString* commitsUrl = [repoDictionary valueForKeyPath:@"commits_url"];
    NSString* ownerUrl = [repoDictionary valueForKeyPath:@"owner.url"];
    NSString* branchesUrl =[repoDictionary valueForKeyPath:@"branches_url"];
    
    contentsUrl = [contentsUrl substringToIndex:[contentsUrl rangeOfString:@"{"].location];
    issuesUrl = [issuesUrl substringToIndex:[issuesUrl rangeOfString:@"{"].location];
    branchesUrl = [branchesUrl substringToIndex:[branchesUrl rangeOfString:@"{"].location];
    commitsUrl = [commitsUrl substringToIndex:[commitsUrl rangeOfString:@"{"].location];
    
    NSString* htmlUrl = [repoDictionary valueForKeyPath:@"html_url"];
    int privateInt = [private intValue];
    BOOL isPrivate = privateInt > 0;
    long forksCount = [[repoDictionary valueForKeyPath:@"forks_count"] longValue];
    long watchersCount = [[repoDictionary valueForKeyPath:@"watchers_count"] longValue];
    long stargazersCount = [[repoDictionary valueForKeyPath:@"stargazers_count"] longValue];
    long branchesCount = 0, issuesCount = 0;
    
    ACRepo *repo = [[ACRepo alloc] initWithName:name andFullName:fullName andOwnerName:ownerName andOwnerAvatarUrl:avatarUrl andLanguage:language andCreateDate:date andSize:size andForksCount:forksCount andWatchersCount:watchersCount andBranchesCount:branchesCount andStargazersCount:stargazersCount andIssuesCount:issuesCount andPrivate:isPrivate andIsStarring:false andIsWatching:false andIssuesUrl:issuesUrl andContentsUrl:contentsUrl andCommitsUrl:commitsUrl andHtmlUrl:htmlUrl andOwnerUrl:ownerUrl andBranchesUrl:branchesUrl];
    
    [self isStarringRepoAsync:repo andUser:user completion:^(BOOL isStar){
        repo.isStarring = isStar;
    }];
    
    [self isWatchingRepoAsync:repo andUser:user completion:^(BOOL isWatch){
        repo.isWatching = isWatch;
        if(isWatch && !watchersCount) repo.watchersCount ++;
    }];
    
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
    
    return repo;

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

-(NSArray<ACIssue *> *)issuesForUser:(ACUser *)user andFilter:(NSString*)filter andCurrentUser:(ACUser*) currentUser
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *userRepos = [self reposForUser:user andPageNumber:1 andFilter:@"all" andCurrentUser:currentUser];
    
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

-(NSArray*) filesAndDirectoriesFromDirectory:(ACRepoDirectory*)directory
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString* page = [ACNetworkManager stringByUrl:[ACHubDataManager anotherUrl:directory.url]];
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

-(NSArray<ACCommit *> *)commitsForRepo:(ACRepo *)repo andPageNumber:(int)pageNumber
{
    NSString* path =[ACHubDataManager anotherUrl: repo.commitsUrl withPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data)
    {
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(!jsonError && jsonArray.count)
        {
            NSMutableArray *commits = [NSMutableArray array];
            
            for(NSDictionary* commitDictionary in jsonArray)
            {
                NSString* message = [commitDictionary valueForKeyPath:@"commit.message"];
                if([message isKindOfClass:[NSNull class]] || !message || !message.length) message = @"No message";
                NSString* date = [NSString formatDateWithString:[commitDictionary valueForKeyPath:@"commit.committer.date"]];
                NSString* commiterLogin = [commitDictionary valueForKeyPath:@"committer.login"];
                NSString* commiterAvatar = [commitDictionary valueForKeyPath:@"committer.avatar_url"];
                NSString* sha = [commitDictionary valueForKeyPath:@"sha"];
                NSString* commentsUrl = [commitDictionary valueForKeyPath:@"comments_url"];
                
                ACCommit* commit = [[ACCommit alloc] initWithMessage:message andDate:date andCommiterLogin:commiterLogin andCommiterAvatarUrl:commiterAvatar andSha:sha andCommentsUrl:commentsUrl];
                [commits addObject:commit];
            }
            return commits;
        }
    }
    return nil;
}

-(NSArray<ACCommit *> *)commentsForCommit:(ACCommit *)commit andPageNumber:(int)pageNumber
{
    NSString* path =[ACHubDataManager anotherUrl: commit.commentsUrl withPageNumber:pageNumber];
    NSString* page = [ACNetworkManager stringByUrl:path];
    
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data)
    {
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(!jsonError && jsonArray.count)
        {
            NSMutableArray *comments = [NSMutableArray array];
            
            for(NSDictionary* commentDictionary in jsonArray)
            {
                NSString* body = [commentDictionary valueForKeyPath:@"body"];
                NSString* date = [NSString formatDateWithString:[commentDictionary valueForKeyPath:@"updated_at"]];
                NSString* userLogin = [commentDictionary valueForKeyPath:@"user.login"];
                NSString* userAvatarUrl = [commentDictionary valueForKeyPath:@"user.avatar_url"];
                
                ACComment* comment = [[ACComment alloc] initWithBody:body andDate:date andUserLogin:userLogin andUserAvatarUrl:userAvatarUrl];
                [comments addObject:comment];
            }
            return comments;
        }
    }
    return nil;
}



-(NSString *)textContentWithFile:(ACRepoFile *)file
{
    return [ACNetworkManager stringByUrl:file.downloadUrl];
}


-(void)isStarringRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(BOOL))completed
{
    NSString* path = [ACHubDataManager starUrlWithRepo:repo];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                      andBodyDictionary:nil andQueryType:@"GET"
                      completion:^(NSData* data){
        completed(!data.length);
    }];
}

-(void)starRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    NSString* path = [ACHubDataManager starUrlWithRepo:repo];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                   andBodyDictionary:nil andQueryType:@"PUT"
                          completion:^(NSData* data){
                              completed();
                          }];
}

-(void)unstarRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    NSString* path = [ACHubDataManager starUrlWithRepo:repo];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                   andBodyDictionary:nil andQueryType:@"DELETE"
                          completion:^(NSData* data){
                              completed();
                          }];
}


-(void)isWatchingRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(BOOL))completed
{
    NSString* path = [ACHubDataManager watchUrlWithRepo:repo];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                   andBodyDictionary:nil andQueryType:@"GET"
                          completion:^(NSData* data){
                              completed(!data.length);
                          }];
}

-(void)watchRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    NSString* path = [ACHubDataManager watchUrlWithRepo:repo];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                   andBodyDictionary:nil andQueryType:@"PUT"
                          completion:^(NSData* data){
                              completed();
                          }];
}

-(void)unwatchRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    NSString* path = [ACHubDataManager watchUrlWithRepo:repo];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                   andBodyDictionary:nil andQueryType:@"DELETE"
                          completion:^(NSData* data){
                              completed();
                          }];
}


-(void)updateUserAsync:(NSDictionary *)properties andUser:(ACUser *)user completion:(void (^)(void))completed
{
    NSString* path = [ACHubDataManager userUpdateUrl];
    [ACNetworkManager dataByUrlAsync:path andHeaderDictionary:@{@"Authorization":[NSString stringWithFormat:@"token %@", user.accessToken]}
                   andBodyDictionary:properties andQueryType:@"PATCH"
                          completion:^(NSData* data){
                             if(completed) completed();
                          }];
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
    
    NSString *post = [NSString stringWithFormat:@"action=highlight&text=%@", text];
    
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

+(NSString*)starUrlWithRepo:(ACRepo*)repo
{
    return [ACHubDataManager anotherUrl:[NSString stringWithFormat:@"https://api.github.com/user/starred/%@", repo.fullName]];
}

+(NSString*)watchUrlWithRepo:(ACRepo*)repo
{
    return [ACHubDataManager anotherUrl:[NSString stringWithFormat:@"https://api.github.com/user/subscriptions/%@", repo.fullName]];
}

+(NSString *)userUpdateUrl
{
return [ACHubDataManager anotherUrl:[NSString stringWithFormat:@"https://api.github.com/user"]];
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
