//
//  ACNetworkManager.m
//  CurlHub
//
//  Created by Arthur Chistyak on 07.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACNetworkManager.h"

@implementation ACNetworkManager

+(NSData*) dataByUrl:(NSString*)url
{
    return [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
}

+(NSString*) stringByUrl:(NSString*)url
{
    @try{
    return [NSString stringWithContentsOfURL:[NSURL URLWithString: url] encoding:NSUTF8StringEncoding error:nil];
    }
   @catch(NSException* ex)
    {
        return nil;
    }
}

@end
