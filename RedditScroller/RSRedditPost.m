//
//  RSRedditPost.m
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSRedditPost.h"
#import "RSConstants.h"

@implementation RSRedditPost

-(id)initWithDictionary:(NSDictionary*)dictionary
{
	
	NSDictionary *dataDictionary = dictionary[kRSDataKey] ? dictionary[kRSDataKey] : nil;
	
	if (!dataDictionary[kRSIsSelfKey]) {
		self.isSelfText = false;
	} else {
		self.isSelfText = [dataDictionary[kRSIsSelfKey] boolValue];
	}
	
	if (!dataDictionary[kRSNumCommentsKey]) {
		self.numberOfComments = 0;
	} else {
		self.numberOfComments = [dataDictionary[kRSNumCommentsKey] intValue];
	}
	
	if (!dataDictionary[kRSNSFWKey]) {
		self.isNSFW = true;
	} else {
		self.isNSFW = [dataDictionary[kRSNSFWKey] boolValue];
	}

	if (!dataDictionary[kRSScoreKey]) {
		self.score = 0;
	} else {
		self.score = [dataDictionary[kRSScoreKey] intValue];
	}
	
	self.selftext = dataDictionary[kRSSelfTextKey] ? dataDictionary[kRSSelfTextKey] : @"";
	self.subreddit = dataDictionary[kRSSubredditKey] ? dataDictionary[kRSSubredditKey] : @"";
	self.domain = dataDictionary[kRSDomainKey] ? dataDictionary[kRSDomainKey] : @"";
	self.title = dataDictionary[kRSTitleKey] ? dataDictionary[kRSTitleKey] : @"";
	self.name = dataDictionary[kRSNameKey] ? dataDictionary[kRSNameKey] : @"";
	self.url = dataDictionary[kRSURLKey] ? dataDictionary[kRSURLKey] : @"";
	self.thumbnail_url = dataDictionary[kRSThumbnailKey] ? dataDictionary[kRSThumbnailKey] : @"";
	self.posterName = dataDictionary[kRSPosterNameKey] ? dataDictionary[kRSPosterNameKey] : @"";

	return self;
}

@end
