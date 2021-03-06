//
//  TMTopLevelViewController.h
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTopBarViewController, TMTask;

@interface TMTopLevelViewController : UIViewController
{
    UINavigationController *navController;
    TMTopBarViewController *topBarController;
    BOOL showingTopBar;
}

+ (TMTopLevelViewController *)getTopLevelViewController;
- (void)addNavigationController:(UINavigationController *)navigationController;
- (void)showTopBar:(BOOL)showTopBar animated:(BOOL)animated;
- (void)showTimerViewForTask:(TMTask *)task;
- (void)restartTimerForTask:(TMTask *)task;

@end

extern TMTopLevelViewController *_controller;
