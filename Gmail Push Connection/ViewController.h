//
//  ViewController.h
//  Gmail Push Connection
//
//  Created by Alexandru Clapa on 08.06.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OAuthiOS/OAuthiOS.h>

#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "YahooSDK.h"

@interface ViewController : UIViewController <YahooSessionDelegate>

@property (strong, nonatomic) NSString *currentEmailAddress;
@property (strong, nonatomic) YahooSession *session;

- (IBAction)gmailButtonClicked:(id)sender;
- (IBAction)yahooButtonClicked:(id)sender;
- (IBAction)outlookButtonClicked:(id)sender;
- (IBAction)refreshToken:(id)sender;

@end
