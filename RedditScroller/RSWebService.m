//
//  RSWebService.m
//  RedditScroller
//
//  Created by Adam Smith on 8/13/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSWebService.h"
#import "RSRedditPost.h"
#import "RSConstants.h"

@implementation RSWebService

+ (RSWebService*) sharedService
{
	static RSWebService *sharedInstance = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[RSWebService alloc] initPrivate];
	});
	return sharedInstance;
}

-(id)init {
	NSAssert1(false, @"Should not call -init for this class",nil);
	return nil;
}

-(id)initPrivate
{
	self = [super init];
	if (self) {
	
	}
	return self;
}

-(NSString*)redditUrlPathWithAfterParameter:(NSString*)param
{
	NSString* url = kRSRedditApiUrl;
	if (param != nil) {
		return [NSString stringWithFormat:@"%@?after=%@",url,param];
	} else {
		return url;
	}
}


-(NSURLRequest*)createJsonGetUrlRequestWithAfterParam:(NSString*)param
{
	NSString* urlString = [self redditUrlPathWithAfterParameter:param];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	return request;
}



-(void) retrieveRedditDataAfter:(NSString*)postName withSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	NSURLRequest* request = [self createJsonGetUrlRequestWithAfterParam:postName];
	AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		
		NSDictionary* listingData = JSON[kRSDataKey];
		NSArray* dataChildren = listingData[kRSChildrenKey];
		
		NSMutableArray* resultsArray = [NSMutableArray array];
		
		for (NSDictionary* postDictionary in dataChildren) {
			NSLog(@"about to create post");
			RSRedditPost *newPost = [[RSRedditPost alloc] initWithDictionary:postDictionary];
			if (newPost) {
				[resultsArray addObject:newPost];
			}
		}
		
		if (successBlock) {
				successBlock(resultsArray);
		}
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		if (failureBlock) {
			failureBlock(@"Failed to retrieve data from Reddit.",error);
		}
	}];
	[operation start];
}


-(void) retrieveLatestRedditDataWithSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	[self retrieveRedditDataAfter:nil withSuccessBlock:successBlock andFailureBlock:failureBlock];
}

@end
