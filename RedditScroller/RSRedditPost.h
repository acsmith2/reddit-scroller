//
//  RSRedditPost.h
//  RedditScroller
//
//  Created by Adam Smith on 8/12/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSRedditPost : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* domain;
@property (strong, nonatomic) NSString* subreddit;
@property (strong, nonatomic) NSString* selftext;
@property (strong, nonatomic) NSString* thumbnail_url;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* posterName;
@property NSInteger score;
@property NSInteger numberOfComments;
@property Boolean isNSFW;
@property Boolean isSelfText;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
