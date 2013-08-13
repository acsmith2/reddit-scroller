//
//  RSConstants.m
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSConstants.h"

@implementation RSConstants

+(NSDictionary*)sampleUrlResultDictionary
{
	// Actual reddit post
	NSDictionary* dataDict = @{@"domain": @"hyperloop.com",
														@"banned_by": [NSNull null],
														@"media_embed": @{},
														@"subreddit": @"technology",
														@"selftext_html": [NSNull null],
														@"selftext": @"",
														@"likes": [NSNull null],
														@"link_flair_text": [NSNull null],
														@"id": @"1k8bhi",
														@"clicked": @false,
														@"stickied": @false,
														@"title": @"Elon Musk has unveiled new details about the hyperloop, a new (super fast) form of transportation.",
														@"media": [NSNull null],
														@"score": @3827,
														@"approved_by": [NSNull null],
														@"over_18": @false,
														@"hidden": @false,
														@"thumbnail": @"",
														@"subreddit_id": @"t5_2qh16",
														@"edited": @false,
														@"link_flair_css_class": [NSNull null],
														@"author_flair_css_class": [NSNull null],
														@"downs": @11084,
														@"saved": @false,
														@"is_self": @false,
														@"permalink": @"/r/technology/comments/1k8bhi/elon_musk_has_unveiled_new_details_about_the/",
														@"name": @"t3_1k8bhi",
														@"created": @1376369043.0,
														@"url": @"http://hyperloop.com/",
														@"author_flair_text": [NSNull null],
														@"author": @"sebflippers",
														@"created_utc": @1376340243.0,
														@"distinguished": [NSNull null],
														@"num_comments": @3131,
														@"num_reports": [NSNull null],
														@"ups": @14911};
	return @{@"kind": @"t3", @"data": dataDict};
}

+(NSDictionary*)sampleSelfTextResultDictionary{
	// Actual reddit post
	NSDictionary* dataDict = @{@"domain": @"self.AskReddit",
														@"banned_by": [NSNull null],
														@"media_embed": @{},
														@"subreddit": @"AskReddit",
														@"selftext_html": @"&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;My coworker and I share an office and people are always walking in and out. We&amp;#39;re looking for funny, gross, weird, inappropriate things to say as if we were in the middle of a &amp;quot;wtf&amp;quot; type conversation when people walk in.&lt;/p&gt;\n\n&lt;p&gt;Example: &lt;em&gt;someone walks in&lt;/em&gt; &amp;quot;...and so he missed and got it in my eye.. my uncle is so silly!&amp;quot;&lt;/p&gt;\n\n&lt;p&gt;ready? go!&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;", @"selftext": @"My coworker and I share an office and people are always walking in and out. We're looking for funny, gross, weird, inappropriate things to say as if we were in the middle of a \"wtf\" type conversation when people walk in.\n\nExample: *someone walks in* \"...and so he missed and got it in my eye.. my uncle is so silly!\"\n\nready? go!",
														@"likes": [NSNull null],
														@"link_flair_text": [NSNull null],
														@"id": @"1k8ch9",
														@"clicked": @false,
														@"stickied": @false,
														@"title": @"Best ways to end a conversation when someone new walks in...?",
														@"media": [NSNull null],
														@"score": @2062,
														@"approved_by": [NSNull null],
														@"over_18": @true,
														@"hidden": @false,
														@"thumbnail": @"",
														@"subreddit_id": @"t5_2qh1i",
														@"edited": @false,
														@"link_flair_css_class": [NSNull null],
														@"author_flair_css_class": [NSNull null],
														@"downs": @4109,
														@"saved": @false,
														@"is_self": @true,
														@"permalink": @"/r/AskReddit/comments/1k8ch9/best_ways_to_end_a_conversation_when_someone_new/",
														@"name": @"t3_1k8ch9",
														@"created": @1376369728.0,
														@"url": @"http://www.reddit.com/r/AskReddit/comments/1k8ch9/best_ways_to_end_a_conversation_when_someone_new/",
														@"author_flair_text": [NSNull null],
														@"author": @"nicolelajones",
														@"created_utc": @1376340928.0,
														@"distinguished": [NSNull null],
														@"num_comments": @2785,
														@"num_reports": [NSNull null],
														@"ups": @6171};
	return @{@"kind": @"t3", @"data": dataDict};
}

+(NSArray*)sampleResultArray
{
	return @[[RSConstants sampleUrlResultDictionary],[RSConstants sampleSelfTextResultDictionary]];
}

@end
