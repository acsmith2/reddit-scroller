#import "Kiwi.h"
#import "RSFakeRedditData.h"
#import "RSWebService.h"
#import "RSConstants.h"
#import "Nocilla.h"
#import "RSRedditPost.h"

SPEC_BEGIN(WebServiceSpec)

beforeAll(^{
  [[LSNocilla sharedInstance] start];
});

beforeEach(^{
	stubRequest(@"GET", [RSConstants redditApiUrl]).
	withHeaders(@{@"Accept": @"application/json"}).
	andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleRealRedditFirstPageResults]);
	
	stubRequest(@"GET", [NSString stringWithFormat:@"%@%@",[RSConstants redditApiUrl],@"&after=t3_1kluu8"]).
	withHeaders(@{@"Accept": @"application/json"}).
	andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleReadRedditSecondPageResults]);
	
	stubRequest(@"GET", [NSString stringWithFormat:@"%@%@",[RSConstants redditApiUrl],@"&before=t3_1kmotr"]).
	withHeaders(@{@"Accept": @"application/json"}).
	andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleRealRedditFirstPageResults]);
	
	stubRequest(@"GET", [NSString stringWithFormat:@"%@%@",[RSConstants redditApiUrl],@"&after=empty_data"]).
	withHeaders(@{@"Accept": @"application/json"}).
	andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleEmptyRedditResults]);
	
});


describe(@"WebService", ^{
	context(@"when instantiated", ^{
		it(@"should always return the same singleton object", ^{
			[[[RSWebService sharedService] should] equal:[RSWebService sharedService]];
		});
	});
	
	context(@"when getting the latest Reddit data", ^{
		it(@"should call a success block if successful", ^{
			stubRequest(@"GET", [RSConstants redditApiUrl]).
			withHeaders(@{@"Accept": @"application/json"}).
			andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleRealRedditFirstPageResults]);
			
			__block NSString* blockStatus = @"none";
			
			[[RSWebService sharedService] retrieveLatestRedditDataWithSuccessBlock:^(NSArray *dataObjects, NSString* beforePost, NSString* afterPost) {
				blockStatus = @"success";
				for (RSRedditPost* post in dataObjects) {
					if (post.thumbnail_url) {
						stubRequest(@"GET", post.thumbnail_url).
						withHeaders(@{ @"Accept": @"image/*" });
					}
				}
			} andFailureBlock:^(NSString *message, NSError *error) {
				blockStatus = @"failure";
			}];
			
			[[expectFutureValue(blockStatus) shouldEventually] equal:@"success"];
		});
	});
	
	context(@"when getting the latest Reddit data", ^{
		it(@"should call a failure block if there is a network failure", ^{
			
			[[LSNocilla sharedInstance] clearStubs];
			stubRequest(@"GET", [RSConstants redditApiUrl]).
			withHeaders(@{@"Accept": @"application/json"}).
			andFailWithError([NSError errorWithDomain:@"foo" code:500 userInfo:nil]);
			
			__block NSString* blockStatus = @"none";
			
			[[RSWebService sharedService] retrieveLatestRedditDataWithSuccessBlock:^(NSArray *dataObjects, NSString* beforePost, NSString* afterPost) {
				blockStatus = @"success";
				for (RSRedditPost* post in dataObjects) {
					if (post.thumbnail_url) {
						stubRequest(@"GET", post.thumbnail_url).
						withHeaders(@{ @"Accept": @"image/*" });
					}
				}
			} andFailureBlock:^(NSString *message, NSError *error) {
				blockStatus = @"failure";
				stubRequest(@"GET", [RSConstants redditApiUrl]).
				withHeaders(@{@"Accept": @"application/json"}).
				andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleRealRedditFirstPageResults]);
			}];
			
			[[expectFutureValue(blockStatus) shouldEventually] equal:@"failure"];
		});
	});
	
	context(@"when getting the second page of reddit data", ^{
		it(@"should call a success block with post data", ^{
			__block NSArray* resultsArray = nil;
			[[RSWebService sharedService] retrieveRedditDataAfter:@"t3_1kluu8" withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
				resultsArray = dataObjects;
				[[theValue(dataObjects.count) should] beGreaterThan:theValue(0)];
				for (RSRedditPost* object in dataObjects) {
					if (object.thumbnail_url) {
						stubRequest(@"GET", object.thumbnail_url).
						withHeaders(@{ @"Accept": @"image/*" });
					}
					[[object should] beNonNil];
					[[[object title] should] beNonNil];
				}
				[[beforePost should] beNonNil];
			} andFailureBlock:^(NSString *message, NSError *error) {
				fail(@"failure block called");
			}];
			[[resultsArray shouldEventually] beNonNil];
		});
	});
	
	context(@"when going to a previous page of valid reddit data", ^{
		__block NSArray* resultsArray = nil;
		it (@"should call a success block with post data", ^{
			[[RSWebService sharedService] retrieveRedditDataAfter:@"t3_1kluu8" withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
				[[RSWebService sharedService] retrieveRedditDataBefore:@"t3_1kmotr" withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
					resultsArray = dataObjects;
					[[theValue(dataObjects.count) should] beGreaterThan:theValue(0)];
					for (RSRedditPost* object in dataObjects) {
						[[object should] beNonNil];
						[[[object title] should] beNonNil];
						if (object.thumbnail_url) {
							stubRequest(@"GET", object.thumbnail_url).
							withHeaders(@{ @"Accept": @"image/*" });
						}
					}
				} andFailureBlock:^(NSString *message, NSError *error) {
					fail(@"failure block called");
				}];
			} andFailureBlock:^(NSString *message, NSError *error) {
				fail(@"failure block called");
			}];
			[[resultsArray shouldEventually] beNonNil];
		});
	});
	
	context(@"when fetching an empty page", ^{
		it (@"should call a failure block with the correct error code", ^{
			__block NSArray* resultsArray = nil;
			[[RSWebService sharedService] retrieveRedditDataAfter:@"empty_data" withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
				resultsArray = dataObjects;
				[[theValue(dataObjects.count) should] equal:theValue(0)];
				for (RSRedditPost* post in dataObjects) {
					if (post.thumbnail_url) {
						stubRequest(@"GET", post.thumbnail_url).
						withHeaders(@{ @"Accept": @"image/*" });
					}
				}
			} andFailureBlock:^(NSString *message, NSError *error) {
				fail(@"failure block called");
			}];
			[[resultsArray shouldEventually] beNonNil];
		});
	});
});


SPEC_END
