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

-(NSString*)redditUrlPathWithBeforeParameter:(NSString*)param
{
	NSString* url = [RSConstants redditApiUrl];
	if (param != nil) {
		return [NSString stringWithFormat:@"%@&before=%@",url,param];
	} else {
		return url;
	}
}

-(NSString*)redditUrlPathWithAfterParameter:(NSString*)param
{
	NSLog(@"redditUrlPathWithAfterParameter %@",param);
	NSString* url = [RSConstants redditApiUrl];
	if (param != nil) {
		return [NSString stringWithFormat:@"%@&after=%@",url,param];
	} else {
		return url;
	}
}

-(NSURLRequest*)createJsonGetRequestAtUrl:(NSString*)urlString
{
	NSLog(@"createJsonGetRequestAtUrl");
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	return request;
}

-(NSURLRequest*)createJsonGetUrlRequestWithAfterParam:(NSString*)after
{
	NSLog(@"createJsonGetUrlRequestWithAfterParam %@",after);
	return [self createJsonGetRequestAtUrl:[self redditUrlPathWithAfterParameter:after]];
}

-(NSURLRequest*)createJsonGetUrlRequestWithBeforeParam:(NSString*)before
{
	return [self createJsonGetRequestAtUrl:[self redditUrlPathWithBeforeParameter:before]];
}

-(void)retrieveRedditDataWithRequest:(NSURLRequest*)request successBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	NSLog(@"retrieveRedditDataWitHRequest");
	AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"retrieved data");
		NSDictionary* listingData = JSON[kRSDataKey];
		NSArray* dataChildren = listingData[kRSChildrenKey];
		if (!dataChildren || (dataChildren == (id)[NSNull null])) {
			if (failureBlock) {
				failureBlock(@"Could not retrieve data",nil);
			}
		}
		
		NSString* beforePost = (listingData[kRSBeforeKey] != (id)[NSNull null]) ? listingData[kRSBeforeKey] : nil;
		NSString* afterPost = (listingData[kRSAfterKey] != (id)[NSNull null]) ? listingData[kRSAfterKey] : nil;
		
		NSLog(@"beforePost: %@ afterPost: %@",beforePost,afterPost);
		
		NSLog(@"before post == nil %d",beforePost == nil);
		
		NSMutableArray* resultsArray = [NSMutableArray array];
		
		for (NSDictionary* postDictionary in dataChildren) {
			RSRedditPost *newPost = [[RSRedditPost alloc] initWithDictionary:postDictionary];
			if (newPost) {
				if (!(newPost.isSelfText && ((newPost.selftext == nil) || ([newPost.selftext isEqualToString:@""])))) {
					[resultsArray addObject:newPost];
				}
			}
		}
		
		if (successBlock) {
			successBlock(resultsArray, beforePost, afterPost);
		}
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"failed to retrieve data");
		if (failureBlock) {
			failureBlock(@"Failed to retrieve data from Reddit.",error);
		}
	}];
	
	NSLog(@"created operation");
	[operation start];
	
}

-(void) retrieveRedditDataBefore:(NSString *)beforeName withSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	NSLog(@"retrieveRedditDataBefore");
	NSURLRequest* request = [self createJsonGetUrlRequestWithBeforeParam:beforeName];
	[self retrieveRedditDataWithRequest:request successBlock:successBlock andFailureBlock:failureBlock];
}

-(void) retrieveRedditDataAfter:(NSString*)postName withSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	NSLog(@"retrieveRedditDataAfter: %@",postName);
	NSURLRequest* request = [self createJsonGetUrlRequestWithAfterParam:postName];
	[self retrieveRedditDataWithRequest:request successBlock:successBlock andFailureBlock:failureBlock];
}

-(void) retrieveLatestRedditDataWithSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	NSLog(@"retrieveLatestRedditDataWithSuccessBlock");
	[self retrieveRedditDataAfter:nil withSuccessBlock:successBlock andFailureBlock:failureBlock];
}

@end
