//
//  ACReposViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACReposViewModel.h"

@implementation ACReposViewModel

-(NSArray *)allReposForUser:(ACUser *)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter andSystemUser:(ACUser*)currentUser
{
    return [[[ACHubDataManager alloc] init] reposForUser:user andPageNumber:pageNumber andFilter:filter andCurrentUser:currentUser];
}

-(NSArray *)allReposForQuery:(NSString *)query andPageNumber:(int)pageNumber andSystemUser:(ACUser*)user
{
    return [[[ACHubDataManager alloc] init] reposForQuery:query andPageNumber:pageNumber andCurrentUser:user];
}

-(ACUser *)repositoryOwner:(ACRepo *)repository andCurrentUser:(ACUser*)currentUser
{
    ACUser* user = [[[ACHubDataManager alloc] init] userFromUrl:repository.ownerUrl andUser:currentUser];
    return user;
}

-(ACRepo *)repoFromEvent:(ACEvent *)event andSystemUser:(ACUser*)user
{
    return [[[ACHubDataManager alloc] init] repoFromEvent:event andCurrentUser:user];
}

-(void)isStarringRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(BOOL))completed
{
    [[[ACHubDataManager alloc] init] isStarringRepoAsync:repo andUser:user completion:completed];
}

-(void)starRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    [[[ACHubDataManager alloc] init] starRepoAsync:repo andUser:user completion:completed];
}

-(void)unstarRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    [[[ACHubDataManager alloc] init] unstarRepoAsync:repo andUser:user completion:completed];
}

-(void)isWatchingRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(BOOL))completed
{
    [[[ACHubDataManager alloc] init] isWatchingRepoAsync:repo andUser:user completion:completed];
}

-(void)watchRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    [[[ACHubDataManager alloc] init] watchRepoAsync:repo andUser:user completion:completed];
}

-(void)unwatchRepoAsync:(ACRepo *)repo andUser:(ACUser *)user completion:(void (^)(void))completed
{
    [[[ACHubDataManager alloc] init] unwatchRepoAsync:repo andUser:user completion:completed];
}

@end
