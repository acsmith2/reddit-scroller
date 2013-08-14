//
//  RSDataManager.h
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RSDataUpdatedSuccessBlock) ();
typedef void (^RSDataUpdateFailureBlock) (NSString* message);

@interface RSDataManager : NSObject

+(RSDataManager*)sharedManager;

-(void)refreshRedditDataWithSuccessBlock:(RSDataUpdatedSuccessBlock)successBlock andFailureBlock:(RSDataUpdateFailureBlock)failureBlock;
-(NSArray*)redditData;

@end
