//
//  ModelController.h
//  ieda
//
//  Created by Yu Chen on 7/7/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end
