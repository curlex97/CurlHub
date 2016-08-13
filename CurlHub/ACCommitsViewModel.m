//
//  ACCommitViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACCommitsViewModel.h"

@implementation ACCommitsViewModel

-(NSArray<ACCommit *> *)commitsForRepo:(ACRepo *)repo andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser
{
    return [[[ACHubDataManager alloc] init] commitsForRepo:repo andPageNumber:pageNumber andUser:currentUser];
}

@end
