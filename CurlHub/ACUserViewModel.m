//
//  UserViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACUserViewModel.h"
#import "ACHubDataManager.h"

@implementation ACUserViewModel

-(void)loginWithCode:(NSString*)code completion:(void (^)(ACUser*))completed
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{

        NSString* localToken = [self readTokenFromFile];
        
        if(!localToken){
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
                completed(self.currentUser);
            }
        }
        
    });
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

@end