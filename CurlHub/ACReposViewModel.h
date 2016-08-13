//
//  ACReposViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"
#import "ACRepo.h"
#import "ACHubDataManager.h"

@interface ACReposViewModel : NSObject

// список репозиториев для пользователя
-(NSArray *)allReposForUser:(ACUser *)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter andSystemUser:(ACUser*)currentUser;

// список репозиториев по неформатированному запросу
-(NSArray *)allReposForQuery:(NSString *)query andPageNumber:(int)pageNumber andSystemUser:(ACUser*)user;

-(ACRepo *)repoFromEvent:(ACEvent *)event andSystemUser:(ACUser*)user;

// хозяин репозитория
-(ACUser*) repositoryOwner:(ACRepo*)repository andCurrentUser:(ACUser*)currentUser;

-(void) starRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

-(void) unstarRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

-(void) isStarringRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(BOOL))completed;

-(void) watchRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

-(void) unwatchRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

-(void) isWatchingRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(BOOL))completed;

@end
