//
//  ACRepoFile.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepoFile.h"

@implementation ACRepoFile

- (instancetype)initWithName:(NSString*)name andSize:(long)size andDownloadUrl:(NSString*)downloadUrl
{
    self = [super init];
    if (self) {
        self.name = name;
        self.size = size;
        self.downloadUrl = downloadUrl;
    }
    return self;
}

@end
