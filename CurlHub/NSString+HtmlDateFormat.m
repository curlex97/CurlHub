//
//  NSString+HtmlDateFormat.m
//  CurlHub
//
//  Created by Arthur Chistyak on 07.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "NSString+HtmlDateFormat.h"

@implementation NSString (HtmlDateFormat)


+(NSString*) formatDateWithString:(NSString*)string
{
    return [[string substringToIndex:[string rangeOfString:@"T"].location] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

@end
