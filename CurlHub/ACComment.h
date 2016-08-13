//
//  ACComment.h
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACComment : NSObject
@property NSString* body;
@property NSString* date;
@property NSString* userLogin;
@property NSString* userAvatarUrl;

- (instancetype)initWithBody:(NSString*)body andDate:(NSString*)date andUserLogin:(NSString*)userLogin andUserAvatarUrl:(NSString*)userAvatarUrl;

@end
