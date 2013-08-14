//
//  RSDataManager.m
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSDataManager.h"

@interface RSDataManager ()

@property (strong) NSMutableArray* posts;

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

-(void)refreshRedditData
{
	[self.posts removeAllObjects];
}

-(NSArray*)redditData
{
	return [NSArray arrayWithArray:self.posts];
}

@end