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

afterAll(^{
	
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
});

afterEach(^{
	
});


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

describe(@"WebService", ^{
	context(@"when instantiated", ^{
		it(@"should always return the same singleton object", ^{
			[[[RSWebService sharedService] should] equal:[RSWebService sharedService]];
		});
	});
	
	context(@"when getting the latest Reddit data", ^{
		it(@"should call a success block if successful", ^{
			NSLog(@"*******$$$$$$$$$$$$$$$ failing test $$$$$$$$$$$$$$$");
			stubRequest(@"GET", [RSConstants redditApiUrl]).
			withHeaders(@{@"Accept": @"application/json"}).
			andReturn(200).withHeaders(@{@"Content-Type": @"application/json"}).withBody([RSFakeRedditData sampleRealRedditFirstPageResults]);
			
			__block NSString* blockStatus = @"none";
			
			[[RSWebService sharedService] retrieveLatestRedditDataWithSuccessBlock:^(NSArray *dataObjects, NSString* beforePost, NSString* afterPost) {
				blockStatus = @"success";
			} andFailureBlock:^(NSString *message, NSError *error) {
				blockStatus = @"failure";
			}];
			
			[[expectFutureValue(blockStatus) shouldEventuallyBeforeTimingOutAfter(4)] equal:@"success"];
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
			[[RSWebService sharedService] retrieveRedditDataAfter:@"t3_1kluu8" withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
				[[theValue(dataObjects.count) should] beGreaterThan:theValue(0)];
				for (RSRedditPost* object in dataObjects) {
					[[object should] beNonNil];
					[[[object title] should] beNonNil];
				}
			 [[beforePost should] beNonNil];			 
			} andFailureBlock:^(NSString *message, NSError *error) {
				fail(@"failure block called");
			}];
		});
	});
});


SPEC_END