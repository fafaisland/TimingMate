//
//  TMTopLevelViewController.h
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTopBarViewController;

@interface TMTopLevelViewController : UIViewController
{
    UINavigationController *navController;
    TMTopBarViewController *topBarController;
    BOOL showingTopBar;
}

+ (TMTopLevelViewController *)getTopLevelViewController;
- (void)addNavigationController:(UINavigationController *)navigationController;
- (void)showTopBar:(BOOL)showTopBar;

@end

extern TMTopLevelViewController *_controller;
