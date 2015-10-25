//
//  DRYPagerView.m
//  Pods
//
//  Created by Michael Seghers on 25/10/15.
//
//

#import "DRYPagerView.h"


#define NUMBER_OF_PAGES 3

@interface DRYPagerView () {
    CGFloat _mostShownPage;
    
    UIView *_previousView;
    UIView *_nextView;
}
@end

@implementation DRYPagerView {
    
}

#pragma mark - View lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self _updateFrameDependentProperties:frame];
        _mostShownPage = 1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat pageWidth = self.frame.size.width;
    CGFloat currentOffset = self.contentOffset.x;
    int movingToPage = (int) floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if ((currentOffset <= 0 || currentOffset >= pageWidth * 2) && _mostShownPage != 1) {
        DRYPagerDirection direction = _mostShownPage > 1 ? DRYPagerDirectionToNext : DRYPagerDirectionToPrevious;
        [self _loadAndMoveToDirection:direction forCurrentOffset:currentOffset];
    } else if (movingToPage != _mostShownPage) {
        _mostShownPage = movingToPage;
    }
}

- (void)_loadAndMoveToDirection:(DRYPagerDirection)direction forCurrentOffset:(CGFloat)currentOffset {
    [self _loadAuxilaryViewInDirection:direction];
    [self _moveAllViewsAndResetOffsetToConfirmPagingInDirection:direction forOffset:currentOffset];
}

#pragma mark - Frame scaffolding
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self _updateSubViewsForNewFrame:frame];
}

- (void)_updateSubViewsForNewFrame:(CGRect)frame {
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    _previousView.frame = CGRectMake(width, 0, width, height);
    _leftView.frame = CGRectMake(0, 0, width, height);
    _middleView.frame = CGRectMake(width, 0, width, height);
    _rightView.frame = CGRectMake(width * 2, 0, width, height);
    _nextView.frame = CGRectMake(width * 3, 0, width, height);
    [self _updateFrameDependentProperties:frame];
}

- (void)_updateFrameDependentProperties:(CGRect)frame {
    self.contentSize = CGSizeMake(frame.size.width * NUMBER_OF_PAGES, frame.size.height);
    self.contentOffset = CGPointMake(frame.size.width, 0);
    [self _updateContentInset];
}

- (void)_updateContentInset {
    CGFloat leftInset = 0;
    CGFloat rightInset = 0;
    if (!_leftView) {
        leftInset = -self.bounds.size.width;
    }
    if (!_rightView) {
        rightInset = -self.bounds.size.width;
    }
    
    self.contentInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
}

#pragma mark - Infinite scrolling
- (void)_moveAllViewsAndResetOffsetToConfirmPagingInDirection:(DRYPagerDirection)direction forOffset:(CGFloat) offset {
    if (direction == DRYPagerDirectionToNext) {
        [self _moveViewsToLeft];
    } else {
        [self _moveViewsToRight];
    }
    CGFloat bounceOffsetCompensation = fmodf(offset, self.bounds.size.width);
    self.contentOffset = CGPointMake(self.bounds.size.width + bounceOffsetCompensation, self.contentOffset.y);
    _mostShownPage = 1;
    
    if ([self.scrollPagerDelegate respondsToSelector:@selector(pagerView:didMoveInDirection:)]) {
        [self.scrollPagerDelegate pagerView:self didMoveInDirection:direction];
    }
}

- (void)_moveViewsToRight {
    if (_leftView) {
        [_nextView removeFromSuperview];
        _nextView = nil;
        [_rightView removeFromSuperview];
        self.rightView = _middleView;
        self.middleView = _leftView;
        self.leftView = _previousView;
        _previousView = nil;
    }
}

- (void)_moveViewsToLeft {
    if (_rightView) {
        [_previousView removeFromSuperview];
        _previousView = nil;
        [_leftView removeFromSuperview];
        self.leftView = _middleView;
        self.middleView = _rightView;
        self.rightView = _nextView;
        _nextView = nil;
    }
}

- (void)_loadAuxilaryViewInDirection:(DRYPagerDirection)direction {
    if (direction == DRYPagerDirectionToNext) {
        [self _setNextView:[self.scrollPagerDataSource pagerViewNextPageView:self]];
    } else if (direction == DRYPagerDirectionToPrevious) {
        [self _setPreviousView:[self.scrollPagerDataSource pagerViewPreviousPageView:self]];
    }
}

#pragma mark - Subview maintenance
- (void)_setPreviousView:(UIView *)previousView {
    if (_previousView != previousView) {
        [_previousView removeFromSuperview];
        _previousView = previousView;
        previousView.frame = CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:_previousView];
    }
}

- (void)_setNextView:(UIView *)nextView {
    if (_nextView != nextView) {
        [_nextView removeFromSuperview];
        _nextView = nextView;
        nextView.frame = CGRectMake(self.bounds.size.width * 3, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:_nextView];
    }
}

- (void)setLeftView:(UIView *)leftView {
    if (!leftView) {
        if (_leftView != _middleView) {
            [_leftView removeFromSuperview];
        }
        _leftView = nil;
        [self _updateContentInset];
    } else if (_leftView != leftView) {
        _leftView = leftView;
        leftView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:leftView];
        [self _updateContentInset];
    }
}

- (void)setMiddleView:(UIView *)middleView {
    if (_middleView != middleView) {
        _middleView = middleView;
        middleView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:middleView];
        [self _updateContentInset];
    }
}

- (void)setRightView:(UIView *)rightView {
    if (!rightView) {
        if (_rightView != _middleView) {
            [_rightView removeFromSuperview];
        }
        _rightView = nil;
        [self _updateContentInset];
    } else if (_rightView != rightView) {
        _rightView = rightView;
        rightView.frame = CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:rightView];
        [self _updateContentInset];
    }
}

- (void)moveToNextViewAnimated:(BOOL)animated {
    if (_rightView) {
        _mostShownPage = 2;
        [self setContentOffset:CGPointMake(self.bounds.size.width * 2, self.contentOffset.y) animated:animated];
    }
}


- (void)moveToPreviousViewAnimated:(BOOL)animated {
    if (_leftView) {
        _mostShownPage = 0;
        [self setContentOffset:CGPointMake(0, self.contentOffset.y) animated:animated];
    }
}

@end
