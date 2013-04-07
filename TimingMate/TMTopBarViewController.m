//
//  TMTopBarViewController.m
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTopBarViewController.h"

#import "TMGlobals.h"
#import "TMTask.h"
#import "TMTaskStore.h"
#import "TMTopLevelViewController.h"

@interface TMTopBarViewController ()

@end

@implementation TMTopBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveEventFromTimer:(TMTimer *)timer
{
    TMTask *currentTask = [TMTaskStore sharedStore].currentTimingTask;
    [label setText:[NSString stringWithFormat:@"%@ %@", currentTask.title,
     TMTimerStringFromSeconds(currentTask.elapsedTimeOnRecord)]];
}

- (void)receiveInterruptFromTimer:(TMTimer *)timer
{
    [[TMTopLevelViewController getTopLevelViewController] showTopBar:NO];
}

- (void)tap:(id)sender
{
    [[TMTopLevelViewController getTopLevelViewController]
        showTimerViewForTask:[TMTaskStore sharedStore].currentTimingTask];
}

@end
