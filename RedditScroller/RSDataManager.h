//
//  RSDataManager.h
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSDataManager : NSObject

+(RSDataManager*)sharedManager;

-(void)refreshRedditData;
-(NSArray*)redditData;

@end
