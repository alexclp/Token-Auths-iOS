//
//  ViewController.m
//  Gmail Push Connection
//
//  Created by Alexandru Clapa on 08.06.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"

#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"

//#define GoogleClientID    @"997352802958-evpubtvdrtmueh20rd938625tpo2b5s8.apps.googleusercontent.com"
//#define GoogleClientSecret @"fHwEmNBQKKyqKmmnotThEM-g"

#define GoogleClientID @"1000494215729-lbj0k70ce1ihc4fco6vdafeqlg1faa7t.apps.googleusercontent.com"
#define GoogleClientSecret @"99d5ilo2M7Vkl4AtxO2sHAWR"

#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"

#define YahooConsumerKey @"dj0yJmk9bEo2TmFVbTBZMlNvJmQ9WVdrOU5VZHVTWFpJTkdNbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1lOA--"
#define YahooConsumerSecret @"621f893e5e295f8efba1c76a4e4eb8fcb9371e0e%26"
#define YahooApplicationID @"5GnIvH4c"
#define kYahooKeychainItemName @"OAuth Sample: Yahoo"

#define OutlookClientID @"000000004C123224"
#define OutlookClientSecret @"niUjykUrtUbkyd3afIkcSA1znf4dN2y9"

#define DeviceToken @"50ed43d36739c3acfff4895cba61115559f9f816b5b2a7fd802635bbb7c85f85"

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

#pragma OAuthIODelegate

// Handles the results of a successful authentication
- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request
{
	NSLog(@"Auth successful");
	
	NSDictionary *credentials = [request getCredentials];
	
	NSLog(@"credentials = %@", credentials);
	
	NSString *token = [credentials objectForKey:@"oauth_token"];
	NSString *oauth_token_secret = [credentials objectForKey:@"oauth_token_secret"];
}

// Handle errors in the case of an unsuccessful authentication
- (void)didFailWithOAuthIOError:(NSError *)error
{
	NSLog(@"Oups, credentials were not good");
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
		
		
		/*
		NSDictionary *parameters = @{@"account": @"alexclp31@gmail.com",
									 @"domain": @"GMAIL",
									 @"access_token": auth.accessToken,
									 @"refresh_token": auth.refreshToken,
									 @"device_token": DeviceToken};

 		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

		[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"JSON: %@", responseObject);
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}];
		*/
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

- (IBAction)yahooButtonClicked:(id)sender
{
	OAuthIOModal *oauthioModal = [[OAuthIOModal alloc] initWithKey:@"Xfjvei5JZVEUqt2kdqgzl716fEc" delegate:self];
	
	[oauthioModal showWithProvider:@"yahoo"];
}

#pragma mark OUTLOOK

- (IBAction)outlookButtonClicked:(id)sender
{
	GTMOAuth2Authentication *auth;
	
	auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"microsoft"
                                                             tokenURL:[NSURL URLWithString:@"https://login.live.com/oauth20_token.srf"]
                                                          redirectURI:redirectURI
                                                             clientID:OutlookClientID
                                                         clientSecret:OutlookClientSecret];
	
//    auth.scope = @"https://www.googleapis.com/auth/plus.me";
	
	auth.scope = @"wl.imap";
	
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
																							   authorizationURL:[NSURL URLWithString:@"https://login.live.com/oauth20_authorize.srf"]
																							   keychainItemName:@"MicrosoftKeychainName" delegate:self
																							   finishedSelector:@selector(viewController:finishedWithAuth:error:)];
	
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark Check Email

- (IBAction)checkEmail:(id)sender
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"email": @"alexclp31@gmail.com",
								 @"domain": @"GMAIL"};
	[manager POST:@"http://188.26.122.230/mailsync/checkMail.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

@end
