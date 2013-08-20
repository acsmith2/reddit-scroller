//
//  RSPostListDataSource.h
//  RedditScroller
//
//  Created by Adam Smith on 8/18/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSRedditPost.h"

@interface RSPostListDataSource : NSObject <UITableViewDataSource>

-(RSRedditPost*)postForIndexPath:(NSIndexPath *)indexPath;

@end
