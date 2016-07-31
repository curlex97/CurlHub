//
//  ACRepoDirectory.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepoDirectory.h"

@implementation ACRepoDirectory

- (instancetype)initWithName:(NSString*)name andUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        self.name = name;
        self.url = url;
    }
    return self;
}

@end
