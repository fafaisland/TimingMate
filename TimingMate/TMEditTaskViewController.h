//
//  TMEditTaskViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/16/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTask;

@interface TMEditTaskViewController : UIViewController
{
    __weak IBOutlet UITextField *titleField;
    __weak IBOutlet UITextField *expectedCompletionTimeField;
    __weak IBOutlet UILabel *creationTimeLabel;
}

- (id)initWithTask:(TMTask *)aTask asNewTask:(BOOL)isNew;

@property (nonatomic, strong) TMTask *task;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
