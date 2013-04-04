//
//  TMSeriesViewController.m
//  TimingMate
//
//  Created by Long Wei on 4/2/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMSeriesViewController.h"

#import "TMGlobals.h"
#import "TMSeries.h"
#import "TMSeriesStatisticsCell.h"
#import "TMSeriesStore.h"
#import "TMTask.h"
#import "TMTaskStore.h"

NSString * const TMSeriesStatisticsCellIdentifier = @"StatisticsCell";

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
    self = [super init];
    if (self) {
        self.navigationItem.title = title;
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
    
    UINib *nib = [UINib nibWithNibName:@"TMSeriesStatisticsCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:TMSeriesStatisticsCellIdentifier];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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

- (BOOL)viewIncludesTask:(TMTask *)task
{
    return task.series == series;
}

#pragma - mark Table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1 + [super numberOfSectionsInTableView:aTableView];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0)
        return [super tableView:aTableView numberOfRowsInSection:section-1];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return [super tableView:aTableView
          cellForRowAtIndexPath:[self convertToSuperIndexPath:indexPath]];
    }
    
    TMSeriesStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:TMSeriesStatisticsCellIdentifier];
    
    cell.totalLabel.text = TMMakeTimeStringFromSeconds([series getTotalTimeSpent]);
    cell.averageLabel.text = TMMakeTimeStringFromSeconds(
                                    [series getAverageTimeSpentPerTask]);

    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return;
    
    return [super tableView:aTableView
        didSelectRowAtIndexPath:[self convertToSuperIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return NO;
    return YES;
}

- (BOOL)swipeIsEnabledForSection:(NSInteger)section
{
    if (section == 0)
        return NO;
    return YES;
}

#pragma mark - Helper methods

- (NSIndexPath *)convertToSuperIndexPath:(NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
}

@end
