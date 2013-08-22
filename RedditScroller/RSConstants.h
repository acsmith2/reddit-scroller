//
//  RSConstants.h
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

// Reddit Keys
#define kRSIsSelfKey @"is_self"
#define kRSDomainKey @"domain"
#define kRSSubredditKey @"subreddit"
#define kRSSelfTextKey @"selftext"
#define kRSURLKey @"url"
#define kRSThumbnailKey @"thumbnail"
#define kRSTitleKey @"title"
#define kRSNameKey @"name"
#define kRSNumCommentsKey @"num_comments"
#define kRSNSFWKey @"over_18"
#define kRSDataKey @"data"
#define kRSChildrenKey @"children"
#define kRSBeforeKey @"before"
#define kRSAfterKey @"after"
#define kRSPosterNameKey @"author"
#define kRSScoreKey @"score"

// Server Info
#define kRSRedditApiUrl @"http://www.reddit.com/.json"
#define kRSRedditPostCount 25

// Cell Identifier
#define kRSRedditPostCellIdentifier @"RedditPostCell"

// Error Codes
#define kRSEmptyResultsErrorCode 999

@interface RSConstants : NSObject

+(NSString*)redditApiUrl;

@end
