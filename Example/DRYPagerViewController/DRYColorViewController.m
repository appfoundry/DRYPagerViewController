//
//  DRYColorViewController.m
//  DRYPagerViewController
//
//  Created by Michael Seghers on 25/10/15.
//  Copyright © 2015 Michael Seghers. All rights reserved.
//

#import "DRYColorViewController.h"
#import <DRYPagerViewController/UIViewController+DRYPagerViewController.h>

@interface DRYColorViewController ()

@end

@implementation DRYColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.color;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [left setTitle:@"Prev" forState:UIControlStateNormal];
    [self.view addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [right setTitle:@"Next" forState:UIControlStateNormal];
    [self.view addSubview:right];
    
    left.translatesAutoresizingMaskIntoConstraints = NO;
    right.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * elements = NSDictionaryOfVariableBindings(left, right);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[left]-[right(==left)]-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:elements]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[left]|" options:0 metrics:nil views:elements]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[right]|" options:0 metrics:nil views:elements]];
    
    [left addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [right addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setColor:(UIColor *)color {
    if (![_color isEqual:color]) {
        _color = color;
        if (self.isViewLoaded) {
            self.view.backgroundColor = color;
        }
    }
}

- (IBAction)previous:(id)sender {
    [self.dryPagerViewController moveToPreviousPageAnimated:YES];
}

- (IBAction)next:(id)sender {
    [self.dryPagerViewController moveToNextPageAnimated:NO];
}


@end
