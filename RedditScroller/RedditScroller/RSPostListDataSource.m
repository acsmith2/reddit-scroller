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
	NSLog(@"num sections: %d",[[RSDataManager sharedManager] redditData].count);
	return [[RSDataManager sharedManager] redditData].count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"nubmer of rows");
	return 1;
}

-(RSRedditPost*)postForIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"post for index path: %d",indexPath.section);
	return [[[RSDataManager sharedManager] redditData] objectAtIndex:indexPath.section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"cellForRowAtIndexPath: %@",indexPath);
	RSRedditPostCell *cell = [tableView dequeueReusableCellWithIdentifier:kRSRedditPostCellIdentifier forIndexPath:indexPath];
	
	RSRedditPost *post = [self postForIndexPath:indexPath];
	[cell setRedditPost:post];
	
	return cell;
}


@end
