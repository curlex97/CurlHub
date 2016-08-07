//
//  ACEventsViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACHubDataManager.h"
#import "ACUser.h"

@interface ACEventsViewModel : NSObject

// список событий для пользователя
-(NSArray*) allEventsForUser:(ACUser*)user andPageNumber:(int)pageNumber;

@end
