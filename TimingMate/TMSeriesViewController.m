//
//  TMSeriesViewController.m
//  TimingMate
//
//  Created by Long Wei on 4/2/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMSeriesViewController.h"

#import "TMSeries.h"
#import "TMSeriesStore.h"
#import "TMTask.h"
#import "TMTaskStore.h"

@interface TMSeriesViewController ()

@end

@implementation TMSeriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self) {
        series = [[TMSeriesStore sharedStore] seriesByTitle:title];
        self.listGenerationBlock = ^(NSMutableArray * list){
            [list removeAllObjects];
            for (TMTask *task in [[TMSeriesStore sharedStore] seriesByTitle:title].tasks) {
                [list addObject:task];
            };
        };
        
        tasks = [NSMutableArray array];
        self.listGenerationBlock(tasks);
    }
    return self;
}

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

- (void)addNewTask:(id)sender
{
    TMTask *t = [[TMTaskStore sharedStore] createAndAddTask];
    [series addTasksObject:t];
    
    [self presentViewForAddingTask:t];
}

@end
