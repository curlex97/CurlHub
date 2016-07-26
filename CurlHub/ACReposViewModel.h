//
//  ACReposViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"

@interface ACReposViewModel : NSObject

-(NSArray*) allReposForUser:(ACUser*)user;
-(NSArray*) allReposForQuery:(NSString*)query andPageNumber:(int)pageNumber;

@end
