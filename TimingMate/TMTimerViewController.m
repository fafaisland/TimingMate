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

@implementation TMTimerViewController

@synthesize task;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self toggleButton:stopButton visible:NO];
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

#pragma mark - Timer methods

- (NSTimer*)createTimer
{
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(incrementTimer)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)incrementTimer
{
    elapsedTimeInSeconds += 1;
    [timeField setText:[self stringFromElapsedTime]];
}

- (NSString *)stringFromElapsedTime
{
    int hours = elapsedTimeInSeconds / 3600;
    int secondsLeft = elapsedTimeInSeconds % 3600;
    
    int minutes = secondsLeft / 60;
    int seconds = secondsLeft % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - Button handlers

- (void)editTask:(id)sender
{
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                       initWithTask:task
                                       asNewTask:NO];
    [self.navigationController pushViewController:etvc animated:YES];
}

- (IBAction)startTimer:(id)sender
{
    timer = [self createTimer];
    [self toggleButton:startButton visible:NO];
    [self toggleButton:stopButton visible:YES];
}

- (IBAction)endTimer:(id)sender
{
    [timer invalidate];
    [self toggleButton:startButton visible:YES];
    [self toggleButton:stopButton visible:NO];
}

#pragma mark - Helper methods

- (void)toggleButton:(UIBarButtonItem *)button visible:(BOOL)visible
{
    NSMutableArray *buttons = [buttonBar.items mutableCopy];
    if (visible) {
        [buttons addObject:button];
    } else {
        [buttons removeObject:button];
    }
    buttonBar.items = buttons;
}

@end
