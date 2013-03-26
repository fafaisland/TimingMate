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
- (void)save:(id)sender
{
    NSString *stringBeginTime = beginTimeField.text;
    NSString *stringDuration = durationField.text;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MMMM-dd"];
    beginTime = [dateFormat dateFromString:stringBeginTime];
    duration = (int32_t)stringDuration;
    [task createRecordBeginningAt:beginTime
                    withTimeSpent:duration];
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
