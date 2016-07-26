//
//  ACUser.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACUser : NSObject
@property NSString* ID;
@property NSString* login;
@property UIImage* avatar;
@property NSString* URL;
@property NSString* accessToken;
@property NSString* name;
@property NSString* company;
@property NSString* location;
@property NSString* email;
@property NSString* followers;
@property NSString* following;

- (instancetype)initWithID:(NSString*)ID andLogin:(NSString*)login andAvatar:(UIImage*)avatar andURL:(NSString*)URL andAccessToken:(NSString*)accessToken andName:(NSString*)name andCompany:(NSString*)company andLocation:(NSString*)location andEmail:(NSString*)email andFollowers:(NSString*)followers andFollowing:(NSString*)following;

@end
