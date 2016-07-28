//
//  ACNews.m
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACNews.h"

@implementation ACNews

- (instancetype)initWithActionText:(NSString*)actionText andDate:(NSString*)date andOwnerUrl:(NSString*)ownerUrl
{
    self = [super init];
    if (self) {
        self.actionText = actionText;
        self.date = date;
        self.ownerUrl = ownerUrl;
    }
    return self;
}

@end
