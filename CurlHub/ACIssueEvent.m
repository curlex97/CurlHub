//
//  ACIssueEvent.m
//  CurlHub
//
//  Created by Arthur Chistyak on 05.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACIssueEvent.h"

@implementation ACIssueEvent

- (instancetype)initWithEvent:(NSString*)event andUserName:(NSString*)userName andDate:(NSString*)date
{
    self = [super init];
    if (self) {
        self.event = event;
        self.userName = userName;
        self.date = date;
    }
    return self;
}

@end
