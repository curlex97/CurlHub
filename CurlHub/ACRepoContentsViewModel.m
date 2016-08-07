//
//  ACRepoContentsViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepoContentsViewModel.h"

@implementation ACRepoContentsViewModel

-(NSArray *)filesListFromUrl:(NSString *)url
{
    return [[[ACHubDataManager alloc] init] filesAndDirectoriesFromUrl:url];
}

-(NSString *)textContentWithFile:(ACRepoFile *)file
{
    return [[[ACHubDataManager alloc] init] textContentWithFile:file];
}

@end
