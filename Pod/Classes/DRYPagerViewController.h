//
//  DRYPagerViewController.h
//  Pods
//
//  Created by Michael Seghers on 25/10/15.
//
//

#import <UIKit/UIKit.h>
#import "DRYPagerView.h"

@protocol DRYPagerViewControllerDataSource <NSObject>

- (NSUInteger)startIndex;
- (UIViewController *)controllerAtIndex:(NSUInteger)index;

@end


@interface DRYPagerViewController : UIViewController<DRYPagerDelegate, DRYPagerDataSource>

@property (nonatomic, weak) id<DRYPagerViewControllerDataSource> dataSource;
@property (nonatomic, readonly) UIViewController *leftViewController;
@property (nonatomic, readonly) UIViewController *middleViewController;
@property (nonatomic, readonly) UIViewController *rightViewController;

- (void)moveToNextPageAnimated:(BOOL)animated;
- (void)moveToPreviousPageAnimated:(BOOL)animated;

@end