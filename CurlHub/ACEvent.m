//
//  ACEvent.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACEvent.h"

@implementation ACEvent


- (instancetype)initWithLogin:(NSString*)login andAction:(NSString*)action andTime:(NSString*)time andRefType:(NSString*)refType andRepoName:(NSString*)repoName andRef:(NSString*)ref andAvatar:(UIImage*)avatar
{
    self = [super init];
    if (self) {
        
        self.login = login;
        self.action = action;
        self.time = time;
        self.refType = refType;
        self.repoName = repoName;
        self.ref = ref;
        self.avatar = avatar;
    }
    return self;
}

-(NSString *)eventDescription
{
    if([self.refType.lowercaseString containsString:@"repo"] && [self.action.lowercaseString containsString:@"create"]){
        return [NSString stringWithFormat:@"%@ created repository %@", self.login, self.repoName];
    }
    
    else if([self.refType.lowercaseString containsString:@"branch"] && [self.action.lowercaseString containsString:@"create"]){
        return [NSString stringWithFormat:@"%@ created branch %@ in %@", self.login, self.ref, self.repoName];
    }
    
    else if([self.action.lowercaseString containsString:@"push"]){
        return [NSString stringWithFormat:@"%@ pushed to %@ at %@", self.login, self.ref, self.repoName];
    }
    
    return [NSString stringWithFormat:@"%@ %@, %@", self.login, self.action, self.repoName];
}

@end
