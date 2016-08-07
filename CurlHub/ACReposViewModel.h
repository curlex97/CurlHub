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
-(NSArray*) allReposForUser:(ACUser*)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter;

// список репозиториев по неформатированному запросу
-(NSArray*) allReposForQuery:(NSString*)query andPageNumber:(int)pageNumber;

// хозяин репозитория
-(ACUser*) repositoryOwner:(ACRepo*)repository;
@end
