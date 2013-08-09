//
//  RSAppDelegate.h
//  RedditScroller
//
//  Created by Adam Smith on 8/8/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSViewController;

@interface RSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RSViewController *viewController;

@end
