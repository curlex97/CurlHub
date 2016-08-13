//
//  ACCommitViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCommit.h"
#import "ACHubDataManager.h"

@interface ACCommitsViewModel : NSObject
-(NSArray<ACCommit *> *)commitsForRepo:(ACRepo *)repo andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;
@end
