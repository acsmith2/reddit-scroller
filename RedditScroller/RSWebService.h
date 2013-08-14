//
//  RSWebService.h
//  RedditScroller
//
//  Created by Adam Smith on 8/13/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^RSArrayNetworkSuccessBlock) (NSArray* dataObjects);
typedef void (^RSNetworkFailureBlock) (NSString* message, NSError *error);

@interface RSWebService : NSObject

+(RSWebService*)sharedService;

-(void) retrieveLatestRedditDataWithSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock;
-(void) retrieveRedditDataAfter:(NSString*)postName withSuccessBlock:(RSArrayNetworkSuccessBlock)successBlock andFailureBlock:(RSNetworkFailureBlock)failureBlock;

@end
