//
//  YahooResponse.m
//  Token Auths
//
//  Created by Alexandru Clapa on 07.08.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "YahooResponse.h"

@implementation YahooResponse

+ (YahooResponse *)getYahooResponseWithToken:(NSString *)token tokenSecret:(NSString *)tokenSecret expireTimer:(NSString *)timer oauthRequestURL:(NSString *)URL andCallBackConfirmed:(NSString *)status
{
	YahooResponse *toReturn = [[YahooResponse alloc] init];
	
	toReturn.token = token;
	toReturn.tokenSecret = tokenSecret;
	toReturn.expireTimer = timer;
	toReturn.requestURL = URL;
	toReturn.callBackConfirmed = status;
	
	return toReturn;
}

@end
