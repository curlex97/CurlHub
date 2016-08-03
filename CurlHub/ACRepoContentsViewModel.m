//
//  ACRepoContentsViewModel.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACRepoContentsViewModel.h"

@implementation ACRepoContentsViewModel

-(NSArray *)filesListFromUrl:(NSString *)url
{
    return [[[ACHubDataManager alloc] init] filesAndDirectoriesFromUrl:url];
}


// Not used
+(NSURLRequest *)highlightedTextUrlWithUrl:(NSString *)url
{
    NSString* text = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    NSURLRequest* request = [ACHubDataManager contentTextUrlWithText:text];
    return request;
}

@end
