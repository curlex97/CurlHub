//
//  ACIssue.h
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"
#import "ACRepo.h"

@interface ACIssue : NSObject
@property NSString* state;
@property NSString* createDate;
@property NSString* title;
@property long issueNumber;
@property long labelsCount;
@property ACUser* user;
@property NSArray* events;
@property NSString* eventsUrl;
@property ACRepo* repo;

- (instancetype)initWithNumber:(long)issueNumber andState:(NSString*)state andCreateDate:(NSString*)createDate andTitle:(NSString*)title andUser:(ACUser*)user andEvents:(NSArray*)events andLabelsCount:(long)labelsCount andEventsUrl:(NSString*)eventsUrl andRepo:(ACRepo*)repo;

@end
