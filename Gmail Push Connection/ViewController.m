//
//  ViewController.m
//  Gmail Push Connection
//
//  Created by Alexandru Clapa on 08.06.2014.
//  Copyright (c) 2014 Alexandru Clapa. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"

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

#define YahooConsumerKey @"dj0yJmk9WXdZejdYNXdHRHdhJmQ9WVdrOU5VZHVTWFpJTkdNbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0xZA--"
#define YahooConsumerSecret @"cf101d517f2c3af066c225f54233cf62011ea27c"

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
		
		NSLog(@"token = %@", auth.accessToken);
		
//		[self tokenRequestWithCode:auth.code];
		
    }
}

- (NSString *)getTimeStamp
{
	NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//	NSTimeInterval is defined as double
	
	NSNumber *timeStampObj = [NSNumber numberWithDouble:timeStamp];
	
	return [NSString stringWithFormat:@"%@", timeStampObj];
}

#pragma mark YAHOO

- (IBAction)yahooButtonClicked:(id)sender
{
	
	
	NSDictionary *parameters = @{@"oauth_consumer_key": YahooConsumerKey, @"oauth_signature_method": @"plaintext", @"oauth_signature": [YahooConsumerSecret stringByAppendingString:@"%26"], @"oauth_version": @"1.0", @"xoauth_lang_pref": @"en_us", @"oauth_callback": @"http://alexandruclapa.com", @"oauth_timestamp": [self getTimeStamp], @"oauth_nonce": @"123456789"};
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:@"https://api.login.yahoo.com/oauth/v2/get_request_token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

#pragma mark OUTLOOK


@end
