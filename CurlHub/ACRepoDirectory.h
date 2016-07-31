//
//  ACRepoDirectory.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACRepoDirectory : NSObject
@property NSString* name;
@property NSString* url;

- (instancetype)initWithName:(NSString*)name andUrl:(NSString*)url;

@end
