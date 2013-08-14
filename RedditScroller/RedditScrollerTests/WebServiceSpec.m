#import "Kiwi.h"
#import "RSConstants.h"
#import "RSWebService.h"

SPEC_BEGIN(WebServiceSpec)


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
	
	context(@"when getting Reddit data", ^{
		it(@"should call a success block if successful", ^{
			
		});
	});
});


SPEC_END