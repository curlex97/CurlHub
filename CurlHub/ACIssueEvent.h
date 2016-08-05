//
//  ACIssueEvent.h
//  CurlHub
//
//  Created by Arthur Chistyak on 05.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACIssueEvent : NSObject
@property NSString* userName;
@property NSString* event;
@property NSString* date;
- (instancetype)initWithEvent:(NSString*)event andUserName:(NSString*)userName andDate:(NSString*)date;
@end
