//
//  TMTimerViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTask;

@interface TMTimerViewController : UIViewController
{
    NSTimer *timer;
    int elapsedTimeInSeconds;
    IBOutlet UILabel *timeField;
    IBOutlet UIBarButtonItem *startButton;
    IBOutlet UIBarButtonItem *stopButton;
    __weak IBOutlet UIToolbar *buttonBar;
}

- (id)initWithTask:(TMTask *)aTask;
- (IBAction)startTimer:(id)sender;
- (IBAction)endTimer:(id)sender;

@property (nonatomic, strong) TMTask *task;

@end
