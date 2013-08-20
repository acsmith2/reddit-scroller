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

@interface RSPostListViewController ()

@property Boolean firstFetch;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) RSPostListDataSource* dataSource;

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

-(void) refreshRedditData
{
		self.firstFetch = true;
	[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
		NSLog(@"refreshRedditDataWithSuccessBlock success");
		[self refreshTableView];
					self.firstFetch = FALSE;
	} andFailureBlock:^(NSString *message, NSError* error) {
		if (error.code == kRSEmptyResultsErrorCode) {
			[self refreshTableView];
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
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
	[[RSDataManager sharedManager] loadPreviousPageWithSuccessBlock:^{
		[self refreshTableView];
		int finalRow = [self.tableView numberOfSections] - 1;
		if (finalRow < 0) {
			finalRow = 0;
		}
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:finalRow];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	} andFailureBlock:^(NSString *message, NSError* error) {
		if (error.code == kRSEmptyResultsErrorCode) {
			[self refreshTableView];			
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}];
}

-(void)nextPageButtonPressed:(id)sender
{
	[[RSDataManager sharedManager] loadNextPageWithSuccessBlock:^{
		[self refreshTableView];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	} andFailureBlock:^(NSString *message, NSError* error) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}];
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RSPostListDataSource *dataSource = tableView.dataSource;
	RSRedditPost* post = [dataSource postForIndexPath:indexPath];
	NSLog(@"did select post %@",post.title);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"height for row");
	return 120.0f;
}



@end
