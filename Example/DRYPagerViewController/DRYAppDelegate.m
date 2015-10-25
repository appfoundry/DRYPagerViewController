//
//  DRYAppDelegate.m
//  DRYPagerViewController
//
//  Created by Michael Seghers on 10/25/2015.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYPagerViewController/DRYPagerViewController.h>
#import "DRYAppDelegate.h"
#import "DRYColorViewController.h"


@interface DRYAppDelegate () <DRYPagerViewControllerDataSource, DRYPagerViewControllerDelegate> {
    NSArray *_colors;
}

@end

@implementation DRYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _colors = @[
                [UIColor redColor],
                [UIColor grayColor],
                [UIColor blueColor],
                [UIColor greenColor],
                [UIColor yellowColor],
                ];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    DRYPagerViewController *pagerViewController = [[DRYPagerViewController alloc] init];
    pagerViewController.dataSource = self;
    pagerViewController.delegate = self;
    pagerViewController.view.backgroundColor = [UIColor purpleColor];

    self.window.rootViewController = pagerViewController;
    [self.window makeKeyAndVisible];   return YES;
}

- (NSUInteger)startIndex {
    return 2;
}

- (UIViewController *)controllerAtIndex:(NSUInteger)index {
    if (index < _colors.count) {
        DRYColorViewController *colorVC = [[DRYColorViewController alloc] init];
        colorVC.color = _colors[index];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:colorVC];
        return nc;
    } else {
        return nil;
    }
}

- (void)pagerViewController:(DRYPagerViewController *)pageViewController didMoveToController:(UIViewController *)controller {
    NSLog(@"Showing controller with color %@", [((UINavigationController *)controller).viewControllers.firstObject color]);
}
@end
