//
//  TMTopLevelViewController.m
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTopLevelViewController.h"

#import "TMTopBarViewController.h"

TMTopLevelViewController *_controller = nil;

const NSInteger TMTopBarHeight = 20;

@interface TMTopLevelViewController ()

@end

@implementation TMTopLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        topBarController = [[TMTopBarViewController alloc] init];
        showingTopBar = NO;
    }
    
    _controller = self;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![self.view.subviews containsObject:topBarController.view]) {
        CGRect frm = self.view.frame;
        frm.origin.y = 0;
        frm.size.height = 20;
        topBarController.view.frame = frm;
        [self.view addSubview:topBarController.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavigationController:(UINavigationController *)navigationController
{
    CGRect frm = self.view.frame;
    frm.origin.y = 0;
    [self.view addSubview:navigationController.view];
    navigationController.view.frame = frm;
    navController = navigationController;
    [self addChildViewController:navController];
}

- (void)showTopBar:(BOOL)showTopBar
{
    if (showingTopBar == showTopBar)
        return;

    showingTopBar = showTopBar;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];

    CGRect navFrm = navController.view.frame;
    navFrm.origin.y -= (showTopBar ? -1 : 1) * TMTopBarHeight;
    navFrm.size.height += (showTopBar ? -1 : 1) * TMTopBarHeight;
    navController.view.frame = navFrm;
    
    [UIView commitAnimations];
}

+ (TMTopLevelViewController *)getTopLevelViewController {
    return _controller;
}

@end
