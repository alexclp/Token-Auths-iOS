//
//  YahooResponse.h
//  Token Auths
//
//  Created by Alexandru Clapa on 07.08.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooResponse : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *tokenSecret;
@property (strong, nonatomic) NSString *expireTimer;
@property (strong, nonatomic) NSString *requestURL;
@property (strong, nonatomic) NSString *callBackConfirmed;

+ (YahooResponse *)getYahooResponseWithData:(NSArray *)data;

@end
