//
//  ACCommentsViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACCommentsViewModel.h"

@implementation ACCommentsViewModel

-(NSArray<ACCommit *> *)commentsForCommit:(ACCommit *)commit andPageNumber:(int)pageNumber
{
    return [[[ACHubDataManager alloc] init] commentsForCommit:commit andPageNumber:pageNumber];
}

@end
