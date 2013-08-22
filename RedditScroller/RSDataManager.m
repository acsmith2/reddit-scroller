//
//  RSDataManager.m
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSDataManager.h"
#import "RSWebService.h"
#import "RSConstants.h"

@interface RSDataManager ()

@property (strong, nonatomic) NSMutableArray* posts;

@end

@implementation RSDataManager
+ (RSDataManager*) sharedManager
{
	static RSDataManager *sharedInstance = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[RSDataManager alloc] initPrivate];
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
		self.posts = [NSMutableArray array];
	}
	return self;
}

-(void)refreshRedditDataWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock
// Store the first page of Reddit posts into redditData
{
	[[RSWebService sharedService] retrieveLatestRedditDataWithSuccessBlock:^(NSArray *dataObjects, NSString* beforePost, NSString* afterPost) {
		if (dataObjects.count > 0) {
			[self.posts setArray:dataObjects];
			self.afterPost = afterPost;
			self.beforePost = beforePost;
			if (successBlock) {
				successBlock();
			}
		} else {
			if (failureBlock) {
				failureBlock(@"No objects returned",[NSError errorWithDomain:@"DataManager" code:kRSEmptyResultsErrorCode userInfo:nil]);
			}
		}
	} andFailureBlock:^(NSString *message, NSError *error) {
		if (failureBlock) {
			failureBlock(message,error);
		}
	}];
}

-(void)loadNextPageWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock
{
	[[RSWebService sharedService] retrieveRedditDataAfter:self.afterPost withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
		if (dataObjects.count > 0) {
			[self.posts setArray:dataObjects];
			self.beforePost = beforePost;
			self.afterPost = afterPost;
			if (successBlock) {
				successBlock();
			}
		} else {
			self.afterPost = nil;
			if (failureBlock) {
				failureBlock(@"No objects returned",[NSError errorWithDomain:@"DataManager" code:kRSEmptyResultsErrorCode userInfo:nil]);
			}
		}
		
	} andFailureBlock:^(NSString *message, NSError *error) {
		if (failureBlock) {
			failureBlock(message,error);
		}
	}];
}

-(void)loadPreviousPageWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock
{
	[[RSWebService sharedService] retrieveRedditDataBefore:self.beforePost withSuccessBlock:^(NSArray *dataObjects, NSString *beforePost, NSString *afterPost) {
		if (dataObjects.count > 0) {
			[self.posts setArray:dataObjects];
			self.beforePost = beforePost;
			self.afterPost = afterPost;
			if (successBlock) {
				successBlock();
			}
		} else {
			self.beforePost = nil;
			if (failureBlock) {
				failureBlock(@"No objects returned",[NSError errorWithDomain:@"DataManager" code:kRSEmptyResultsErrorCode userInfo:nil]);
			}
		}
		
	} andFailureBlock:^(NSString *message, NSError *error) {
		if (failureBlock) {
			failureBlock(message,error);
		}
	}];
}

-(Boolean)previousPageAvailable
{
	return (self.beforePost != nil);
}
-(Boolean)nextPageAvailable
{
	return (self.afterPost != nil);
}

-(NSArray*)redditData
{
	return self.posts;
}

-(void)clearRedditData
{
	[self.posts removeAllObjects];
	self.beforePost = nil;
	self.afterPost = nil;
}

@end
