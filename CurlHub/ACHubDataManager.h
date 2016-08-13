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
#import "NSString+HtmlPicturePath.h"
#import "NSString+HtmlDateFormat.h"
#import "ACNetworkManager.h"
#import "ACCommit.h"
#import "ACComment.h"

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
+(NSString *)reposUrl:(NSString *)userLogin andPageNumber:(int)pageNumber andFilter:(NSString*)filter andUser:(ACUser*)user;

// адрес получения списка репозиториев через поиск
+(NSString *)searchReposUrl:(NSString *)query andPageNumber:(int)pageNumber andUser:(ACUser*)user;

// адрес получения списка пользователей через поиск
+(NSString *)searchUsersUrl:(NSString *)query andPageNumber:(int)pageNumber andUser:(ACUser*)user;

// адрес получения списка новостей
+(NSString*) newsUrl;

// адрес получения списка заданий
+(NSString *)issuesUrlWithUrl:(NSString *)issuesUrl andFilter:(NSString*)filter andUser:(ACUser*)user;

// адрес для доступа к гитхабу (подставляет идентификатор и секретный ключ)
+(NSString*) anotherUrl:(NSString*)url andUser:(ACUser*)user;

// адрес для доступа к гитхабу (подставляет идентификатор, секретный ключ и номер страницы)
+(NSString *)anotherUrl:(NSString *)url withPageNumber:(int)pageNaumber andUser:(ACUser*)user;

// страница адреса подтверждения
+(NSString*) pageWithVerificationUrl;

// старринг
+(NSString*)starUrlWithRepo:(ACRepo*)repo andUser:(ACUser*)user;

// вотчинг
+(NSString*)watchUrlWithRepo:(ACRepo*)repo andUser:(ACUser*)user;

// апдейт пропертей пользователя
+(NSString *)userUpdateUrlWithUser:(ACUser*)user;

// добавить комментарий коммиту
+(NSString *)commentOnUrlWithCommit:(ACCommit *)commit andUser:(ACUser*)user;

// удалить комментарий коммиту
+(NSString *)deleteCommentUrlWithCommit:(ACCommit *)commit andComment:(ACComment *)comment andUser:(ACUser*)user;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// текущий пользователь через токен
-(ACUser*)userFromToken:(NSString*)token;

// пользователь через адрес
-(ACUser*) userFromUrl:(NSString*)url andUser:(ACUser*)user;

// токен через промежуточный код
-(NSString*) tokenFromCode:(NSString*)code;

// список событий для пользователя через пользователя и номер страницы
-(NSArray<ACEvent*>*) eventsForUser:(ACUser*)user andPageNumber:(int)pageNumber;

// список репозиториев для пользователя через пользователя, номер страницы и фильтр (all, owner, member)
-(NSArray<ACRepo *> *)reposForUser:(ACUser *)user andPageNumber:(int)pageNumber andFilter:(NSString*)filter andCurrentUser:(ACUser*)currentUser;

// список репозиториев через неформатированный запрос и номер страницы
-(NSArray<ACRepo *> *)reposForQuery:(NSString *)query andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)user;

// список пользователей через неформатированный запрос и номер страницы
-(NSArray<ACUser *> *)usersForQuery:(NSString *)query andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;

// список подписчиков пользователя
-(NSArray<ACUser *> *)userFollowers:(ACUser *)user andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;

// список подписок пользотвалея
-(NSArray<ACUser *> *)userFollowing:(ACUser *)user andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;

// список событий задания через задание
-(NSArray<ACIssueEvent *> *)eventsForIssue:(ACIssue *)issue andCurrentUser:(ACUser*)currentUser;

// список новостей пользователя
-(NSArray<ACNews*>*) news;

// список заданий для пользователя через пользователя и фильтр (all, open, closed)
-(NSArray<ACIssue *> *)issuesForUser:(ACUser *)user andFilter:(NSString*)filter andCurrentUser:(ACUser*) currentUser;

// список файлов и папок через адрес
-(NSArray*) filesAndDirectoriesFromDirectory:(ACRepoDirectory*)directory andUser:(ACUser*)user;

// содержимое файла через файл
-(NSString *)textContentWithFile:(ACRepoFile *)file;

// получаем репозиторий, о котором пишется в событии
-(ACRepo*) repoFromEvent:(ACEvent*)event andCurrentUser:(ACUser*)user;

// получаем список коммитов репозитория
-(NSArray<ACCommit *> *)commitsForRepo:(ACRepo *)repo andPageNumber:(int)pageNumber andUser:(ACUser*)user;

// получаем список комментариев коммита
-(NSArray<ACCommit *> *)commentsForCommit:(ACCommit *)commit andPageNumber:(int)pageNumber andUser:(ACUser*)user;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// старим репозиторий (юзер - системный юзер)
-(void) starRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

// анстарим репозиторий (юзер - системный юзер)
-(void) unstarRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

// проверяем застарили ли репозиторий (юзер - системный юзер)
-(void) isStarringRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(BOOL))completed;

// начинаем наблюдать за репозиторием (юзер - системный юзер)
-(void) watchRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

// прекращаем наблюдать за репозиторием (юзер - системный юзер)
-(void) unwatchRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(void))completed;

// проверяем наблюдаем ли за репозиторием (юзер - системный юзер)
-(void) isWatchingRepoAsync:(ACRepo*)repo andUser:(ACUser*)user completion:(void(^)(BOOL))completed;

// апдейтим информацию о залогиненном пользователе (юзер - системный юзер)
-(void) updateUserAsync:(NSDictionary*)properties andUser:(ACUser*)user completion:(void(^)(void))completed;

-(void)commentOnCommitAsync:(NSString *)comment andCommit:(ACCommit *)commit andUser:(ACUser *)user completion:(void (^)(void))completed;

-(void)deleteCommentFromCommitAsync:(ACComment*)comment andCommit:(ACCommit *)commit andUser:(ACUser *)user completion:(void (^)(void))completed;
@end
