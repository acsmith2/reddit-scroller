//
//  RSSelfTextViewController.m
//  RedditScroller
//
//  Created by Adam Smith on 8/19/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSSelfTextViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RSSelfTextViewController ()

@property (strong, nonatomic) IBOutlet UILabel* authorLabel;
@property (strong, nonatomic) IBOutlet UILabel* commentsLabel;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* selfTextLabel;
@property (strong, nonatomic) IBOutlet UIView* holderView;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;

@end

@implementation RSSelfTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationItem setTitle:self.redditPost.subreddit];
	[self.authorLabel setText:self.redditPost.posterName];
	[self.commentsLabel setText:[NSString stringWithFormat:@"%d comments",self.redditPost.numberOfComments]];

	const CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
	const CGFloat containerWidth = screenWidth - 40;
	const CGFloat labelPadding = 10.0f;
	const CGFloat constrainedWidth = containerWidth - (labelPadding * 2.0);
	NSLog(@"first pass holderview frame width %lf container width %lf",self.holderView.frame.size.width,containerWidth);
	CGPoint titleContainerOrigin = CGPointMake((self.holderView.frame.size.width - containerWidth)/2.0f,
																				self.authorLabel.frame.origin.y + self.authorLabel.frame.size.height + 10.0);
	NSLog(@"titleContainerOrigin: %lf %lf",titleContainerOrigin.x,titleContainerOrigin.y);
	CGSize titleTextSize = [self.redditPost.title sizeWithFont: [UIFont systemFontOfSize:17.0f]
																					 constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)
																							 lineBreakMode:NSLineBreakByWordWrapping];
	
	CGRect titleLabelFrame = CGRectMake(labelPadding,
																			labelPadding,
																			constrainedWidth,
																			titleTextSize.height);
	
	CGRect titleContainerFrame = CGRectMake(titleContainerOrigin.x, titleContainerOrigin.y,
																					containerWidth, titleTextSize.height + (2.0f * labelPadding));
	
	NSLog(@"title height: %lf",titleLabelFrame.size.height);
	NSLog(@"title container height: %lf",titleContainerFrame.size.height);
	
	UIView* titleContainerView = [[UIView alloc] initWithFrame:titleContainerFrame];
	[titleContainerView setBackgroundColor:[UIColor lightGrayColor]];
	[[titleContainerView layer] setBorderColor:[UIColor blackColor].CGColor];
	[[titleContainerView layer] setBorderWidth:1.0f];
	[[titleContainerView layer] setCornerRadius:7.0f];

	
	self.titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
	[self.titleLabel setText:self.redditPost.title];
	[self.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
	[self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[self.titleLabel setNumberOfLines:0];
	[self.titleLabel setBackgroundColor:[UIColor clearColor]];
	[self.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleContainerView addSubview:self.titleLabel];
	[self.holderView addSubview:titleContainerView];
	
	NSLog(@"holderview frame width %lf container width %lf",self.holderView.frame.size.width,containerWidth);
	
	CGPoint selfTextContainerOrigin = CGPointMake((self.holderView.frame.size.width - containerWidth)/2.0f,
																						 titleContainerFrame.origin.y + titleContainerFrame.size.height + 10.0f);
	
	NSLog(@"selfTextContainerOrigin: %lf %lf",selfTextContainerOrigin.x,selfTextContainerOrigin.y);
	
	CGSize selfTextTextSize = [self.redditPost.selftext sizeWithFont: [UIFont systemFontOfSize:13.0f]
																					 constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)
																							 lineBreakMode:NSLineBreakByWordWrapping];
	
	CGRect selfTextLabelFrame = CGRectMake(labelPadding,
																			labelPadding,
																			constrainedWidth,
																			selfTextTextSize.height);
	
	CGRect selfTextContainerFrame = CGRectMake(selfTextContainerOrigin.x, selfTextContainerOrigin.y,
																					containerWidth, selfTextTextSize.height + (2.0f * labelPadding));

	NSLog(@"container frame: %lf %lf %lf %lf",selfTextContainerFrame.origin.x, selfTextContainerFrame.origin.y,
				selfTextContainerFrame.size.width,selfTextContainerFrame.size.height);
	
	UIView *selfTextContainerView = [[UIView alloc] initWithFrame:selfTextContainerFrame];
	[selfTextContainerView setBackgroundColor:[UIColor whiteColor]];
	[[selfTextContainerView layer] setBorderColor:[UIColor blackColor].CGColor];
	[[selfTextContainerView layer] setBorderWidth:1.0f];
	[[selfTextContainerView layer] setCornerRadius:7.0f];
	
	self.selfTextLabel = [[UILabel alloc] initWithFrame:selfTextLabelFrame];
	[self.selfTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
	[self.selfTextLabel setText:self.redditPost.selftext];
	[self.selfTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[self.selfTextLabel setBackgroundColor:[UIColor clearColor]];
	[self.selfTextLabel setNumberOfLines:0];
	[self.selfTextLabel sizeToFit];
	[selfTextContainerView addSubview:self.selfTextLabel];
	[self.holderView addSubview:selfTextContainerView];
	
	NSLog(@"holderview frame before: %lf %lf %lf %lf",self.holderView.frame.origin.x,self.holderView.frame.origin.y,self.holderView.frame.size.width,self.holderView.frame.size.height);
	
	[self.holderView setFrame:CGRectMake(labelPadding, labelPadding, containerWidth + (2.0 * labelPadding), selfTextContainerFrame.origin.y + selfTextContainerFrame.size.height + labelPadding)];
	[[self.holderView layer] setBorderColor:[UIColor blackColor].CGColor];
	[[self.holderView layer] setBorderWidth:1.0f];
	[[self.holderView layer] setCornerRadius:7.0f];
	
	NSLog(@"holderview frame after: %lf %lf %lf %lf",self.holderView.frame.origin.x,self.holderView.frame.origin.y,self.holderView.frame.size.width,self.holderView.frame.size.height);

	CGSize scrollContentSize = CGSizeMake(screenWidth, self.holderView.frame.size.height + self.holderView.frame.origin.y + labelPadding);
	
	[self.scrollView setContentSize:scrollContentSize];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
