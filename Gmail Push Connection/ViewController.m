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

#define GoogleClientID @"1000494215729-pehvprm46fnmuunp6uemn7nph9tl9uss.apps.googleusercontent.com"
#define GoogleClientSecret @"nNHiHKDGO7i2sVW2SNDOvSQT"

#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"

#define YahooConsumerKey @"dj0yJmk9ZXVwUHh2SGtndU1hJmQ9WVdrOVRHUjBkVmt4Tm5FbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD00Zg--"
#define YahooConsumerSecret @"c62ece90ed067e3ffb02ea3d2164dfed425a3665%26"
#define YahooApplicationID @"LdtuY16q"
#define kYahooKeychainItemName @"OAuth Sample: Yahoo"

#define OutlookClientID @"000000004C123224"
#define OutlookClientSecret @"niUjykUrtUbkyd3afIkcSA1znf4dN2y9"

#define DeviceToken @"50ed43d36739c3acfff4895cba61115559f9f816b5b2a7fd802635bbb7c85f85"

#define TEST_EMAIL @"testaplicatiepush@gmail.com"

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

- (NSString *)getToken
{
	// Get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// Build the path to the file
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Token.plist"];
	
	NSError *error;
	
	return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
}

- (void)createAccount:(NSString *)account andDomain:(NSString *)domain accessToken:(NSString *)atoken andRefreshToken:(NSString *)rtoken
{
	if ([domain isEqualToString:@"google"]) {
		domain = @"GMAIL";
		NSDictionary *parameters = @{@"account": account,
									 @"domain": domain,
									 @"access_token": atoken,
									 @"refresh_token": rtoken,
									 @"device_token": DeviceToken};
		
		NSLog(@"parameters = %@", parameters);
		
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		
		[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"JSON: %@", responseObject);
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}];

	}
	
}

- (void)addYahooAccountWithParameters:(NSDictionary *)parameters
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
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
//	[self createAccount:TEST_EMAIL andDomain:[credentials objectForKey:@"provider"] accessToken:[credentials objectForKey:@"access_token"] andRefreshToken:@"refresh_token"];
	
	NSDictionary *parameters = @{@"access_token": token,
								 @"access_token_secret": oauth_token_secret,
								 @"domain": @"YAHOO",
								 @"account": self.currentEmailAddress,
								 @"oauth_session_handle": @"a",
								 @"device_token": DeviceToken};
	
	[self addYahooAccountWithParameters:parameters];
}

// Handle errors in the case of an unsuccessful authentication
- (void)didFailWithOAuthIOError:(NSError *)error
{
	NSLog(@"Oups, credentials were not good");
}

#pragma mark GMAIL

- (IBAction)gmailButtonClicked:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email Address?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
	alertView.tag = 2;
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView show];
	
	
	NSURL *tokenURL = [NSURL URLWithString:GoogleTokenURL];
	
//    NSString *redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
	
    GTMOAuth2Authentication *auth;
	
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"google"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:GoogleClientID
                                                         clientSecret:GoogleClientSecret];
	
    auth.scope = @"https://mail.google.com";
	
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
		
		NSDictionary *parameters = @{@"account": self.currentEmailAddress,
									 @"domain": @"GMAIL",
									 @"access_token": auth.accessToken,
									 @"refresh_token": auth.refreshToken,
									 @"device_token": [self getToken]};

 		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

		[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"JSON: %@", responseObject);
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}];

		NSLog(@"access token = %@", auth.accessToken);

    }
}

#pragma mark YAHOO

- (IBAction)yahooButtonClicked:(id)sender
{
	OAuthIOModal *oauthioModal = [[OAuthIOModal alloc] initWithKey:@"Xfjvei5JZVEUqt2kdqgzl716fEc" delegate:self];
	
	[oauthioModal showWithProvider:@"yahoo"];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email Address?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
	alertView.tag = 2;
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView show];
	
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
	
	auth.scope = @"wl.imap";
	
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
																							   authorizationURL:[NSURL URLWithString:@"https://login.live.com/oauth20_authorize.srf"]
																							   keychainItemName:@"MicrosoftKeychainName" delegate:self
																							   finishedSelector:@selector(viewController:finishedWithAuth:error:)];
	
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark GetEmailAddress

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

	UITextField * alertTextField = [alertView textFieldAtIndex:0];
	
	self.currentEmailAddress = alertTextField.text;
	
	NSLog(@"email = %@", self.currentEmailAddress);
	// do whatever you want to do with this UITextField.
}

@end
