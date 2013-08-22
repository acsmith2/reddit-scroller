//
//  RSFakeRedditData.h
//  RedditScroller
//
//  Created by Adam Smith on 8/18/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSFakeRedditData : NSObject

+(NSDictionary*)sampleUrlResultDictionary;
+(NSDictionary*)sampleSelfTextResultDictionary;
+(NSArray*)sampleResultArray;


+(NSString*)sampleRealRedditFirstPageResults;
+(NSString*)sampleReadRedditSecondPageResults;
+(NSString*)sampleRealRedditFakeLastPageResults;
+(NSString*)sampleEmptyRedditResults;
@end
