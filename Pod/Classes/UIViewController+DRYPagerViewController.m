//
//  UIViewController+DRYPagerViewController.m
//  Pods
//
//  Created by Michael Seghers on 25/10/15.
//
//

#import "UIViewController+DRYPagerViewController.h"

@implementation UIViewController (DRYPagerViewController)

- (DRYPagerViewController *)dryPagerViewController {
    if([self.parentViewController isKindOfClass:DRYPagerViewController.class]){
        return (DRYPagerViewController *)self.parentViewController;
    } else {
        return [self.parentViewController dryPagerViewController];
    }
}

@end
