//
//  TMEditTaskViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/16/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMEditTaskViewController.h"

#import "TMGlobals.h"
#import "TMSeries.h"
#import "TMSeriesStore.h"
#import "TMTask.h"
#import "TMTaskListViewController.h"
#import "TMTaskStore.h"

NSString * const TMSeriesNone = @"None";
enum { TMSeriesNoneIndex = 0,
       TMDefaultSeriesEnd = 1 };
enum { TMHourComponent = 0,
       TMMinuteComponent = 1 };

@implementation TMEditTaskViewController

@synthesize task, dismissBlock, cancelBlock, taskListView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTask:(TMTask *)aTask asNewTask:(BOOL)isNew
{
    self = [super init];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                           target:self
                                           action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneButton;
            
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelButton;
            
            forNewTask = isNew;
        }

        task = aTask;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }

    [super viewWillAppear:animated];
    
    titleField.text = task.title;
    
    TMSeries *series = [task series];
    NSString *selectedStr;
    if (series)
        selectedStr = series.title;
    else
        selectedStr = TMSeriesNone;
    [seriesButton setTitle:selectedStr forState:UIControlStateNormal];
    
    [self initializeSeriesPickerWithString:selectedStr];
    [self initializeTimePicker];
    [self updateExpectedTimeButtonLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [titleField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    if (![titleField.text isEqualToString:@""])
        task.title = titleField.text;
    
    TMSeries *selectedSeries = [self selectedSeries];
    if (!forNewTask && task.series != selectedSeries) {
        [taskListView refreshTask:task];
    }

    if (selectedSeries)
        [selectedSeries addTasksObject:task];
    else
        [task.series removeTasksObject:task];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event handlers

- (void)save:(id)sender
{
    if ([titleField.text isEqualToString:@""]) {
        titleField.placeholder = @"Please enter a task name";
        return;
    }
    taskListView.onLoadBlock = dismissBlock;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
    taskListView.onLoadBlock = cancelBlock;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)showSeriesPicker:(id)sender
{
    [self showPicker:seriesPickerView];
}

- (void)showTimePicker:(id)sender
{
    [self showPicker:timePickerView];
}

- (void)dismissActionSheet:(id)sender
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Picker methods

- (void)showPicker:(UIPickerView *)picker
{
    if (!actionSheet)
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [actionSheet addSubview:picker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == seriesPickerView)
        return 1;
    else // pickerView == timePickerView
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == seriesPickerView)
        return pickerArray.count;
    else { // pickerView == timePickerView
        if (component == TMHourComponent)
            return 100;
        else // component == TMMinuteComponent
            return 60;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == seriesPickerView)
        [seriesButton setTitle:[pickerArray objectAtIndex:row]
                                             forState:UIControlStateNormal];
    else { // pickerView == timePickerView
        if (component == TMHourComponent)
            selectedHourRow = row;
        else // component == TMMinuteComponent
            selectedMinuteRow = row;
        [self setTaskExpectedTimeFromPicker];
        [self updateExpectedTimeButtonLabel];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == seriesPickerView)
        return [pickerArray objectAtIndex:row];
    else // pickerView == timePickerView
        return [self timePickerStringFromRow:row forComoonent:component];
}

#pragma mark - Helper methods

- (void)updateExpectedTimeButtonLabel
{
    [expectedTimeButton
        setTitle:TMMakeTimeStringFromHoursMinutes(selectedHourRow, selectedMinuteRow)
                        forState:UIControlStateNormal];
}

- (void)setTaskExpectedTimeFromPicker
{
    task.expectedCompletionTime = (double)(selectedHourRow * 60 + selectedMinuteRow);
}

- (NSString *)timePickerStringFromRow:(NSInteger)row forComoonent:(NSInteger)component
{
    if (component == TMHourComponent)
        return [NSString stringWithFormat:@"%d hr", row];
    else // component == TMMinuteComponent
        return [NSString stringWithFormat:@"%d min", row];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)initializeSeriesPickerWithString:(NSString *)s
{
    if (!seriesPickerView) {
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        seriesPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        
        pickerArray = [NSMutableArray array];
        [pickerArray addObject:TMSeriesNone];
        
        NSArray *allSeries = [[TMSeriesStore sharedStore] allSeries];
        for (TMSeries *series in allSeries) {
            [pickerArray addObject:series.title];
        }
        
        seriesPickerView.showsSelectionIndicator = YES;
        seriesPickerView.dataSource = self;
        seriesPickerView.delegate = self;
    }
    
    NSInteger row = 0;
    if (s == TMSeriesNone) {
        row = TMSeriesNoneIndex;
    } else {
        NSInteger idx = [[TMSeriesStore sharedStore] indexOfSeriesByTitle:s];
        if (idx >= 0)
            row = TMDefaultSeriesEnd + idx;
    }

    [seriesPickerView selectRow:row inComponent:0 animated:NO];
}

- (void)initializeTimePicker
{
    if (!timePickerView) {
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        timePickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        
        timePickerView.showsSelectionIndicator = YES;
        timePickerView.dataSource = self;
        timePickerView.delegate = self;
    }
    
    selectedMinuteRow = task.expectedTimeMinutes;
    selectedHourRow = task.expectedTimeHours;
    [timePickerView selectRow:selectedMinuteRow inComponent:TMMinuteComponent animated:NO];
    [timePickerView selectRow:selectedHourRow inComponent:TMHourComponent animated:NO];
}

- (TMSeries *)selectedSeries
{
    if (!seriesPickerView)
        return nil;

    NSInteger row = [seriesPickerView selectedRowInComponent:0];
    if (row < TMDefaultSeriesEnd)
        return nil;

    return [[[TMSeriesStore sharedStore] allSeries] objectAtIndex:row-TMDefaultSeriesEnd];
}

@end
