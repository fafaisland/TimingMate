//
//  TMTimerViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTask;
@class TMRecord;

@interface TMTimerViewController : UIViewController
{
    //timer
    NSTimer *timer;
    int elapsedTimeInSeconds;
    int elapsedTimePerRecord;
    NSDate *recordBeginTime;
    BOOL isTiming;
    IBOutlet UILabel *timeField;
    IBOutlet UIBarButtonItem *startButton;
    IBOutlet UIBarButtonItem *stopButton;
    
    UIBarButtonItem *currentEngagementButton;
    IBOutlet UIBarButtonItem *engageButton;
    IBOutlet UIBarButtonItem *disengageButton;
    __weak IBOutlet UIButton *finishButton;
    UIBarButtonItem *editButton;
    __weak IBOutlet UIButton *recordListButton;
    
    __weak IBOutlet UIToolbar *buttonBar;
    //records
    NSSet *records;
}

- (id)initWithTask:(TMTask *)aTask;
- (IBAction)startTimer:(id)sender;
- (IBAction)endTimer:(id)sender;
- (IBAction)toggleEngagement:(id)sender;
- (IBAction)toggleFinished:(id)sender;
- (IBAction)changeToRecordListView:(id)sender;
- (void)createRecord;


@property (nonatomic, strong) TMTask *task;
@property (nonatomic, strong) TMRecord *record;

@end
