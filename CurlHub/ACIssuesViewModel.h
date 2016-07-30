//
//  ACIssuesViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACIssue.h"
#import "ACHubDataManager.h"
#import "ACUser.h"
@interface ACIssuesViewModel : NSObject

-(NSArray*)allIssuesForUser:(ACUser*)user andFilter:(NSString*)filter;

@end
