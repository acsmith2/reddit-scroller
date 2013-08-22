//
//  RSPostListDataSource.m
//  RedditScroller
//
//  Created by Adam Smith on 8/18/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSPostListDataSource.h"
#import "RSDataManager.h"
#import "RSRedditPostCell.h"
#import "RSRedditPost.h"
#import "RSConstants.h"

@implementation RSPostListDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[RSDataManager sharedManager] redditData].count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(RSRedditPost*)postForIndexPath:(NSIndexPath *)indexPath
{
	return [[[RSDataManager sharedManager] redditData] objectAtIndex:indexPath.section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RSRedditPostCell *cell = [tableView dequeueReusableCellWithIdentifier:kRSRedditPostCellIdentifier forIndexPath:indexPath];
	
	RSRedditPost *post = [self postForIndexPath:indexPath];
	[cell setRedditPost:post];
	
	return cell;
}


@end
