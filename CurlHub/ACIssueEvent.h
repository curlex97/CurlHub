//
//  ACIssueEvent.h
//  CurlHub
//
//  Created by Arthur Chistyak on 05.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"
@interface ACIssueEvent : NSObject
@property ACUser* user;
@property NSString* event;
@property NSString* date;

- (instancetype)initWithEvent:(NSString*)event andUser:(ACUser*)user andDate:(NSString*)date;
@end
