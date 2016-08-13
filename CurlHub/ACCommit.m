//
//  ACCommit.m
//  CurlHub
//
//  Created by Arthur Chistyak on 11.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACCommit.h"

@implementation ACCommit

- (instancetype)initWithMessage:(NSString*)message andDate:(NSString*)date andCommiterLogin:(NSString*)commiterLogin andCommiterAvatarUrl:(NSString*)commiterAvatarUrl andSha:(NSString *)sha andCommentsUrl:(NSString *)commentsUrl
{
    self = [super init];
    if (self) {
        self.message = message;
        self.date = date;
        self.commiterLogin = commiterLogin;
        self.commiterAvatarUrl = commiterAvatarUrl;
        self.sha = sha;
        self.commentsUrl = commentsUrl;
    }
    return self;
}

@end
