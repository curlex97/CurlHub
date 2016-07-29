//
//  ACRepo.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepo.h"

@implementation ACRepo

-(instancetype)initWithName:(NSString *)name andOwnerName:(NSString *)ownerName andOwnerAvatarUrl:(NSString *)ownerAvatarUrl andLanguage:(NSString *)language andCreateDate:(NSString *)createDate andSize:(double)size andForksCount:(long)forksCount andWatchersCount:(long)watchersCount andBranchesCount:(long)branchesCount andStargazersCount:(long)stargazersCount andIssuesCount:(long)issuesCount andPrivate:(BOOL)isPrivate andIssuesUrl:(NSString *)issuesUrl
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.ownerName = ownerName;
        self.ownerAvatarUrl = ownerAvatarUrl;
        self.language = language;
        self.createDate = createDate;
        self.size = size;
        self.forksCount = forksCount;
        self.watchersCount = watchersCount;
        self.branchesCount = branchesCount;
        self.stargazersCount = stargazersCount;
        self.issuesCount = issuesCount;
        self.isPrivate = isPrivate;
        self.issuesUrl = issuesUrl;
    }
    return self;
}


@end
