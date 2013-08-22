//
//  RSWebLinkViewController.m
//  RedditScroller
//
//  Created by Adam Smith on 8/19/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSWebLinkViewController.h"

@interface RSWebLinkViewController ()

@property (nonatomic,strong) IBOutlet UIWebView* webView;

@end

@implementation RSWebLinkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationItem setTitle:self.redditPost.domain];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.redditPost.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
	[self.webView loadRequest:request];
}

@end
