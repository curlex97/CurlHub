//
//  ACNewsViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACNewsViewModel.h"

@implementation ACNewsViewModel

-(NSArray *)allNews
{
    return [[[ACHubDataManager alloc] init] news];
}

@end
