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
    static NSString *CellIdentifier = @"Cell";

    if (indexPath.section != 0) {
        return [super tableView:aTableView
          cellForRowAtIndexPath:[self convertToSuperIndexPath:indexPath]];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Statistics go here";
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return;
    
    return [super tableView:aTableView
        didSelectRowAtIndexPath:[self convertToSuperIndexPath:indexPath]];
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
