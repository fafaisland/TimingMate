//
//  TMRecordListPerDayViewController.m
//  TimingMate
//
//  Created by easonfafa on 3/26/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMRecordListPerDayViewController.h"
#import "TMTask.h"
#import "TMRecord.h"
#import "TMTotalTimePerDayRecord.h"
#import "TMRecordListViewController.h"
#import "TMAddRecordViewController.h"

@implementation TMRecordListPerDayViewController

@synthesize task;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
           withTask:(TMTask *)aTask
{
    self = [super initWithStyle:style];
    if (self) {
        task = aTask;
        totalTimePerDayRecordArray = [task computeTotalTimePerDayRecords];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(changeToAddRecordView:)];
        self.navigationItem.rightBarButtonItem = addButton;

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    totalTimePerDayRecordArray = [task computeTotalTimePerDayRecords];
    [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [totalTimePerDayRecordArray count];
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
    
    TMTotalTimePerDayRecord *ttpdr = [totalTimePerDayRecordArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %dseconds",ttpdr.someDay,[ttpdr totalTimeInSeconds]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *someDay = [[totalTimePerDayRecordArray objectAtIndex:indexPath.row] someDay];
    [self showRecordListWithDay:someDay];
}

#pragma mark - Helper Method
- (IBAction)changeToAddRecordView:(id)sender
{
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy"];
    NSString *day = [format stringFromDate:now];
    TMAddRecordViewController *arvc = [[TMAddRecordViewController alloc]
                                       initWithTask:task withDay: day];
    [self.navigationController pushViewController:arvc animated:YES];
}
- (void)showRecordListWithDay:(NSString *)someDay
{
    TMRecordListViewController *rlvc = [[TMRecordListViewController alloc] initWithStyle:UITableViewStylePlain withTask:task withSomeDay:someDay];
    [self.navigationController pushViewController:rlvc animated:YES];
}

- (NSString *)stringFromRecord:(TMRecord *)record
{
    return [NSString stringWithFormat:@"%@:%d", record.beginTime, record.timeSpent];
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

@end
