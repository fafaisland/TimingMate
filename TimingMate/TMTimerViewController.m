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
#import "TMSeries.h"
#import "TMRecordListViewController.h"
#import "TMTaskListViewController.h"
#import "TMAddRecordViewController.h"
#import "TMRecordListPerDayViewController.h"

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
    currentEngagementButton = task.isEngaging ? disengageButton : engageButton;
    [seriesLabel setText:task.series.title];
    [self toggleStart:YES animated:NO];
    [self showButtonsForFinished:task.isFinished animated:NO];
    [self showHoursPerDay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
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

#pragma mark - Representation methods
- (void)showHoursPerDay
{
    NSDate *taskCreationTime = task.creationTime;
    NSDate *now = [NSDate date];
    int daysFromCreationToNow = [self countDaysBetween:taskCreationTime and:now];
    NSLog(@"%d",daysFromCreationToNow);
    int totalSecondsSpentOnTask = [self countTotalSecondsSpentOnTask];
    int secondsPerDay = 0;
    if (0 != totalSecondsSpentOnTask)
    {
        secondsPerDay = totalSecondsSpentOnTask / daysFromCreationToNow;
    }
    [hoursPerDayField setText:[self getStringFromSecondsPerDay:(int)secondsPerDay]];
    
}

- (int)countDaysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

- (int32_t)countTotalSecondsSpentOnTask
{
    int32_t secondsTotal = 0;
    for (TMRecord *r in task.records)
    {
        secondsTotal += r.timeSpent;
    }
    return secondsTotal;
}

- (NSString *)getStringFromSecondsPerDay:(int)secondsPerDay
{
    int hours = secondsPerDay / 3600;
    int secondsLeft = secondsPerDay % 3600;
    int minutes = secondsLeft / 60;
    int seconds = secondsLeft % 60;
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02d hours %02d mins Per Day", hours, minutes];
    }
    else{
        return [NSString stringWithFormat:@"%02d mins %02d seconds Per Day",minutes,seconds];
    }
}

#pragma mark - Record methods

- (void)createRecord
{
    record = [task createRecordBeginningAt:recordBeginTime
                                withTimeSpent:elapsedTimePerRecord];
}

- (IBAction)changeToRecordListPerDayView:(id)sender
{
    records = task.records;
    TMRecordListPerDayViewController *rlvc = [[TMRecordListPerDayViewController alloc]
                                        initWithStyle:UITableViewStylePlain
                                        withTask:task];
    [self.navigationController pushViewController:rlvc animated:YES];
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
    [self toggleStart:NO animated:YES];
}

- (IBAction)endTimer:(id)sender
{
    if (isTiming == true)
    {
        isTiming = false;
        [timer invalidate];
        [self createRecord];
        NSLog(@"record info %@ %d",record.beginTime, record.timeSpent);
        [self toggleStart:YES animated:YES];
    }
}

- (IBAction)toggleEngagement:(id)sender
{
    if (task.isEngaging) {
        task.isEngaging = NO;
        currentEngagementButton = engageButton;
    } else {
        task.isEngaging = YES;
        currentEngagementButton = disengageButton;
    }
    [self toggleStart:!isTiming animated:YES];
}

- (IBAction)toggleFinished:(id)sender
{
    task.isFinished = !task.isFinished;
    [self showButtonsForFinished:task.isFinished animated:YES];
    [self endTimer:nil];
    [[self getPreviousViewController] setNeedsReload];
}

#pragma mark - Helper methods

- (void)toggleStart:(BOOL)start animated:(BOOL)animated
{
    NSMutableArray *buttons = [NSMutableArray array];
    [buttons addObject:currentEngagementButton];
    
    if (!task.isFinished) {
        [buttons addObject:[[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                            target:nil
                            action:nil]];
        [buttons addObject:(start ? startButton : stopButton)];
        [buttons addObject:[[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                            target:nil
                            action:nil]];
        [self.navigationItem setRightBarButtonItem:(start ? editButton : nil) animated:YES];
    }
    
    [self.navigationItem setHidesBackButton:!start animated:animated];
    [buttonBar setItems:buttons animated:animated];
}

- (void)showButtonsForFinished:(BOOL)finished animated:(BOOL)animated
{
    if (finished) {
        [finishButton setTitle:@"Mark as Unfinished" forState:UIControlStateNormal];
    } else {
        [finishButton setTitle:@"Mark as Finished" forState:UIControlStateNormal];
    }
    [finishButton sizeToFit];
    [self.navigationItem setRightBarButtonItem:(task.isFinished ? nil : editButton)
                                      animated:animated];
    [self toggleStart:!isTiming animated:animated];
}

- (TMTaskListViewController *)getPreviousViewController
{
    int idx = [self.navigationController.viewControllers indexOfObject:self];
    return [self.navigationController.viewControllers objectAtIndex:idx-1];
}

@end
