#import "Kiwi.h"
#import "RSRedditPost.h"
#import "RSConstants.h"
#import "RSDataManager.h"

SPEC_BEGIN(DataManagerSpec)

// 4. Should repopulate list upon refresh
// 5. Should create different model types from dictionary
// 6. Should create a self-text post that loads itself
// 7. Should launch a webview if its a link post
// 8. Empty self texts should be discarded
// 10. after should return results that are unique from the regular one
// 11. "after" property should be the same one as before

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
			} andFailureBlock:^(NSString *message) {
				
			}];
			
			[[expectFutureValue(dataCount) shouldEventuallyBeforeTimingOutAfter(4)] beGreaterThan:[NSNumber numberWithInt:0]];
		});
	});
});
SPEC_END
