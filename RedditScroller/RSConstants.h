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

// Server Info
#define kRSRedditApiUrl @"http://www.reddit.com/.json"

@interface RSConstants : NSObject

+(NSDictionary*)sampleUrlResultDictionary;
+(NSDictionary*)sampleSelfTextResultDictionary;
+(NSArray*)sampleResultArray;
+(NSString*)sampleRealRedditResults;
@end
