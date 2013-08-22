//
//  RSPostListViewController.m
//  RedditScroller
//
//  Created by Adam Smith on 8/8/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSPostListViewController.h"
#import "RSPostListDataSource.h"
#import "RSRedditPostCell.h"
#import "RSRedditPost.h"
#import "RSConstants.h"
#import "RSDataManager.h"
#import "RSWebLinkViewController.h"
#import "RSSelfTextViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RSPostListViewController ()

@property Boolean firstFetch;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) RSPostListDataSource* dataSource;
@property (strong, nonatomic) UIActivityIndicatorView* progressView;

@end

@implementation RSPostListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.dataSource = [[RSPostListDataSource alloc] init];
	[self.tableView setDataSource:self.dataSource];
	[self.tableView setDelegate:self];
	[self.tableView registerNib:[UINib nibWithNibName:@"RSRedditPostCell" bundle:nil] forCellReuseIdentifier:kRSRedditPostCellIdentifier];
	
	[self.navigationItem setTitle:@"redditScroller"];
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
	[self.navigationItem setRightBarButtonItem:refreshButton];
	
	self.progressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.progressView.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
	self.progressView.center = CGPointMake(self.view.center.x, self.view.center.y- 50.0f);
	[[self.progressView layer] setBorderWidth:1.0f];
	[[self.progressView layer] setBorderColor:[UIColor blackColor].CGColor];
	[[self.progressView layer] setCornerRadius:7.0f];
	[self.progressView setBackgroundColor:[UIColor darkGrayColor]];
	[self.view addSubview:self.progressView];
	[self.progressView bringSubviewToFront:self.view];
	[self refreshRedditData];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

-(void)displayProgressView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self.progressView setHidden:NO];
	[self.progressView startAnimating];
}

-(void)hideProgressView
{
	[self.progressView setHidden:YES];
	[self.progressView stopAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void) refreshRedditData
{
	self.firstFetch = true;
	[self displayProgressView];
	[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
		[self refreshTableView];
		self.firstFetch = FALSE;
		[self hideProgressView];
	} andFailureBlock:^(NSString *message, NSError* error) {
		if (error.code == kRSEmptyResultsErrorCode) {
			[self refreshTableView];
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
		[self hideProgressView];
	}];
}

-(void)refreshButtonPressed:(id)sender
{
	[self refreshRedditData];
}

-(void)refreshTableView
{
	[self.tableView reloadData];
	if ([[RSDataManager sharedManager] previousPageAvailable] && !self.firstFetch) {
		UIButton* headerView = [[[NSBundle mainBundle] loadNibNamed:@"PreviousPageButton" owner:self options:nil] lastObject];
		[headerView addTarget:self action:@selector(previousPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.tableView setTableHeaderView:headerView];
	} else {
		[self.tableView setTableHeaderView:nil];
	}
	if ([[RSDataManager sharedManager] nextPageAvailable]) {
		UIButton* footerView = [[[NSBundle mainBundle] loadNibNamed:@"NextPageButton" owner:self options:nil] lastObject];
		[footerView addTarget:self action:@selector(nextPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.tableView setTableFooterView:footerView];
	} else {
		[self.tableView setTableFooterView:nil];
	}
	
}

-(void)previousPageButtonPressed:(id)sender
{
	[self displayProgressView];
	[[RSDataManager sharedManager] loadPreviousPageWithSuccessBlock:^{
		[self refreshTableView];
		int finalRow = [self.tableView numberOfSections] - 1;
		if (finalRow < 0) {
			finalRow = 0;
		}
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:finalRow];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		[self hideProgressView];
	} andFailureBlock:^(NSString *message, NSError* error) {
		if (error.code == kRSEmptyResultsErrorCode) {
			[self refreshTableView];
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
		[self hideProgressView];
	}];
}

-(void)nextPageButtonPressed:(id)sender
{
	[self displayProgressView];
	[[RSDataManager sharedManager] loadNextPageWithSuccessBlock:^{
		[self refreshTableView];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		[self hideProgressView];
	} andFailureBlock:^(NSString *message, NSError* error) {
		if (error.code == kRSEmptyResultsErrorCode) {
			[self refreshTableView];
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
		[self hideProgressView];
	}];
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RSPostListDataSource *dataSource = tableView.dataSource;
	RSRedditPost* post = [dataSource postForIndexPath:indexPath];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem: backButton];
	
	if (post.isSelfText)
	{
		RSSelfTextViewController* selfTextViewController = [[RSSelfTextViewController alloc] initWithNibName:@"RSSelfTextViewController" bundle:nil];
		[selfTextViewController setRedditPost:post];
		[self.navigationController pushViewController:selfTextViewController animated:YES];
	} else {
		RSWebLinkViewController* webLinkViewController = [[RSWebLinkViewController alloc] initWithNibName:@"RSWebLinkViewController" bundle:nil];
		[webLinkViewController setRedditPost:post];
		[self.navigationController pushViewController:webLinkViewController animated:YES];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 140.0f;
}



@end
