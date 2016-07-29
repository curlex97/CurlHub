//
//  ACIssue.h
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACIssue : NSObject
@property NSString* state;
@property NSString* createDate;
@property NSString* title;
@property long issueNumber;

- (instancetype)initWithNumber:(long)issueNumber andState:(NSString*)state andCreateDate:(NSString*)createDate andTitle:(NSString*)title;

@end
