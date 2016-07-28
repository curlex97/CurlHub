//
//  ACReposViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACReposViewModel.h"
#import "ACHubDataManager.h"

@implementation ACReposViewModel

-(NSArray *)allReposForUser:(ACUser *)user andPageNumber:(int)pageNumber
{
    return [[[ACHubDataManager alloc] init] reposForUser:user andPageNumber:pageNumber];
}

-(NSArray *)allReposForQuery:(NSString *)query andPageNumber:(int)pageNumber
{
    return [[[ACHubDataManager alloc] init] reposForQuery:query andPageNumber:pageNumber];
}

@end
