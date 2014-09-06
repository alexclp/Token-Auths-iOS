//
//  AccountAdderToServer.m
//  Token Auths
//
//  Created by Alexandru Clapa on 07.09.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "AccountAdderToServer.h"
#import "AFHTTPRequestOperationManager.h"

@implementation AccountAdderToServer

static AccountAdderToServer *sharedInstance = nil;

+ (AccountAdderToServer *)sharedManager
{
	if(!sharedInstance) {
        sharedInstance = [AccountAdderToServer new];
    }
    
    return sharedInstance;
}

- (void)addGmailAccountWithParameters:(NSDictionary *)parameters
{
	NSLog(@"parameters = %@", parameters);
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)addYahooAccountWithParameters:(NSDictionary *)parameters
{
	NSLog(@"parameters = %@", parameters);
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

@end