//
//  RSDataManager.h
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RSDataUpdatedSuccessBlock) ();
typedef void (^RSDataUpdateFailureBlock) (NSString* message, NSError* error);

@interface RSDataManager : NSObject

+(RSDataManager*)sharedManager;

-(void)refreshRedditDataWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock;
-(void)loadNextPageWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock;
-(void)loadPreviousPageWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock;

-(Boolean)previousPageAvailable;
-(Boolean)nextPageAvailable;;

-(NSArray*)redditData;
-(void)clearRedditData;

@property (strong) NSString* beforePost;
@property (strong) NSString* afterPost;

@end
