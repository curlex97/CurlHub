//
//  ACCommentsViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACHubDataManager.h"

@interface ACCommentsViewModel : NSObject

-(NSArray<ACCommit *> *)commentsForCommit:(ACCommit *)commit andPageNumber:(int)pageNumber;

@end
