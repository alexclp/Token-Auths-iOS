//
//  AccountAdderToServer.h
//  Token Auths
//
//  Created by Alexandru Clapa on 07.09.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountAdderToServer : NSObject

+ (AccountAdderToServer *)sharedManager;

- (void)addGmailAccountWithParameters:(NSDictionary *)parameters;
- (void)addYahooAccountWithParameters:(NSDictionary *)parameters;

@end
