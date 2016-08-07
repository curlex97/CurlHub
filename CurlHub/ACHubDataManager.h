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
#import "ACPictureManager.h"
#import "NSString+HtmlPicturePath.h"
#import "NSString+HtmlDateFormat.h"
#import "ACNetworkManager.h"

@interface ACHubDataManager : NSObject

// адрес моего сайта
+(NSString*) callbackUrl;

// адрес авторизации пользователя
+(NSString*) verificationUrl;

// адрес получения токена
+(NSString*) tokenUrl :(NSString*)code;

// адрес получения текущего пользователя
+(NSString*) userUrl :(NSString*)token;

// адрес получения списка событий
+(NSString*) eventsUrl :(NSString*)userLogin andPageNumber:(int)pageNumber;

// адрес получения списка репозиториев пользователя
+(NSString*) reposUrl :(NSString*)userLogin andPageNumber:(int)pageNumber andFilter:(NSString*)filter;

// адрес получения списка репозиториев через поиск
+(NSString*) searchReposUrl :(NSString*)query andPageNumber:(int)pageNumber;

// адрес получения списка пользователей через поиск
+(NSString *)searchUsersUrl:(NSString *)query andPageNumber:(int)pageNumber;

// адрес получения списка новостей
+(NSString*) newsUrl;

// адрес получения списка заданий
+(NSString*) issuesUrlWithUrl:(NSString*)issuesUrl andFilter:(NSString*)filter;

// адрес для доступа к гитхабу (подставляет идентификатор и секретный ключ)
+(NSString*) anotherUrl:(NSString*)url;

// страница адреса подтверждения
+(NSString*) pageWithVerificationUrl;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// текущий пользователь через токен
-(ACUser*)userFromToken:(NSString*)token;

// пользователь через адрес
-(ACUser*)userFromUrl:(NSString*)url;

// токен через промежуточный код
-(NSString*) tokenFromCode:(NSString*)code;

// список событий для пользователя через пользователя и номер страницы
-(NSArray<ACEvent*>*) eventsForUser:(ACUser*)user andPageNumber:(int)pageNumber;

// список репозиториев для пользователя через пользователя, номер страницы и фильтр (all, owner, member)
-(NSArray<ACRepo*>*) reposForUser:(ACUser*)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter;

// список репозиториев через неформатированный запрос и номер страницы
-(NSArray<ACRepo*>*) reposForQuery:(NSString*)query andPageNumber:(int)pageNumber;

// список пользователей через неформатированный запрос и номер страницы
-(NSArray<ACUser*>*) usersForQuery:(NSString*)query andPageNumber:(int)pageNumber;

// список событий задания через задание
-(NSArray<ACIssueEvent*>*) eventsForIssue:(ACIssue*)issue;

// список новостей пользователя
-(NSArray<ACNews*>*) news;

// список заданий для пользователя через пользователя и фильтр (all, open, closed)
-(NSArray<ACIssue*>*) issuesForUser:(ACUser*)user andFilter:(NSString*)filter;

// список файлов и папок через адрес
-(NSArray*) filesAndDirectoriesFromUrl:(NSString*)url;

// содержимое файла через файл
-(NSString *)textContentWithFile:(ACRepoFile *)file;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@end
