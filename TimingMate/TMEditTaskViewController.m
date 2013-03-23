//
//  TMEditTaskViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/16/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMEditTaskViewController.h"

#import "TMSeries.h"
#import "TMSeriesStore.h"
#import "TMTask.h"
#import "TMTaskStore.h"

NSString * const TMSeriesNone = @"None";
enum { TMSeriesNoneIndex = 0,
       TMDefaultSeriesEnd = 1 };

@implementation TMEditTaskViewController

@synthesize task, dismissBlock;

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
    expectedCompletionTimeField.text = [NSString stringWithFormat:@"%f", task.expectedCompletionTime];
    creationTimeLabel.text = [dateFormatter stringFromDate:task.creationTime];
    
    TMSeries *series = [task series];
    NSString *selectedStr;
    if (series)
        selectedStr = series.title;
    else
        selectedStr = TMSeriesNone;
    [seriesButton setTitle:selectedStr forState:UIControlStateNormal];
    
    [self initializePickerWithString:selectedStr];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    task.title = titleField.text;
    task.expectedCompletionTime = expectedCompletionTimeField.text.floatValue;
    
    TMSeries *selectedSeries = [self selectedSeries];
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
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPicker:(id)sender
{
    if (!actionSheet)
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [actionSheet addSubview:pickerView];
    
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

- (void)dismissActionSheet:(id)sender
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Picker methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [seriesButton setTitle:[pickerArray objectAtIndex:row]
                                             forState:UIControlStateNormal];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

#pragma mark - Helper methods

- (void)initializePickerWithString:(NSString *)s
{
    if (!pickerView) {
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        
        pickerArray = [NSMutableArray array];
        [pickerArray addObject:TMSeriesNone];
        
        NSArray *allSeries = [[TMSeriesStore sharedStore] allSeries];
        for (TMSeries *series in allSeries) {
            [pickerArray addObject:series.title];
        }
        
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
    }
    
    NSInteger row = 0;
    if (s == TMSeriesNone) {
        row = TMSeriesNoneIndex;
    } else {
        NSInteger idx = [[TMSeriesStore sharedStore] indexOfSeriesByTitle:s];
        if (idx >= 0)
            row = TMDefaultSeriesEnd + idx;
    }

    [pickerView selectRow:row inComponent:0 animated:NO];
}

- (TMSeries *)selectedSeries
{
    if (!pickerView)
        return nil;

    NSInteger row = [pickerView selectedRowInComponent:0];
    if (row < TMDefaultSeriesEnd)
        return nil;

    return [[[TMSeriesStore sharedStore] allSeries] objectAtIndex:row-TMDefaultSeriesEnd];
}

@end
