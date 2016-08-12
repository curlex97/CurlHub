//
//  ACCommit.h
//  CurlHub
//
//  Created by Arthur Chistyak on 11.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACRepo.h"

@interface ACCommit : NSObject

@property NSString* message;
@property NSString* date;
@property NSString* commiterLogin;
@property NSString* commiterAvatarUrl;
@property ACRepo* repo;

- (instancetype)initWithMessage:(NSString*)message andDate:(NSString*)date andCommiterLogin:(NSString*)commiterLogin andCommiterAvatarUrl:(NSString*)commiterAvatarUrl andRepo:(ACRepo*)repo;

@end
