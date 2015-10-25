//
//  DRYPagerViewController.h
//  Pods
//
//  Created by Michael Seghers on 25/10/15.
//
//

#import <UIKit/UIKit.h>
#import "DRYPagerView.h"

@class DRYPagerViewController;

@protocol DRYPagerViewControllerDataSource <NSObject>

- (NSUInteger)startIndex;
- (UIViewController * _Nullable)controllerAtIndex:(NSUInteger)index;

@end

@protocol DRYPagerViewControllerDelegate <NSObject>

- (void)pagerViewController:(DRYPagerViewController * _Nonnull)pageViewController didMoveToController:(UIViewController * _Nonnull)controller;

@end

@protocol DRYContainedInPagerViewControllerAware <NSObject>

- (void)didBecomeVisibleInPagerViewController:(DRYPagerViewController * _Nonnull)pagerViewController;
- (void)didBecomeInvisibleInPagerViewController:(DRYPagerViewController * _Nonnull)pagerViewController;

@end


@interface DRYPagerViewController : UIViewController<DRYPagerDelegate, DRYPagerDataSource>

@property (nonatomic, weak) id<DRYPagerViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<DRYPagerViewControllerDelegate> delegate;
@property (nonatomic, readonly) UIViewController * _Nullable leftViewController;
@property (nonatomic, readonly) UIViewController * _Nullable middleViewController;
@property (nonatomic, readonly) UIViewController * _Nullable rightViewController;

- (void)moveToNextPageAnimated:(BOOL)animated;
- (void)moveToPreviousPageAnimated:(BOOL)animated;

@end