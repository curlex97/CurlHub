//
//  UserViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUser.h"
#import "ACHubDataManager.h"

static ACUser* systemUser;

@interface ACUserViewModel : NSObject
@property ACUser *currentUser;

// логин при наличии кода
-(void)loginWithCode:(NSString*)code completion:(void (^)(ACUser*))completed;

// выход из системы
-(void) logout;

// список юзеров через неформатированную строку поиска
-(NSArray*)allUsersForQuery:(NSString *)query andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;

// список подписчиков пользователя
-(NSArray<ACUser*>*) userFollowers:(ACUser*)user andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;

// список подписок пользотвалея
-(NSArray<ACUser*>*) userFollowing:(ACUser*)user andPageNumber:(int)pageNumber andCurrentUser:(ACUser*)currentUser;

-(void) updateUserAsync:(NSDictionary*)properties andUser:(ACUser*)user completion:(void(^)(void))completed;


+(void) setSystemUser:(ACUser*)user;
+(ACUser*) systemUser;


@end
