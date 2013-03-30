//
//  TMAddRecordViewController.m
//  TimingMate
//
//  Created by easonfafa on 3/24/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMAddRecordViewController.h"
#import "TMTask.h"
#import "TMRecord.h"

@interface TMAddRecordViewController ()

@end

@implementation TMAddRecordViewController
@synthesize task;

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
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:
                                        UIBarButtonSystemItemDone
                                        target:self
                                        action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        task = aTask;
    }
    return self;
}

#pragma button helper
- (IBAction) datePickerValueChanged:(id)sender
{
    // following code reference: http://stackoverflow.com/questions/8930052/iphone-datepicker-with-actionsheet
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    //CGRect pickerFrame = CGRectMake(0, 45, 0, 0);
    pickerView1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 450)];
    pickerView1.datePickerMode = UIDatePickerModeDate;
    [actionSheet addSubview:pickerView1];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    [pickerView1 addTarget:self
                    action:@selector(updateLabel:)
          forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)] ;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
}

- (void)dismissActionSheet:(id)sender
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)updateLabel:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [datePickerButton setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:pickerView1.date]]forState:UIControlStateNormal];
}
- (void)save:(id)sender
{
    NSString *stringBeginTime = nil;
    NSString *stringDuration = durationField.text;
    if ([stringBeginTime length] != 0 && [stringDuration length] != 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MMMM-dd"];
        beginTime = [dateFormat dateFromString:stringBeginTime];
        duration = (int32_t)stringDuration;
        [task createRecordBeginningAt:beginTime
                    withTimeSpent:duration];
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma default
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

@end
