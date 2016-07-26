//
//  ACHubDataManager.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACHubDataManager.h"

@interface ACHubDataManager()

+(NSMutableDictionary*) picturesDictionary;
@end

static NSMutableDictionary *picturesDictionary;

@implementation ACHubDataManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        if(!picturesDictionary)
        picturesDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(ACUser*)userFromToken:(NSString*)token
{
    NSString* page = [NSString stringWithContentsOfURL:[NSURL URLWithString:[ACHubDataManager userUrl:token]] encoding:NSUTF8StringEncoding error:nil];
    
    if(![page containsString:@"Bad credentials"])
    {
        NSError *jsonError = nil;
        NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if(!jsonError)
        {
            NSString* avatarUrl = jsonDictionary[@"avatar_url"];
            
            ACUser *user = [[ACUser alloc] initWithID:jsonDictionary[@"id"] andLogin:jsonDictionary[@"login"] andAvatar:nil andURL:jsonDictionary[@"url"] andAccessToken:token andName:jsonDictionary[@"name"] andCompany:jsonDictionary[@"company"] andLocation:jsonDictionary[@"location"] andEmail:jsonDictionary[@"email"] andFollowers:jsonDictionary[@"followers"] andFollowing:jsonDictionary[@"following"]];
            
            UIImage* ava = picturesDictionary[avatarUrl];
            
            if(ava) user.avatar = ava;
            else
            {
              
                    dispatch_async(dispatch_get_global_queue(0,0), ^{
                        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: avatarUrl]];
                        if ( data == nil )
                            return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            user.avatar = [UIImage imageWithData: data];
                            [picturesDictionary setObject:[UIImage imageWithData: data] forKey:avatarUrl];
                        });
                    });
                
            }

            return user;
        }
        
        
    }
    
    return nil;
}

-(NSString *)tokenFromCode:(NSString *)code
{
    NSString* page = [NSString stringWithContentsOfURL:[NSURL URLWithString:[ACHubDataManager tokenUrl:code]] encoding:NSUTF8StringEncoding error:nil];
    if(page.length > 0 && [page characterAtIndex:0] == 'a')
    {
        page = [page substringToIndex:[page rangeOfString:@"&"].location];
        page = [page substringFromIndex:[page rangeOfString:@"="].location + 1];
        return page;
    }
    return nil;
}


-(NSArray<ACEvent *> *)eventsForUser:(ACUser *)user
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *path = [ACHubDataManager eventsUrl:user.login];
    NSString* page = [NSString stringWithContentsOfURL:[NSURL URLWithString:path] encoding:NSUTF8StringEncoding error:nil];
    
    NSError *jsonError = nil;
    NSData *data = [page dataUsingEncoding:NSUTF8StringEncoding];
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
            NSString* time = [eventDictionary valueForKeyPath: @"created_at"];
            
            if(!refType) refType = @"";
            if(!login) login = user.login;
            
            
            
            ACEvent *event = [[ACEvent alloc] initWithLogin:login andAction:action andTime:time andRefType:refType andRepoName:repoName andRef:ref andAvatar:nil];
            
            UIImage* ava = picturesDictionary[avatarUrl];
            
            if(ava) event.avatar = ava;
            
            else
            {
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: avatarUrl]];
                event.avatar = [UIImage imageWithData: data];
                [picturesDictionary setObject:[UIImage imageWithData: data] forKey:avatarUrl];
            }
            
            [array addObject:event];
            
        }
    }
    
    return array;
}

+(NSMutableDictionary*)picturesDictionary
{
    return picturesDictionary;
}
           
+(void)setPicturesDictionary:(NSMutableDictionary*)dictionary
{
    picturesDictionary = dictionary;
}

+(NSString *)eventsUrl:(NSString *)userLogin
{
    return [NSString stringWithFormat:@"https://api.github.com/users/%@/events", userLogin];
}

+(NSString *)verificationUrl
{
    return @"https://github.com/login/oauth/authorize?client_id=07792de91a22f48d76a8";
}

+(NSString *)tokenUrl:(NSString *)code
{
    return [NSString stringWithFormat:@"https://github.com/login/oauth/access_token?code=%@&client_id=07792de91a22f48d76a8&client_secret=3ac64664dc2578449db4c617aefd5ee47c850f62", code];
}

+(NSString *)userUrl:(NSString *)token
{
    return [NSString stringWithFormat:@"https://api.github.com/user?access_token=%@", token];
}



@end
