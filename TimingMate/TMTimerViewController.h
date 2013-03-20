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
    int seconds;
    IBOutlet UILabel *timeField;
    __weak IBOutlet UIButton *stopButton;
    __weak IBOutlet UIButton *startButton;
    
}

- (id)initWithTask:(TMTask *)aTask;
- (IBAction)startTimer:(id)sender;
- (IBAction)endTimer:(id)sender;

@property (nonatomic, strong) TMTask *task;

@end
