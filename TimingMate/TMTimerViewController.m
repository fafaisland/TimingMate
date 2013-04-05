//
//  TMTimerViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTimerViewController.h"

#import "TMAddRecordViewController.h"
#import "TMEditTaskViewController.h"
#import "TMGlobals.h"
#import "TMRecord.h"
#import "TMRecordListPerDayViewController.h"
#import "TMRecordListViewController.h"
#import "TMSeries.h"
#import "TMTask.h"
#import "TMTaskListViewController.h"
#import "TMTimer.h"
#import "TMTopLevelViewController.h"

@implementation TMTimerViewController

@synthesize task, taskListView;

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
        elapsedTimeInSeconds = 0;
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
    
    [[TMTimer timer] addListener:self];
    
    self.navigationItem.title = task.title;
    currentEngagementButton = task.isEngaging ? disengageButton : engageButton;
    [seriesLabel setText:task.series.title];
    [seriesLabel setTextColor:[UIColor colorWithRed:30.0f/255.0f green:144.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    UIFont *seriesFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:40];
    [seriesLabel setFont:seriesFont];
    CGPoint center = seriesLabel.center;
    [seriesLabel sizeToFit];
    seriesLabel.center = center;
    [self toggleStart:YES animated:NO];
    [self showButtonsForFinished:task.isFinished animated:NO];
    [self showHoursPerDay];
    [self showTotalTime];
    [self showExpectedTime];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[TMTimer timer] removeListener:self];
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

- (void)createTimer
{
    [[TMTimer timer] startTimerWithTimeInterval:1.0];
}

- (void)receiveEventFromTimer:(TMTimer *)timer
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
        return [NSString stringWithFormat:@"%02d hr %02d min", hours, minutes];
    }
    else{
        return [NSString stringWithFormat:@"%02d min %02d sec",minutes,seconds];
    }
}

#pragma mark - Record methods

- (IBAction)changeToRecordListPerDayView:(id)sender
{
    TMRecordListPerDayViewController *rlvc = [[TMRecordListPerDayViewController alloc]
                                        initWithStyle:UITableViewStylePlain
                                        withTask:task];
    [self.navigationController pushViewController:rlvc animated:YES];
}

#pragma mark - present labels

- (void)showTotalTime
{
    int secondsTotal = [self countTotalSecondsSpentOnTask];
    [totalTimeLabel setText:[self getStringFromSecondsPerDay:secondsTotal ]];
}

- (void)showExpectedTime
{
    [expectedTimeLabel setText:TMMakeTimeStringFromHoursMinutes(task.expectedTimeHours,
                                                task.expectedTimeMinutes)];
}

#pragma mark - Button handlers
- (void)editTask:(id)sender
{
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                       initWithTask:task
                                       asNewTask:NO];
    [etvc setTaskListView:taskListView];
    [self.navigationController pushViewController:etvc animated:YES];
}

- (IBAction)startTimer:(id)sender
{
    [[TMTopLevelViewController getTopLevelViewController] showTopBar:YES];
    isTiming = true;
    
    [task beginNewRecord];

    [self createTimer];

    [self toggleStart:NO animated:YES];
}

- (IBAction)endTimer:(id)sender
{
    [[TMTopLevelViewController getTopLevelViewController] showTopBar:NO];
    if (isTiming == true)
    {
        isTiming = false;
        
        [[TMTimer timer] stopTimer];
        
        [task endNewRecord];
        [self showHoursPerDay];
        [self showTotalTime];
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
    [taskListView refreshTask:task];
}

- (IBAction)toggleFinished:(id)sender
{
    task.isFinished = !task.isFinished;
    [self showButtonsForFinished:task.isFinished animated:YES];
    [self endTimer:nil];
    [taskListView refreshTask:task];
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

@end
