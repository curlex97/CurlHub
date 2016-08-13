//
//  UserViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACUserViewModel.h"


@implementation ACUserViewModel

-(void)loginWithCode:(NSString*)code completion:(void (^)(ACUser*))completed
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{

        NSString* localToken = [self readTokenFromFile];
        
        if(!localToken || localToken.length == 0){
            localToken =[[[ACHubDataManager alloc] init] tokenFromCode:code];
        }
        
        if(localToken)
        {
            self.currentUser = [[[ACHubDataManager alloc] init] userFromToken:localToken];
            
            if(!self.currentUser)
            {
                localToken =[[[ACHubDataManager alloc] init] tokenFromCode:code];
                self.currentUser = [[[ACHubDataManager alloc] init] userFromToken:localToken];
            }
            
            if(self.currentUser)
            {
                [self writeTokenToFile];
                systemUser = self.currentUser;
                completed(self.currentUser);
            }
        }
        else
        {
            completed(nil);
        }
        
    });
}

-(NSArray *)allUsersForQuery:(NSString *)query andPageNumber:(int)pageNumber andCurrentUser:(ACUser*) currentUser
{
    return [[[ACHubDataManager alloc] init] usersForQuery:query andPageNumber:pageNumber andCurrentUser:currentUser];
}

-(NSArray<ACUser *> *)userFollowers:(ACUser *)user andPageNumber:(int)pageNumber andCurrentUser:(ACUser*) currentUser
{
    return [[[ACHubDataManager alloc] init] userFollowers:user andPageNumber:pageNumber andCurrentUser:currentUser];
}


-(NSArray<ACUser *> *)userFollowing:(ACUser *)user andPageNumber:(int)pageNumber andCurrentUser:(ACUser*) currentUser
{
    return [[[ACHubDataManager alloc] init] userFollowing:user andPageNumber:pageNumber andCurrentUser:currentUser];
}

-(void) writeTokenToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    [self.currentUser.accessToken writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString*) readTokenFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

-(void)logout
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)updateUserAsync:(NSDictionary *)properties andUser:(ACUser *)user completion:(void (^)(void))completed
{
    [[[ACHubDataManager alloc] init] updateUserAsync:properties andUser:user completion:completed];
}

+(ACUser *)systemUser
{
    return systemUser;
}

+(void)setSystemUser:(ACUser *)user
{
   systemUser = user;
}


@end
