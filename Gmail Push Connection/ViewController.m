//
//  ViewController.m
//  Gmail Push Connection
//
//  Created by Alexandru Clapa on 08.06.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Networking.h"

#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"

#import "YOSSocial.h"

/*
#define GoogleClientID @"452674355061-pfphf42qr8p97o4vb9917ed1bc57fd42.apps.googleusercontent.com"
#define GoogleClientSecret @"aaRo9WyJrhl4-eKBQ8pAytmm"
*/

///*

#define GoogleClientID    @"997352802958-evpubtvdrtmueh20rd938625tpo2b5s8.apps.googleusercontent.com"
#define GoogleClientSecret @"fHwEmNBQKKyqKmmnotThEM-g"

//*/

#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"

#define YahooConsumerKey @"dj0yJmk9bEo2TmFVbTBZMlNvJmQ9WVdrOU5VZHVTWFpJTkdNbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1lOA--"
#define YahooConsumerSecret @"621f893e5e295f8efba1c76a4e4eb8fcb9371e0e%26"
#define YahooApplicationID @"5GnIvH4c"
#define kYahooKeychainItemName @"OAuth Sample: Yahoo"

static NSString *redirectURI = @"urn:ietf:wg:oauth:2.0:oob";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GMAIL

- (IBAction)gmailButtonClicked:(id)sender
{
	
	NSURL *tokenURL = [NSURL URLWithString:GoogleTokenURL];
	
//    NSString *redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
	
    GTMOAuth2Authentication *auth;
	
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"google"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:GoogleClientID
                                                         clientSecret:GoogleClientSecret];
	
    auth.scope = @"https://www.googleapis.com/auth/plus.me";
	
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                                                authorizationURL:[NSURL URLWithString:GoogleAuthURL]
                                                                                                keychainItemName:@"GoogleKeychainName" delegate:self
                                                                                                finishedSelector:@selector(viewController:finishedWithAuth:error:)];
	
    [self.navigationController pushViewController:viewController animated:YES];
	
}

//this method is called when authentication finished

- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController finishedWithAuth:(GTMOAuth2Authentication * )auth error:(NSError * )error
{	
    if (error != nil) {
		
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Authorizing with Google"
                                                         message:[error localizedDescription]
                                                        delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		
        [alert show];
		
		
		
    } else {
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert !"
                                                         message:@"success"
                                                        delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
        [alert show];
		
//		NSLog(@"token = %@", auth.accessToken);
		
//		[self tokenRequestWithCode:auth.code];
		
    }
}

- (NSString *)getTimeStamp
{
	NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//	NSTimeInterval is defined as double
	
	NSNumber *timeStampObj = [NSNumber numberWithDouble:timeStamp];
	
	int timeStampint = [timeStampObj intValue];
	
	return [NSString stringWithFormat:@"%d", timeStampint];
}

#pragma mark YAHOO

- (GTMOAuthAuthentication *)authForYahoo
{
	GTMOAuthAuthentication *auth;
	
	auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1 consumerKey:YahooConsumerKey privateKey:YahooConsumerSecret];
	
	[auth setServiceProvider:@"Yahoo"];
	
	return auth;
}

- (IBAction)yahooButtonClicked:(id)sender
{
//	Networking *instance = [[Networking alloc] init];
	
//	[instance returnTokenYahoo];
	/*
	NSURL *requestURL = [NSURL URLWithString:@"https://api.login.yahoo.com/oauth/v2/get_request_token"];
	NSURL *accessURL = [NSURL URLWithString:@"https://api.login.yahoo.com/oauth/v2/get_token"];
	NSURL *authorizeURL = [NSURL URLWithString:@"https://api.login.yahoo.com/oauth/v2/request_auth"];
	NSString *scope = @"https://api.login.yahoo.com";
	
	GTMOAuthAuthentication *auth = [self authForYahoo];
	if (auth == nil) {
		NSLog(@"Auth not initialized");
	}
	
	[auth setCallback:@"oob"];
	
	GTMOAuthViewControllerTouch *viewController;
	viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:nil language:nil requestTokenURL:requestURL authorizeTokenURL:authorizeURL accessTokenURL:accessURL authentication:auth appServiceName:kYahooKeychainItemName delegate:self finishedSelector:@selector(viewController:finishedWithAuth:error:)];
	
	[self.navigationController pushViewController:viewController animated:YES];
	*/
	
	YOSSession *session = [YOSSession sessionWithConsumerKey:YahooConsumerKey andConsumerSecret:YahooConsumerSecret andApplicationId:YahooApplicationID];
	BOOL hasSession = [session resumeSession];
	
	if (hasSession == NO) {
		[session sendUserToAuthorizationWithCallbackUrl:nil];
	} else {
		// send requests
	}
}

#pragma mark OUTLOOK


@end
