//
//  TMRecordListViewController.m
//  TimingMate
//
//  Created by easonfafa on 3/22/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMRecordListViewController.h"
#import "TMRecord.h"
#import "TMAddRecordViewController.h"
#import "TMTask.h"

@implementation TMRecordListViewController
@synthesize task;

- (id)initWithStyle:(UITableViewStyle)style
withTask:(TMTask *)aTask withSomeDay:(NSString *)someDay
{
    self = [super initWithStyle:style];
    if (self) {
        task = aTask;
        day = someDay;
        recordsArray = [[NSMutableArray alloc] init];
        [self getRecordsForToday];
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
    [recordsArray removeAllObjects];
    [self getRecordsForToday];
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

#pragma mark - Helper Method
- (NSString *)stringFromRecord:(TMRecord *)record
{
    return [NSString stringWithFormat:@"%@:%d", record.beginTime, record.timeSpent];
}

- (void)getRecordsForToday
{
    NSArray *temp = [task.records allObjects];
    for (TMRecord* r in temp)
    {
        if ([[r getDateDay] isEqualToString:day])
        {
            [recordsArray addObject:r];
        }
    }
}

#pragma mark - button helper
- (IBAction)changeToAddRecordView:(id)sender
{
    TMAddRecordViewController *arvc = [[TMAddRecordViewController alloc]
                                       initWithTask:task];
    [self.navigationController pushViewController:arvc animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordsArray.count;
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
    
    TMRecord *r = [recordsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [self stringFromRecord:r];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
@end
