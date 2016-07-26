//
//  ACUser.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACUser.h"

@implementation ACUser

- (instancetype)initWithID:(NSString*)ID andLogin:(NSString*)login andAvatar:(UIImage*)avatar andURL:(NSString*)URL andAccessToken:(NSString*)accessToken andName:(NSString*)name andCompany:(NSString*)company andLocation:(NSString*)location andEmail:(NSString*)email andFollowers:(NSString*)followers andFollowing:(NSString*)following
{
    self = [super init];
    if (self) {
        self.ID = ID;
        self.login = login;
        self.URL = URL;
        self.accessToken = accessToken;
        self.name = name;
        self.company = company;
        self.location = location;
        self.email = email;
        self.followers = followers;
        self.following = following;
        
        
        
        
    }
    return self;
}

@end
