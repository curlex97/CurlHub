//
//  ACHubDataManager.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACHubDataManager.h"


@implementation ACHubDataManager


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
            ACUser *user = [[ACUser alloc] initWithID:jsonDictionary[@"id"] andLogin:jsonDictionary[@"login"] andAvatarUrl:jsonDictionary[@"avatar_url"] andURL:jsonDictionary[@"url"] andAccessToken:token andName:jsonDictionary[@"name"] andCompany:jsonDictionary[@"company"] andLocation:jsonDictionary[@"location"] andEmail:jsonDictionary[@"email"] andFollowers:jsonDictionary[@"followers"] andFollowing:jsonDictionary[@"following"]];
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
