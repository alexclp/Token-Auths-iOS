//
//  Networking.m
//  Token Auths
//
//  Created by Alexandru Clapa on 06.08.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "Networking.h"
#import "YahooResponse.h"

#define YahooConsumerKey @"dj0yJmk9bEo2TmFVbTBZMlNvJmQ9WVdrOU5VZHVTWFpJTkdNbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1lOA--"
#define YahooConsumerSecret @"621f893e5e295f8efba1c76a4e4eb8fcb9371e0e%26"

@implementation Networking

- (NSString *)getTimeStamp
{
	NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
	
	//	NSTimeInterval is defined as double
	
	NSNumber *timeStampObj = [NSNumber numberWithDouble:timeStamp];
	
	int timeStampint = [timeStampObj intValue];
	
	return [NSString stringWithFormat:@"%d", timeStampint];
}


- (NSString *)getDataFrom:(NSString *)url
{
//	Setting the request settings
	
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
	
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
	
//	Making the request and receiving response
	
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
	
    if([responseCode statusCode] != 200) {
		
//		Ooops, got an error
		
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
	
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

- (NSString *)createYahooURL
{
	int randomNumber = rand();
	
	NSMutableString *URL = [NSMutableString stringWithFormat:@"%@", @"https://api.login.yahoo.com/oauth/v2/get_request_token?"];
	
	NSDictionary *parameters = @{@"oauth_consumer_key": YahooConsumerKey,
								 @"oauth_signature_method": @"plaintext",
								 @"oauth_signature": YahooConsumerSecret,
								 @"oauth_version": @"1.0",
								 @"xoauth_lang_pref": @"en_us",
								 @"oauth_callback": @"oob",
								 @"oauth_timestamp": [self getTimeStamp],
								 @"oauth_nonce": [NSString stringWithFormat:@"%d", randomNumber]};
	
//	Going through all the keys and objects and creating the URL step by step
	
	for (NSString *parameterTitle in parameters) {
		NSString *stringToAdd = [NSString stringWithFormat:@"%@=%@&", parameterTitle, [parameters objectForKey:parameterTitle]];
		
		[URL appendString:stringToAdd];
	}
	
	return URL.copy;
}

- (YahooResponse *)parseResponse:(NSString *)response
{
	NSLog(@"response = %@", response);
	
	NSArray *substrings = [response componentsSeparatedByString:@"="];
/*
	oauth_token=hamakpw&oauth_token_secret=f0c686731a6f873d9ff30f0aff845d19d6dfed4d&oauth_expires_in=3600&xoauth_request_auth_url=https%3A%2F%2Fapi.login.yahoo.com%2Foauth%2Fv2%2Frequest_auth%3Foauth_token%3Dhamakpw&oauth_callback_confirmed=true
 
	The response looks something like that, so I am separating the substrings that have the sign equals between them at first, and then the one that have the & sign. So what I'm getting is exactly the values that I want. I'm sure there's a better way to do it. Will come up with one later.
*/
	
	NSMutableArray *modifiedSubstrings = [NSMutableArray arrayWithArray:substrings];
	[modifiedSubstrings removeObjectAtIndex:0];
	
	NSString *token = [[[modifiedSubstrings objectAtIndex:0] componentsSeparatedByString:@"&"] objectAtIndex:0];
	[modifiedSubstrings removeObjectAtIndex:0];
	
	NSString *tokenSecret = [[[modifiedSubstrings objectAtIndex:0] componentsSeparatedByString:@"&"] objectAtIndex:0];
	[modifiedSubstrings removeObjectAtIndex:0];
	
	NSString *expireTimer = [[[modifiedSubstrings objectAtIndex:0] componentsSeparatedByString:@"&"] objectAtIndex:0];
	[modifiedSubstrings removeObjectAtIndex:0];
	
	NSString *requestURL = [[[modifiedSubstrings objectAtIndex:0] componentsSeparatedByString:@"&"] objectAtIndex:0];
	[modifiedSubstrings removeObjectAtIndex:0];
	
	NSString *callback = [modifiedSubstrings objectAtIndex:0];
	
	return [YahooResponse getYahooResponseWithData:@[token, tokenSecret, expireTimer, requestURL, callback]];
}

- (NSString *)returnTokenYahoo
{
	NSString *toReturn = @"";
	
	NSString *data = [self getDataFrom:[self createYahooURL]];
	
	YahooResponse *result = [self parseResponse:data];
	
	return toReturn;
}

@end
