//
//  ACEvent.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface ACEvent : NSObject
@property NSString* time;
@property NSString* login;
@property NSString* action;
@property NSString* refType;
@property NSString* repoName;
@property NSString* ref;
@property NSString* avatarUrl;


- (instancetype)initWithLogin:(NSString*)login andAction:(NSString*)action andTime:(NSString*)time andRefType:(NSString*)refType andRepoName:(NSString*)repoName andRef:(NSString*)ref andAvatarUrl:(NSString*)avatarUrl;
-(NSString*) eventDescription;

@end
