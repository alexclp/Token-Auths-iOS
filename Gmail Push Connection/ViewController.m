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

#define GoogleClientID @"1000494215729-vr41jat73tv151ffprmq9lrl6lg7esn3.apps.googleusercontent.com"
#define GoogleClientSecret @"gPsKw4m91RWWu02zH8M68_dx"

#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"

#define YahooConsumerKey @"dj0yJmk9bmJNbFdhZ0lFT0ZLJmQ9WVdrOU5WSklhbVJKTlRJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0xMg--"
#define YahooConsumerSecret @"0483a424177c4ab94c3c440a724e01c4325916b4%26"
#define YahooApplicationID @"LdtuY16q"
#define kYahooKeychainItemName @"OAuth Sample: Yahoo"

#define OutlookClientID @"000000004C123224"
#define OutlookClientSecret @"niUjykUrtUbkyd3afIkcSA1znf4dN2y9"

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
		
		NSLog(@"parameters = %@", parameters);

 		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

		[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"JSON: %@", responseObject);
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}];

		NSLog(@"access token = %@", auth.accessToken);
    }
}

- (void)createAccount:(NSString *)account andDomain:(NSString *)domain accessToken:(NSString *)atoken andRefreshToken:(NSString *)rtoken
{
	if ([domain isEqualToString:@"google"]) {
		domain = @"GMAIL";
		NSDictionary *parameters = @{@"account": account,
									 @"domain": domain,
									 @"access_token": atoken,
									 @"refresh_token": rtoken,
									 @"device_token": [self getToken]};
		
		NSLog(@"parameters = %@", parameters);
		
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		
		[manager POST:@"http://188.26.122.230/mailsync/createAccount.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"JSON: %@", responseObject);
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}];
		
	}
	
}

#pragma mark YAHOO

- (IBAction)yahooButtonClicked:(id)sender
{
	// Getting the user's email address.
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email Address?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
	alertView.tag = 2;
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView show];
	
	
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
