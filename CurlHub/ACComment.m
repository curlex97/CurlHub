//
//  ACComment.m
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACComment.h"

@implementation ACComment

- (instancetype)initWithID:(long)ID andBody:(NSString*)body andDate:(NSString*)date andUserLogin:(NSString*)userLogin andUserAvatarUrl:(NSString*)userAvatarUrl
{
    self = [super init];
    if (self) {
        self.ID = ID;
        self.body = body;
        self.date = date;
        self.userLogin = userLogin;
        self.userAvatarUrl = userAvatarUrl;
    }
    return self;
}

@end
