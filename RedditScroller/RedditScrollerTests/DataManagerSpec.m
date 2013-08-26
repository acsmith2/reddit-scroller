#import "Kiwi.h"
#import "RSRedditPost.h"
#import "RSConstants.h"
#import "RSDataManager.h"
#import "Nocilla.h"
#import "RSFakeRedditData.h"

SPEC_BEGIN(DataManagerSpec)

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

	NSArray* allPosts = [[RSDataManager sharedManager] redditData];
	for (RSRedditPost* post in allPosts) {
		if (post.thumbnail_url) {
			stubRequest(@"GET", post.thumbnail_url).
			withHeaders(@{ @"Accept": @"image/*" });
		}
	}
});


describe(@"DataManager", ^{
	context(@"when instantiated", ^{
		it(@"should always return the same singleton object", ^{
			[[[RSDataManager sharedManager] should] equal:[RSDataManager sharedManager]];
		});
	});
	
	context(@"when refreshing for the first time", ^{
		it(@"should replace an empty list with some current data", ^{
			
			__block NSNumber *dataCount = [NSNumber numberWithInt:[[RSDataManager sharedManager] redditData].count];
			[[dataCount should] equal:[NSNumber numberWithInt:0]];
			[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
				dataCount = [NSNumber numberWithInt:[[RSDataManager sharedManager] redditData].count];
				[[expectFutureValue(dataCount) should] beGreaterThan:theValue(0)];
			} andFailureBlock:^(NSString *message, NSError* error) {
				fail(@"refresh call failed");
			}];
			
			
		});
		
		it(@"should store the name of the afterpost and make the beforepost nil", ^{
			[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
				[[[[RSDataManager sharedManager] afterPost] should] beNonNil];
				[[[[RSDataManager sharedManager] beforePost] should] beNil];
			} andFailureBlock:^(NSString *message, NSError* error) {
				fail(@"refresh call failed");
			}];
			
		});
		
	});
	
	context(@"when cleared", ^{
		it(@"should be empty", ^{
			[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
				int dataCount = [[RSDataManager sharedManager] redditData].count;
				[[theValue(dataCount) should] beGreaterThan:theValue(0)];
				[[RSDataManager sharedManager] clearRedditData];
				[[[[RSDataManager sharedManager] afterPost] should] beNil];
				[[[[RSDataManager sharedManager] beforePost] should] beNil];
				[[[[RSDataManager sharedManager] redditData] should] beEmpty];
			} andFailureBlock:^(NSString *message, NSError* error) {
				fail(@"initial refresh call failed");
			}];
			
		});
	});
	
	
	context(@"when refreshing for not the first time", ^{
		it(@"there should not be new data appended to old data", ^{
			[[RSDataManager sharedManager] clearRedditData];
			[[[[RSDataManager sharedManager] redditData] should] beEmpty];
			[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
				int dataCount = [[RSDataManager sharedManager] redditData].count;
				[[theValue(dataCount) should] beGreaterThan:theValue(0)];
				
				NSArray* oldData = [NSArray arrayWithArray:[[RSDataManager sharedManager] redditData]];
				
				[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
					[[[[RSDataManager sharedManager] beforePost] should] beNil];
					[[[[RSDataManager sharedManager] afterPost] should] beNonNil];
					NSArray* newData = [NSArray arrayWithArray:[[RSDataManager sharedManager] redditData]];
					Boolean okRangeForSure = oldData.count >= newData.count;
					if (!okRangeForSure) {
						NSRange range = NSMakeRange(0, oldData.count);
						NSArray* halfOfNewData = [newData subarrayWithRange:range];
						Boolean areEqual = [halfOfNewData isEqualToArray:oldData];
						[[theValue(areEqual) should] beFalse];
					}
				} andFailureBlock:^(NSString *message, NSError* error) {
					fail(@"Second refresh failed");
				}];
			} andFailureBlock:^(NSString *message, NSError* error) {
				fail(@"First refresh failed");
			}];
		});
	});
	
	context(@"when incrementing the page", ^{
		it(@"should store a before value and an after value", ^{
			[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
				
				[[RSDataManager sharedManager] loadNextPageWithSuccessBlock:^{
					[[[[RSDataManager sharedManager] beforePost] should] beNonNil];
					[[[[RSDataManager sharedManager] afterPost] should] beNonNil];	// Making the assumption that the second page is not the last bit of Reddit data
					int count = [[RSDataManager sharedManager] redditData].count;
					[[theValue(count) should] beGreaterThan:theValue(0)];
				} andFailureBlock:^(NSString *message, NSError* error) {
					fail(@"Failed to append data");
				}];
			} andFailureBlock:^(NSString *message, NSError* error) {
				fail(@"failed to refresh data");
			}];
		});
	});
	
	context(@"when decrementing a page", ^{
		it(@"should store an after value", ^{
			
			[[RSDataManager sharedManager] refreshRedditDataWithSuccessBlock:^{
				[[RSDataManager sharedManager] loadNextPageWithSuccessBlock:^{
					[[RSDataManager sharedManager] loadPreviousPageWithSuccessBlock:^{
						[[[[RSDataManager sharedManager] afterPost] should] beNonNil];
					} andFailureBlock:^(NSString *message, NSError* error) {
						fail(@"Failed to get previous data");
					}];
				} andFailureBlock:^(NSString *message, NSError* error) {
					fail(@"Failed to get next data");
				}];
			} andFailureBlock:^(NSString *message, NSError* error) {
				fail(@"failed to refresh data");
			}];
			
		});
	});
});
SPEC_END
