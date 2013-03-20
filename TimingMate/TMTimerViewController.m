//
//  TMTimerViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTimerViewController.h"

#import "TMEditTaskViewController.h"
#import "TMTask.h"
#import "TMTimer.h"

@implementation TMTimerViewController

@synthesize task;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        stopButton.hidden = YES;
    }
    return self;
}

- (IBAction)startTimer:(id)sender{
    timer = [self createTimer];
    startButton.hidden = YES;
    stopButton.hidden = NO;
    
}
- (IBAction)endTimer:(id)sender{
    [timer invalidate];
    startButton.hidden = NO;
    stopButton.hidden = YES;

}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerController:) userInfo:nil repeats:YES];
}

- (void)timerController:(id)sender {
    seconds++;
    [timeField setText:[self getTimeStr:seconds]];
}

- (NSString*)getTimeStr : (int) secondsElapsed {
    int hours = secondsElapsed / 3600;
    int secondsLeft = secondsElapsed - hours*3600;
    int seconds = secondsLeft % 60;
    int minutes = secondsLeft / 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes, seconds];
}

- (id)initWithTask:(TMTask *)aTask
{
    self = [super init];
    if (self) {
        task = aTask;
        
        self.navigationItem.title = task.title;
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                        target:self
                                        action:@selector(editTask:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button handlers

- (void)editTask:(id)sender
{
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                       initWithTask:task
                                       asNewTask:NO];
    [self.navigationController pushViewController:etvc animated:YES];
}

@end
