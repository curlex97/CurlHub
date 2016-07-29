//
//  ACRepo.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACRepo : NSObject

@property NSString* name;
@property NSString* ownerName;
@property NSString *ownerAvatarUrl;
@property NSString* language;
@property NSString* issuesUrl;
@property NSString* createDate;

@property double size;

@property long forksCount;
@property long watchersCount;
@property long branchesCount;
@property long stargazersCount;
@property long issuesCount;

@property BOOL isPrivate;



-(instancetype)initWithName:(NSString*)name andOwnerName:(NSString*)ownerName andOwnerAvatarUrl:(NSString*)ownerAvatarUrl andLanguage:(NSString*)language andCreateDate:(NSString*)createDate andSize:(double)size andForksCount:(long)forksCount andWatchersCount:(long)watchersCount andBranchesCount:(long)branchesCount andStargazersCount:(long)stargazersCount andIssuesCount:(long)issuesCount andPrivate:(BOOL)isPrivate andIssuesUrl:(NSString*)issuesUrl;

@end
