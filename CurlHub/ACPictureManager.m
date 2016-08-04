//
//  ACPictureManager.m
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACPictureManager.h"
#import "NSString+HtmlPicturePath.h"

static NSMutableDictionary *picturesDictionary;


@implementation ACPictureManager

+(NSMutableDictionary*)picturesDictionary
{
    if(!picturesDictionary){
        [ACPictureManager setupPictureDictionary];
    }
    return picturesDictionary;
}

+(void) setupPictureDictionary
{
    picturesDictionary = [NSMutableDictionary dictionary];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents"]];
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"];
    NSArray *picPathes = [directoryContents filteredArrayUsingPredicate:predicate];
    
    for(NSString* picPath in picPathes)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", picPath]]];
        NSString *name = [[picPath stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@".png" withString:@""];
        [picturesDictionary setObject:image forKey:name];
    }
}

+(void)addPicture:(UIImage *)picture byName:(NSString *)name
{
    if(picture && name){
    [picturesDictionary setObject:picture forKey:name];
        NSString *realName = [name stringByHtmlPictureFormating];
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png", realName]];
        [UIImagePNGRepresentation(picture) writeToFile:path atomically:YES];
    }
}

+(UIImage*)getPictureByName:(NSString *)name
{
    if(!picturesDictionary) [ACPictureManager setupPictureDictionary];
    NSString *realName = [name stringByHtmlPictureFormating];
    return picturesDictionary[realName];
}

+(void)downloadImageByUrlAsync:(NSString *)url andCompletion:(void (^)(UIImage *))downloadComleted
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [ACPictureManager getPictureByName:url];
        if(!image)
        {
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
            image = [UIImage imageWithData: data];
            if(image) [ACPictureManager addPicture:[UIImage imageWithData: data] byName:url];
        }
        dispatch_async(dispatch_get_main_queue(), ^{downloadComleted(image);});
    });
    
    
}

@end
