//
//  UIColor+ACAppColors.m
//  CurlHub
//
//  Created by Arthur Chistyak on 04.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "UIColor+ACAppColors.h"

@implementation UIColor (ACAppColors)


+(UIColor *)alertColor
{
    return [UIColor colorWithRed:218.0/255.0 green:0.0/255.0 blue:15.0/255.0 alpha:1.0];
}

+(UIColor *)messageColor
{
    return [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:218.0/255.0 alpha:1.0];
}

+(UIColor *)darkBackgroundColor
{
    return [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
}

+(UIColor *)foregroundColor
{
    return [UIColor colorWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0];
}

+(UIColor *)cellSelectionColor
{
    return [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
}

+(UIColor *)lightBackgroundColor
{
    return [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
}

@end
