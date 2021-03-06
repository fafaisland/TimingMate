//
//  TMAddRecordViewController.h
//  TimingMate
//
//  Created by easonfafa on 3/24/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTask;

@interface TMAddRecordViewController : UIViewController <UITextFieldDelegate>
{
    NSDate *beginTime;
    int32_t duration;
    __weak IBOutlet UITextField *durationField;
    __weak IBOutlet UIButton *datePickerButton;
    UIActionSheet *actionSheet;
    UIDatePicker *pickerView1;
    NSString *initDate;
    NSDate *appearDate;
}

@property (nonatomic, strong) TMTask *task;

- (id)initWithTask:(TMTask *)aTask withDay:(NSString *)date;
- (IBAction)datePickerValueChanged:(id)sender;

@end
