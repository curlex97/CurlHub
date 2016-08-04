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

@interface ACReposViewModel : NSObject

-(NSArray*) allReposForUser:(ACUser*)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter;
-(NSArray*) allReposForQuery:(NSString*)query andPageNumber:(int)pageNumber;
-(ACUser*) repositoryOwner:(ACRepo*)repository;
@end
