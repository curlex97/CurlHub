//
//  ACEventsViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACEventsViewModel.h"

@implementation ACEventsViewModel

-(NSArray *)allEventsForUser:(ACUser *)user
{
    ACHubDataManager *manager = [[ACHubDataManager alloc] init];
    return [manager eventsForUser:user];
}

@end
