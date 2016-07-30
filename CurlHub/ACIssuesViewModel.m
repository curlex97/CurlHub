//
//  ACIssuesViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACIssuesViewModel.h"

@implementation ACIssuesViewModel

-(NSArray *)allIssuesForUser:(ACUser*)user andFilter:(NSString*)filter
{
    return [[[ACHubDataManager alloc] init] issuesForUser:user andFilter:filter];
}

@end
