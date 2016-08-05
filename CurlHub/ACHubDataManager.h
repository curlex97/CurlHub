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
#import "ACNews.h"
#import "ACIssue.h"
#import "ACRepoFile.h"
#import "ACRepoDirectory.h"
#import "ACIssueEvent.h"

@interface ACHubDataManager : NSObject

+(NSString*) callbackUrl;
+(NSString*) verificationUrl;
+(NSString*) tokenUrl :(NSString*)code;
+(NSString*) userUrl :(NSString*)token;
+(NSString*) eventsUrl :(NSString*)userLogin andPageNumber:(int)pageNumber;
+(NSString*) reposUrl :(NSString*)userLogin andPageNumber:(int)pageNumber andFilter:(NSString*)filter;
+(NSString*) searchReposUrl :(NSString*)query andPageNumber:(int)pageNumber;
+(NSString *)searchUsersUrl:(NSString *)query andPageNumber:(int)pageNumber;
+(NSString*) newsUrl;
+(NSString*) issuesUrlWithUrl:(NSString*)issuesUrl andFilter:(NSString*)filter;
+(NSString*) anotherUrl:(NSString*)url;


-(NSString*) formatDateWithString:(NSString*)string;

-(ACUser*)userFromToken:(NSString*)token;
-(ACUser*)userFromUrl:(NSString*)url;
-(NSString*) tokenFromCode:(NSString*)code;

-(NSArray<ACEvent*>*) eventsForUser:(ACUser*)user andPageNumber:(int)pageNumber;
-(NSArray<ACRepo*>*) reposForUser:(ACUser*)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter;
-(NSArray<ACRepo*>*) reposForQuery:(NSString*)query andPageNumber:(int)pageNumber;
-(NSArray<ACUser*>*) usersForQuery:(NSString*)query andPageNumber:(int)pageNumber;
-(NSArray<ACIssueEvent*>*) eventsForIssue:(ACIssue*)issue;


-(NSArray<ACNews*>*) news;
-(NSArray<ACIssue*>*) issuesForUser:(ACUser*)user andFilter:(NSString*)filter;

-(NSArray*) filesAndDirectoriesFromUrl:(NSString*)url;

//Not used
+(NSURLRequest*) contentTextUrlWithText:(NSString*)text;

@end
