//
//  TMEditTaskViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/16/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMEditTaskViewController.h"

#import "TMTask.h"
#import "TMTaskStore.h"

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    task.title = titleField.text;
    task.expectedCompletionTime = expectedCompletionTimeField.text.floatValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button handlers

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
