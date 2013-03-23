//
//  TMListsViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/18/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMListsViewController.h"

#import "TMGlobals.h"
#import "TMSeries.h"
#import "TMSeriesStore.h"
#import "TMTaskListViewController.h"
#import "TMTaskStore.h"

NSString * const TMAllListName = @"All";
NSString * const TMEngagingListName = @"Engaging";

enum { TMAllListIndex = 0,
       TMEngagingListIndex = 1,
       TMDefaultListEnd = 2 };

@implementation TMListsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = TMAppName;
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self action:@selector(addNewSeries:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger seriesCount = [[TMSeriesStore sharedStore] allSeries].count;
    return TMDefaultListEnd + seriesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [self listNameFromRow:indexPath.row];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushListNamed:[self listNameFromRow:indexPath.row] animated:YES];
}

#pragma mark - Button handlers

- (void)addNewSeries:(id)sender
{
    [[TMSeriesStore sharedStore] createAndAddSeries];
    
    NSIndexPath *indexPath = [NSIndexPath
                    indexPathForRow:[[TMSeriesStore sharedStore]
                                     allSeries].count-1+TMDefaultListEnd
                    inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

#pragma mark - Helper methods

- (NSString *)listNameFromRow:(NSInteger)row
{
    if (row == TMAllListIndex) {
        return TMAllListName;
    } else if (row == TMEngagingListIndex) {
        return TMEngagingListName;
    } else {
        TMSeries *series = [[[TMSeriesStore sharedStore] allSeries]
                            objectAtIndex:(row - TMDefaultListEnd)];
        return series.title;
    }
    return nil;
}

- (void)pushDefaultList
{
    [self pushListNamed:TMAllListName animated:NO];
}

- (void)pushListNamed:(NSString *)name animated:(BOOL)animated
{
    TMTaskListViewController *taskListController = [[TMTaskListViewController alloc]
                                                    initWithTitle:name];
    [self.navigationController pushViewController:taskListController animated:animated];
}

@end
