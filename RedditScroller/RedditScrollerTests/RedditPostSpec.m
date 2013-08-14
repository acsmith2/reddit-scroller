#import "Kiwi.h"
#import "Nocilla.h"
#import "RSRedditPost.h"
#import "RSConstants.h"

SPEC_BEGIN(RedditPostSpec)

// 12. singletons should actually be singleton
// 1. Get results from Reddit, return array of results in completion block
// 2. Should call failure block on network failure
// 3. Should display an alert view when reaching the end of the list
// 4. Should repopulate list upon refresh
// 5. Should create different model types from dictionary
// 6. Should create a self-text post that loads itself
// 7. Should launch a webview if its a link post
// 8. Empty self texts should be discarded
// 10. after should return results that are unique from the regular one
// 11. "after" property should be the same one as before

describe(@"RedditPost", ^{
	context(@"when newly created with nil dictionary", ^{
		it(@"should return an empty object with correct default values", ^{
			RSRedditPost *post = [[RSRedditPost alloc] initWithDictionary:nil];
			[post shouldNotBeNil];
			[[post.title should] equal:@""];
			[[post.name should] equal:@""];
			[[theValue(post.isNSFW) should] beTrue];				// Just to be safe!
			[[theValue(post.isSelfText) should] beFalse];
			[[post.domain should] equal:@""];
			[[post.subreddit should] equal:@""];
			[[post.selftext should] equal:@""];
			[[post.thumbnail_url should] equal:@""];
			[[post.url should] equal:@""];
			[[theValue(post.numberOfComments) should] equal:theValue(0)];
		});
	});
	context(@"when newly created with a valid Reddit result dictionary", ^{
		it(@"should return an object with correct values when initialized with a real Reddit result", ^{
			RSRedditPost *post = [[RSRedditPost alloc] initWithDictionary:[RSConstants sampleUrlResultDictionary]];
			[post shouldNotBeNil];
			[[post.title should] equal:@"Elon Musk has unveiled new details about the hyperloop, a new (super fast) form of transportation."];
			[[post.name should] equal:@"t3_1k8bhi"];
			[[theValue(post.isNSFW) should] beFalse];
			[[post.domain should] equal:@"hyperloop.com"];
			[[post.subreddit should] equal:@"technology"];
			[[post.selftext should] equal:@""];
			[[post.thumbnail_url should] equal:@""];
			[[theValue(post.isSelfText) should] beFalse];
			[[post.url should] equal:@"http://hyperloop.com/"];
			[[theValue(post.numberOfComments) should] equal:@3131];
		});
	});
});
SPEC_END
