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

-(NSArray<ACCommit *> *)commentsForCommit:(ACCommit *)commit andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;
-(void)commentOnCommitAsync:(NSString *)comment andCommit:(ACCommit *)commit andUser:(ACUser *)user completion:(void (^)(void))completed;
-(void)deleteCommentFromCommitAsync:(ACComment*)comment andCommit:(ACCommit *)commit andUser:(ACUser *)user completion:(void (^)(void))completed;
@end
