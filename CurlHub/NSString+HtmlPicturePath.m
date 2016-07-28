//
//  NSString+HtmlPicturePath.m
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "NSString+HtmlPicturePath.h"

@implementation NSString (HtmlPicturePath)

-(NSString*) stringByHtmlPictureFormating;
{
    return [[[[[[[self stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"?" withString:@""] stringByReplacingOccurrencesOfString:@"?" withString:@""] stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
