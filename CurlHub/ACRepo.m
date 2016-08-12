//
//  ACRepo.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepo.h"

@implementation ACRepo

-(instancetype)initWithName:(NSString *)name andFullName:(NSString*)fullName andOwnerName:(NSString *)ownerName andOwnerAvatarUrl:(NSString *)ownerAvatarUrl andLanguage:(NSString *)language andCreateDate:(NSString *)createDate andSize:(double)size andForksCount:(long)forksCount andWatchersCount:(long)watchersCount andBranchesCount:(long)branchesCount andStargazersCount:(long)stargazersCount andIssuesCount:(long)issuesCount andPrivate:(BOOL)isPrivate andIsStarring:(BOOL)isStarring andIsWatching:(BOOL)isWatching andIssuesUrl:(NSString *)issuesUrl andContentsUrl:(NSString*)contentsUrl andHtmlUrl:(NSString *)htmlUrl andOwnerUrl:(NSString*)ownerUrl andBranchesUrl:(NSString *)branchesUrl
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.fullName = fullName;
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
        self.isStarring = isStarring;
        self.isWatching = isWatching;
        self.issuesUrl = issuesUrl;
        self.contentsUrl = contentsUrl;
        self.htmlUrl = htmlUrl;
        self.ownerUrl = ownerUrl;
        self.branchesUrl = branchesUrl;
    }
    return self;
}


@end
