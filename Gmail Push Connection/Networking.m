//
//  Networking.m
//  Token Auths
//
//  Created by Alexandru Clapa on 06.08.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "Networking.h"

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

- (NSString *)parseJSON:(NSString *)JSON
{
	NSError *theError = NULL;
	
	NSDictionary *parsedDictionary = [NSDictionary dictionaryWithJSONString:JSON error:&theError];
	
	NSLog(@"dict = %@", parsedDictionary);
	
	return @"";
}

- (NSString *)returnTokenYahoo
{
	NSString *toReturn = @"";
	
	NSString *data = [self getDataFrom:[self createYahooURL]];
	
	NSString *result = [self parseJSON:data];
	
	return toReturn;
}

@end
