//
//  RSWebService.m
//  RedditScroller
//
//  Created by Adam Smith on 8/13/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSWebService.h"
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


-(void) retrieveRedditDataAfter:(NSString*)postName withSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{

}


-(void) retrieveLatestRedditDataWithSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock
{
	[self retrieveRedditDataAfter:nil withSuccessBlock:successBlock andFailureBlock:failureBlock];
}

@end
