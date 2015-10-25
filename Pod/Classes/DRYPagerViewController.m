//
//  DRYPagerViewController.m
//  Pods
//
//  Created by Michael Seghers on 25/10/15.
//
//

#import "DRYPagerViewController.h"

@interface DRYPagerViewController () {
    DRYPagerView *_scrollView;
    UIViewController *_nextViewController;
    UIViewController *_previousViewController;
    
    NSUInteger _currentIndex;
}
@end

@implementation DRYPagerViewController {
    
}

#pragma mark - ViewController lifecycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[DRYPagerView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_scrollView];
    
    _scrollView.scrollPagerDelegate = self;
    _scrollView.scrollPagerDataSource = self;
    
    [self _loadDataFromDataSource];
}

- (void)setDataSource:(id<DRYPagerViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.isViewLoaded) {
        [self _loadDataFromDataSource];
    }
}

- (void)_loadDataFromDataSource {
    NSUInteger startIndex = [self.dataSource startIndex];
    _currentIndex = startIndex;
    [self _addViewController:[self.dataSource controllerAtIndex:startIndex] atOffset:1];
    if (startIndex > 0) {
        _previousViewController = [self.dataSource controllerAtIndex:(startIndex - 1)];
        [self _addViewController:_previousViewController atOffset:0];
    }
    _nextViewController = [self.dataSource controllerAtIndex:(startIndex + 1)];
    [self _addViewController:_nextViewController atOffset:2];
    
    [self _setNavigationItemsToMiddleViewControllerItems];
    [self _notifyViewControllerVisibility];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _scrollView.frame = self.view.bounds;
}

#pragma mark - Custom property accessors
- (NSArray *)viewControllers {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
    [self _addPossibleViewController:_leftViewController toArray:array];
    [self _addPossibleViewController:_middleViewController toArray:array];
    [self _addPossibleViewController:_rightViewController toArray:array];
    return [array copy];
}

- (void)_addPossibleViewController:(UIViewController *)viewController toArray:(NSMutableArray *)array {
    if (viewController) {
        [array addObject:viewController];
    }
}

#pragma mark - Move programmatically
- (void)moveToNextPageAnimated:(BOOL)animated {
    [_scrollView moveToNextViewAnimated:animated];
}

- (void)moveToPreviousPageAnimated:(BOOL)animated {
    [_scrollView moveToPreviousViewAnimated:animated];
}


#pragma mark - Private methods
- (void)_addViewController:(UIViewController *)viewController atOffset:(NSInteger)offset {
    if (offset == 0) {
        [_scrollView setLeftView:viewController.view];
        _leftViewController = viewController;
    } else if (offset == 1) {
        [_scrollView setMiddleView:viewController.view];
        _middleViewController = viewController;
        if (viewController) {
            [self.delegate pagerViewController:self didMoveToController:viewController];
        }
    } else if (offset == 2) {
        [_scrollView setRightView:viewController.view];
        _rightViewController = viewController;
    }
    if (viewController) {
        [viewController didMoveToParentViewController:self];
        [self addChildViewController:viewController];
    }
}

#pragma mark - ScrollPager delegate
- (void)pagerView:(DRYPagerView *)pagerView didMoveInDirection:(DRYPagerDirection)direction {
    UIViewController *viewController;
    if (direction == DRYPagerDirectionToNext) {
        viewController = _nextViewController;
        _nextViewController = nil;
        [_leftViewController willMoveToParentViewController:nil];
        [_leftViewController removeFromParentViewController];
        _leftViewController = _middleViewController;
        _middleViewController = _rightViewController;
        _rightViewController = viewController;
        _currentIndex++;
        if (viewController) {
            [self addChildViewController:viewController];
        }
    } else {
        viewController = _previousViewController;
        _previousViewController = nil;
        [_rightViewController willMoveToParentViewController:nil];
        [_rightViewController removeFromParentViewController];
        _rightViewController = _middleViewController;
        _middleViewController = _leftViewController;
        _leftViewController = viewController;
        _currentIndex--;
        if (viewController) {
            [self addChildViewController:viewController];
        }
    }
    
    [self.delegate pagerViewController:self didMoveToController:_middleViewController];
    
    [self _setNavigationItemsToMiddleViewControllerItems];
    [self _notifyViewControllerVisibility];
}

- (void)_setNavigationItemsToMiddleViewControllerItems {
    self.navigationItem.leftBarButtonItems = _middleViewController.navigationItem.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = _middleViewController.navigationItem.rightBarButtonItems;
    self.title = _middleViewController.title;
    self.navigationItem.titleView = _middleViewController.navigationItem.titleView;
}

- (void)_notifyViewControllerVisibility {
    [self _notifyViewControllerIsInvisibleToUser:_leftViewController];
    [self _notifyViewControllerIsVisbleToUser:_middleViewController];
    [self _notifyViewControllerIsInvisibleToUser:_rightViewController];
}

- (void)_notifyViewControllerIsVisbleToUser:(UIViewController *)viewController {
    if([viewController respondsToSelector:@selector(didBecomeVisibleInPagerViewController:)]) {
        [(id<DRYContainedInPagerViewControllerAware>)viewController didBecomeVisibleInPagerViewController:self];
    }
}

- (void)_notifyViewControllerIsInvisibleToUser:(UIViewController *)viewController {
    if([viewController respondsToSelector:@selector(didBecomeInvisibleInPagerViewController:)]) {
        [(id<DRYContainedInPagerViewControllerAware>)viewController didBecomeInvisibleInPagerViewController:self];
    }
}

#pragma mark - ScrollPager datasource

- (UIView *)pagerViewNextPageView:(DRYPagerView *)pagerView {
    _nextViewController = [self.dataSource controllerAtIndex:(_currentIndex + 2)];
    [_nextViewController willMoveToParentViewController:self];
    return _nextViewController.view;
}

- (UIView *)pagerViewPreviousPageView:(DRYPagerView *)pagerView {
    _previousViewController = [self.dataSource controllerAtIndex:(_currentIndex - 2)];
    [_previousViewController willMoveToParentViewController:self];
    return _previousViewController.view;
}

@end