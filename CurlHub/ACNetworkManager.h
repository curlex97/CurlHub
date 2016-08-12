//
//  ACNetworkManager.h
//  CurlHub
//
//  Created by Arthur Chistyak on 07.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACNetworkManager : NSObject

// данные по адресу
+(NSData*) dataByUrl:(NSString*)url;

// строка по адресу
+(NSString*) stringByUrl:(NSString*)url;


+(void)dataByUrlAsync:(NSString *)url andHeaderDictionary:(NSDictionary*)headerDictionary andBodyDictionary:(NSDictionary*)bodyDictionary andQueryType:(NSString*)queryType completion:(void (^)(NSData*))completed;


@end
