//
//  ACHubDataManager.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"
#import "ACEvent.h"

@interface ACHubDataManager : NSObject

+(NSString*) verificationUrl;
+(NSString*) tokenUrl :(NSString*)code;
+(NSString*) userUrl :(NSString*)token;
+(NSString*) eventsUrl :(NSString*)userLogin;


-(ACUser*)userFromToken:(NSString*)token;
-(NSString*) tokenFromCode:(NSString*)code;

-(NSArray<ACEvent*>*) eventsForUser:(ACUser*)user;

@end
