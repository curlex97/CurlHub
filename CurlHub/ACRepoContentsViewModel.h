//
//  ACRepoContentsViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACHubDataManager.h"
#import "ACRepoDirectory.h"
#import "ACRepoFile.h"

@interface ACRepoContentsViewModel : NSObject

-(NSArray*) filesListFromUrl:(NSString*)url;

@end
