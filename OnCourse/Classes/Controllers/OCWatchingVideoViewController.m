//
//  OCWatchingVideoViewController.m
//  OnCourse
//
//  Created by admin on 12/10/12.
//  Copyright (c) 2012 phatle. All rights reserved.
//

#import "OCWatchingVideoViewController.h"
#import "OCWatchingVideo.h"
#import "OCJavascriptFunctions.h"
#import <MediaPlayer/MediaPlayer.h>

@interface OCWatchingVideoViewController ()

@property (nonatomic, strong) OCWatchingVideo *watchingVideoView;
@property (nonatomic, strong) NSString *videoLectureLink;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIWebView *webviewPlayer;

@end

@implementation OCWatchingVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVideoLink:(NSString *)videoLink
{
    self = [super init];
    if (self) {
        self.webviewPlayer = [[UIWebView alloc] init];
        self.webviewPlayer.delegate = self;
        [self loadRequest:videoLink];
        self.watchingVideoView = [OCWatchingVideo new];
        self.moviePlayer = self.watchingVideoView.moviePlayer;
    }
    return self;
}

- (void)loadRequest:(NSString *)videoLink
{
    [self.webviewPlayer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoLink]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view = self.watchingVideoView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((self.moviePlayer.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK) {
        //add your code
        NSLog(@"Played video");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *requestString = [[request URL] absoluteString];
    
    NSLog(@"request : %@",requestString);
    
    if ([requestString hasPrefix:@"js-frame:"]) {
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        
        NSString *function = (NSString*)[components objectAtIndex:1];
        if ([@"pageLoaded" isEqualToString:function])
        {
            NSLog(@"Getting direct video link");
            self.videoLectureLink = [self getDirectVideoLink];
            [self playVideo];
            self.webviewPlayer = nil;
        }
        return NO;
    }
    
    return YES;
}

- (NSString *)getDirectVideoLink
{
    return [self.webviewPlayer stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsPlayLectureVideo]];
}

- (void)playVideo
{
    NSURL *url = [NSURL URLWithString:self.videoLectureLink];
    [self.moviePlayer setContentURL:url];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer play];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webviewPlayer stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions jsCallObjectiveCFunction]];
    [self.webviewPlayer stringByEvaluatingJavaScriptFromString:[OCJavascriptFunctions checkPageLoaded]];
}
@end