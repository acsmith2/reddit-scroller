//
//  RSConstants.m
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSConstants.h"

@implementation RSConstants

+(NSString*)redditApiUrl
{
	return [NSString stringWithFormat:@"%@?count=%d",kRSRedditApiUrl,kRSRedditPostCount];
}

@end