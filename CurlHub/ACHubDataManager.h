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
#import "ACRepo.h"

@interface ACHubDataManager : NSObject

+(NSString*) verificationUrl;
+(NSString*) tokenUrl :(NSString*)code;
+(NSString*) userUrl :(NSString*)token;
+(NSString*) eventsUrl :(NSString*)userLogin;
+(NSString*) reposUrl :(NSString*)userLogin;
+(NSString*) searchReposUrl :(NSString*)query andPageNumber:(int)pageNumber;

-(NSString*) formatDateWithString:(NSString*)string;

-(ACUser*)userFromToken:(NSString*)token;
-(NSString*) tokenFromCode:(NSString*)code;

-(NSArray<ACEvent*>*) eventsForUser:(ACUser*)user;
-(NSArray<ACRepo*>*) reposForUser:(ACUser*)user;
-(NSArray<ACRepo*>*) reposForQuery:(NSString*)query andPageNumber:(int)pageNumber;

@end
