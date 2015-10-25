//
//  DRYPagerView.h
//  Pods
//
//  Created by Michael Seghers on 25/10/15.
//
//

#import <UIKit/UIKit.h>

@class DRYPagerView;

typedef NS_ENUM(NSInteger, DRYPagerDirection) {
    DRYPagerDirectionNone = 0,
    DRYPagerDirectionToNext = 1,
    DRYPagerDirectionToPrevious = -1
};

@protocol DRYPagerDataSource <NSObject>

- (UIView * _Nullable)pagerViewPreviousPageView:(DRYPagerView * _Nonnull)pagerView;
- (UIView * _Nullable)pagerViewNextPageView:(DRYPagerView * _Nonnull)pagerView;

@end

@protocol DRYPagerDelegate <NSObject>

@optional

- (void)pagerView:(DRYPagerView * _Nonnull)pagerView didMoveInDirection:(DRYPagerDirection)direction;

@end


@interface DRYPagerView : UIScrollView

@property (nonatomic, weak) id<DRYPagerDelegate> scrollPagerDelegate;
@property (nonatomic, weak) id<DRYPagerDataSource> scrollPagerDataSource;

@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *middleView;
@property (nonatomic, weak) UIView *rightView;

- (void)moveToNextViewAnimated:(BOOL)animated;
- (void)moveToPreviousViewAnimated:(BOOL)animated;

@end