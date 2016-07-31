//
//  ACRepoFile.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACRepoFile : NSObject

@property NSString* name;
@property long size;
@property NSString* downloadUrl;

- (instancetype)initWithName:(NSString*)name andSize:(long)size andDownloadUrl:(NSString*)downloadUrl;

@end
