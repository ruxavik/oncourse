//
//  OCCrawlerLoginState.m
//  OnCourse
//
//  Created by East Agile on 12/2/12.
//  Copyright (c) 2012 phatle. All rights reserved.
//

#import "OCCrawlerLoginState.h"
#import "OCJavascriptFunctions.h"
#import "OCCrawlerCourseListingState.h"
#import "OCAppDelegate.h"
#import "OCUtility.h"
#import "OCCourseListingsViewController.h"

@implementation OCCrawlerLoginState

- (id)initWithWebview:(UIWebView *)webview andEmail:(NSString *)email andPassword:(NSString *)password
{
    self = [super init];
    if (self) {
        self.webviewCrawler = webview;
        self.email = email;
        self.password = password;
        self.webviewCrawler.delegate = self;
        [self loadRequest:@"https://www.coursera.org/account/signin"];
    }
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsFillElement:@"signin-email" withContent:email]];
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsFillElement:@"signin-password" withContent:password]];
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsLogin]];
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsCallObjectiveCFunction]];
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions checkLogined]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *requestString = [[request URL] absoluteString];
    
    NSLog(@"request : %@",requestString);
    
    if ([requestString hasPrefix:@"js-frame:"]) {
        
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        
        NSString *function = (NSString*)[components objectAtIndex:1];
        
        if ([@"login_successfully" isEqualToString:function]) {
            if ([self.crawlerDelegate respondsToSelector:@selector(changeState:)]) {
                [self.crawlerDelegate changeState:[[OCCrawlerCourseListingState alloc] initWithWebview:self.webviewCrawler]];
                NSLog(@"Login_ successfully");
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if (![userDefaults objectForKey:@"email"]) {
                    [userDefaults setObject:@"Logined" forKey:@"isLogin"];
                    [userDefaults setObject:self.email forKey:@"email"];
                    [userDefaults setObject:self.password forKey:@"password"];
                }
                [self presentListCourseViewController];
            }
        }
        else if ([@"login_fail" isEqualToString:function])
        {
            [[[UIAlertView alloc] initWithTitle:@"Login Fail" message:@"Please check your email and password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        else if ([@"pageLoaded" isEqualToString:function])
        {
            NSLog(@"call login javascript function");
            [self loginWithEmail:self.email andPassword:self.password];
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsCallObjectiveCFunction]];
    [self.webviewCrawler stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions checkPageLoaded]];
}

- (void)presentListCourseViewController
{
    OCAppDelegate *appDelegate = [OCUtility appDelegate];
    [appDelegate.navigationController pushViewController:[[OCCourseListingsViewController alloc] init] animated:YES];
}

@end