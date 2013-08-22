#import "Kiwi.h"
#import "Nocilla.h"
#import "RSRedditPost.h"
#import "RSFakeRedditData.h"

SPEC_BEGIN(RedditPostSpec)

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
			[[theValue(post.score) should] equal:theValue(0)];
			[[theValue(post.numberOfComments) should] equal:theValue(0)];
		});
	});
	context(@"when newly created with a valid Reddit result dictionary", ^{
		it(@"should return an object with correct values when initialized with a real Reddit result", ^{
			RSRedditPost *post = [[RSRedditPost alloc] initWithDictionary:[RSFakeRedditData sampleUrlResultDictionary]];
			[post shouldNotBeNil];
			[[post.title should] equal:@"Elon Musk has unveiled new details about the hyperloop, a new (super fast) form of transportation."];
			[[post.name should] equal:@"t3_1k8bhi"];
			[[theValue(post.isNSFW) should] beFalse];
			[[post.domain should] equal:@"hyperloop.com"];
			[[post.subreddit should] equal:@"technology"];
			[[post.selftext should] equal:@""];
			[[post.thumbnail_url should] equal:@""];
			[[theValue(post.isSelfText) should] beFalse];
			[[theValue(post.score) should] equal:@3827];
			[[post.url should] equal:@"http://hyperloop.com/"];
			[[theValue(post.numberOfComments) should] equal:@3131];
		});
	});
});
SPEC_END
