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
    <UIPickerViewDelegate, UIPickerViewDataSource>
{
    __weak IBOutlet UITextField *titleField;
    __weak IBOutlet UITextField *expectedCompletionTimeField;
    __weak IBOutlet UILabel *creationTimeLabel;
    __weak IBOutlet UIButton *seriesButton;

    UIPickerView *pickerView;
    UIActionSheet *actionSheet;
    NSMutableArray *pickerArray;
}

- (id)initWithTask:(TMTask *)aTask asNewTask:(BOOL)isNew;
- (IBAction)showPicker:(id)sender;

@property (nonatomic, strong) TMTask *task;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
