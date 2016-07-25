//
//  UserViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"

@interface ACUserViewModel : NSObject
@property ACUser *currentUser;

-(void)loginWithCode:(NSString*)code completion:(void (^)(ACUser*))completed;

@end
