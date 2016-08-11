//
//  ACReposViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACReposViewModel.h"

@implementation ACReposViewModel

-(NSArray *)allReposForUser:(ACUser *)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter
{
    return [[[ACHubDataManager alloc] init] reposForUser:user andPageNumber:pageNumber andFilter:filter];
}

-(NSArray *)allReposForQuery:(NSString *)query andPageNumber:(int)pageNumber
{
    return [[[ACHubDataManager alloc] init] reposForQuery:query andPageNumber:pageNumber];
}

-(ACUser *)repositoryOwner:(ACRepo *)repository
{
    ACUser* user = [[[ACHubDataManager alloc] init] userFromUrl:repository.ownerUrl];
    return user;
}

-(ACRepo *)repoFromUrl:(NSString *)url
{
    return [[[ACHubDataManager alloc] init] repoFromUrl:url];
}

@end
