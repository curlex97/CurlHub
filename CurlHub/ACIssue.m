//
//  ACIssue.m
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACIssue.h"

@implementation ACIssue

- (instancetype)initWithNumber:(long)issueNumber andState:(NSString*)state andCreateDate:(NSString*)createDate andTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        self.title = title;
        self.issueNumber = issueNumber;
        self.state = state;
        self.createDate = createDate;
    }
    return self;
}

@end
