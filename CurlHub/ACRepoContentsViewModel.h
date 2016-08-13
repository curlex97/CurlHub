//
//  ACRepoContentsViewModel.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACHubDataManager.h"
#import "ACRepoDirectory.h"
#import "ACRepoFile.h"

@interface ACRepoContentsViewModel : NSObject

// список всех файлов и папок по адресу
-(NSArray *)filesListFromDirectory:(ACRepoDirectory *)directory andCurrentUser:(ACUser*)currentUser;
// содержимое файла
-(NSString*) textContentWithFile:(ACRepoFile*)file;

@end
