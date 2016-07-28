//
//  ACPictureManager.h
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPictureManager : NSObject
+(NSMutableDictionary*) picturesDictionary;
+(void) addPicture:(UIImage*)picture byName:(NSString*)name;
+(UIImage*) getPictureByName:(NSString*)name;
+(void) downloadImageByUrlAsync:(NSString*)url andCompletion: (void(^)(UIImage*))downloadComleted;
@end
