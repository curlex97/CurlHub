//
//  ACPictureManager.h
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+HtmlPicturePath.h"
#import "ACNetworkManager.h"

@interface ACPictureManager : NSObject

// все изображения, лежащие в ПЗУ
+(NSMutableDictionary*) picturesDictionary;

// сохраняет картинку в ПЗУ
+(void) addPicture:(UIImage*)picture byName:(NSString*)name;

// возвращает картинку из ПЗУ по имени
+(UIImage*) getPictureByName:(NSString*)name;

// возвращает изображение (из ПЗУ, если нет - из интернета) по его адресу
+(void) downloadImageByUrlAsync:(NSString*)url andCompletion: (void(^)(UIImage*))downloadComleted;

@end
