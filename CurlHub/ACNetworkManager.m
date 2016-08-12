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

+(void)dataByUrlAsync:(NSString *)url andHeaderDictionary:(NSDictionary*)headerDictionary andBodyDictionary:(NSDictionary*)bodyDictionary andQueryType:(NSString*)queryType completion:(void (^)(NSData*))completed
{
    NSURL *URL = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:queryType];
    
    for(NSString* key in headerDictionary.allKeys)
    {
        [request setValue:[headerDictionary valueForKey:key] forHTTPHeaderField:key];
    }
    
    if(bodyDictionary && bodyDictionary.count > 0)
    {
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", [postdata length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postdata];
    }
    else if(![queryType  isEqual: @"GET"])
    {
        [request setValue:[NSString stringWithFormat:@"0"] forHTTPHeaderField:@"Content-Length"];
    }
    
//    [request setValue:[NSString stringWithFormat:@"token b54ba4f473e5e467a3ab2d8bc75885a7867ed6e0"] forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(!error)completed(data);
                                      else completed(nil);
                                  }];
    
    [task resume];
}


/*
 

 */

@end
