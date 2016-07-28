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
+(NSString*) eventsUrl :(NSString*)userLogin andPageNumber:(int)pageNumber;
+(NSString*) reposUrl :(NSString*)userLogin andPageNumber:(int)pageNumber;
+(NSString*) searchReposUrl :(NSString*)query andPageNumber:(int)pageNumber;

-(NSString*) formatDateWithString:(NSString*)string;

-(ACUser*)userFromToken:(NSString*)token;
-(NSString*) tokenFromCode:(NSString*)code;

-(NSArray<ACEvent*>*) eventsForUser:(ACUser*)user andPageNumber:(int)pageNumber;
-(NSArray<ACRepo*>*) reposForUser:(ACUser*)user andPageNumber:(int)pageNumber;
-(NSArray<ACRepo*>*) reposForQuery:(NSString*)query andPageNumber:(int)pageNumber;

@end
