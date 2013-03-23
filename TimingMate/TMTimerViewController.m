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
#import "TMRecord.h"
#import "TMRecordListViewController.h"

@implementation TMTimerViewController

@synthesize task;
@synthesize record;

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
        isTiming = false;
        self.navigationItem.title = task.title;
        elapsedTimeInSeconds = 0;
        elapsedTimePerRecord = 0;
        editButton = [[UIBarButtonItem alloc]
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

    [self toggleStartButtonVisible:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endTimer:nil];
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
    elapsedTimePerRecord += 1;
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

#pragma mark - Record methods
- (void)createRecord
{
    record = [task createRecordBeginningAt:recordBeginTime
                                withTimeSpent:elapsedTimePerRecord];
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
    recordBeginTime = [[NSDate alloc] init];
    NSLog(@"Begin Time %@",recordBeginTime);
    elapsedTimePerRecord = 0;
    isTiming = true;
    timer = [self createTimer];
    [self toggleStartButtonVisible:NO];
}

- (IBAction)endTimer:(id)sender
{
    if (isTiming == true)
    {
        isTiming = false;
        [timer invalidate];
        [self createRecord];
        NSLog(@"record info %@ %d",record.beginTime, record.timeSpent);
        [self toggleStartButtonVisible:YES];
    }
    
}

- (IBAction)changeToRecordListView:(id)sender
{
    records = task.records;
    TMRecordListViewController *rlvc = [[TMRecordListViewController alloc]
                                        initWithStyle:UITableViewStylePlain
                                        withRecords:records];
    [self.navigationController pushViewController:rlvc animated:YES];
}

#pragma mark - Helper methods

- (void)toggleStartButtonVisible:(BOOL)startIsVisible
{
    NSMutableArray *buttons = [NSMutableArray array];
    [buttons addObject:[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                        target:nil
                        action:nil]];
    [buttons addObject:(startIsVisible ? startButton : stopButton)];
    [self.navigationItem setHidesBackButton:!startIsVisible animated:YES];
    [self.navigationItem setRightBarButtonItem:(startIsVisible ? editButton : nil) animated:YES];

    [buttons addObject:[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                        target:nil
                        action:nil]];
    [buttonBar setItems:buttons animated:YES];
}

@end
