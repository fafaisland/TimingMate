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
    NSTimer *timer;
    int elapsedTimeInSeconds;
    NSDate *recordBeginTime;
    NSDate *recordEndTime;
    IBOutlet UILabel *timeField;
    IBOutlet UIBarButtonItem *startButton;
    IBOutlet UIBarButtonItem *stopButton;
    __weak IBOutlet UIToolbar *buttonBar;
    __weak IBOutlet UIButton *showButton;
    
    NSString *TMRecordEntityName;
    IBOutlet UILabel *recordDetail;
}

- (id)initWithTask:(TMTask *)aTask;
- (IBAction)startTimer:(id)sender;
- (IBAction)endTimer:(id)sender;
- (IBAction)changeToRecordListView:(id)sender;
- (IBAction)showRecord:(id)sender;
- (void)createRecord;

@property (nonatomic, strong) TMTask *task;
@property (nonatomic, strong) TMRecord *record;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
