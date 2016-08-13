//
//  ACRepoContentsViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepoContentsViewModel.h"

@implementation ACRepoContentsViewModel

-(NSArray *)filesListFromDirectory:(ACRepoDirectory *)directory andCurrentUser:(ACUser*)currentUser
{
    return [[[ACHubDataManager alloc] init] filesAndDirectoriesFromDirectory:directory andUser:currentUser];
}

-(NSString *)textContentWithFile:(ACRepoFile *)file
{
    return [[[ACHubDataManager alloc] init] textContentWithFile:file];
}

@end
