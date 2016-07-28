//
//  ACNews.h
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACNews : NSObject
@property NSString* actionText;
@property NSString* ownerUrl;
@property NSString* date;

- (instancetype)initWithActionText:(NSString*)actionText andDate:(NSString*)date andOwnerUrl:(NSString*)ownerUrl;

@end
