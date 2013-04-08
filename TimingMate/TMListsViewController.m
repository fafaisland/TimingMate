//
//  TMListsViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/18/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMListsViewController.h"

#import "TMEngagingViewController.h"
#import "TMGlobals.h"
#import "TMListsViewEditableCell.h"
#import "TMSeries.h"
#import "TMSeriesStore.h"
#import "TMSeriesViewController.h"
#import "TMTaskListViewController.h"
#import "TMTaskStore.h"

NSString * const TMAllListName = @"All";
NSString * const TMEngagingListName = @"Engaging";

NSString * const TMListsViewEditableCellIdentifier = @"EditableCell";

enum { TMAllListIndex = 0,
       TMEngagingListIndex = 1,
       TMSeriesListsIndex = 2,
       TMDefaultListEnd = 3 };

@implementation TMListsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = TMListsTitle;

        editButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"Edit"
                      style:UIBarButtonItemStylePlain
                      target:self
                      action:@selector(toggleEdit)];
        editDoneButton = [[UIBarButtonItem alloc]
                        initWithTitle:@"Done"
                        style:UIBarButtonItemStyleDone
                        target:self
                        action:@selector(toggleEdit)];
        
        self.tableView.allowsSelectionDuringEditing = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TMListsViewEditableCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:TMListsViewEditableCellIdentifier];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = editButton;
    self.editing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TMDefaultListEnd + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TMAllListIndex || section == TMEngagingListIndex ||
        section >= TMDefaultListEnd)
        return 1;
    return [[TMSeriesStore sharedStore] allSeries].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if ([indexPath compare:editingIndexPath] == NSOrderedSame) {
        TMListsViewEditableCell *editableCell = [tableView
                    dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        [self setupEditableCell:editableCell
                       withText:[self listNameFromIndexPath:indexPath]];
        [editField performSelector:@selector(becomeFirstResponder)
                        withObject:nil
                        afterDelay:0.1f];
        return editableCell;
    }
    
    if (indexPath.section < TMDefaultListEnd) {
        UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = [self listNameFromIndexPath:indexPath];
        
        return cell;
    } else {
        TMListsViewEditableCell *editableCell = [tableView
                    dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        addField = editableCell.titleField;
        addField.text = @"";
        [addField setPlaceholder:@"Add a new series"];
        addField.delegate = self;
        editableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return editableCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == TMSeriesListsIndex)
        return 25.0;
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == TMSeriesListsIndex)
        return @"Series";
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TMSeriesListsIndex)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self endCellEdit];

        TMSeries *series = [[[TMSeriesStore sharedStore] allSeries]
                            objectAtIndex:indexPath.row];
        if (series.tasks.count > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                         message:@"This will delete all associated tasks"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
            indexOfSeriesToBeDeleted = indexPath;
            [alert show];
        } else {
            [self deleteSeriesAtIndexPath:indexPath];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    if (self.isEditing) {
        if (indexPath.section < TMSeriesListsIndex || indexPath.section == TMDefaultListEnd)
            return;

        [self endCellEdit];

        editingIndexPath = indexPath;
        [self.tableView reloadData];
    } else {
        if (indexPath.section >= TMDefaultListEnd)
            return;

        [self pushListNamed:[self listNameFromIndexPath:indexPath] animated:YES];
    }
}

#pragma mark - Button handlers

- (void)toggleEdit
{
    if (self.isEditing) {
        [self endCellEdit];
        [self setEditing:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    } else {
        [self setEditing:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:editDoneButton animated:YES];
    }
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == addField &&
        [[TMSeriesStore sharedStore] seriesByTitle:addField.text] != nil) {
        [self showIdenticalTitleWarning];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == addField) {        
        [self addSeries:addField.text];
        [self.tableView reloadData];
    } else if (textField == editField) {
        if (self.isEditing)
            [self endCellEdit];
    }
}

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteSeriesAtIndexPath:indexOfSeriesToBeDeleted];
        indexOfSeriesToBeDeleted = nil;
    }
}

#pragma mark - Helper methods

- (void)addSeries:(NSString *)title
{
    if (![title isEqualToString:@""])
        [[TMSeriesStore sharedStore] createAndAddSeriesWithTitle:title];
}

- (NSString *)listNameFromIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TMAllListIndex) {
        return TMAllListName;
    } else if (indexPath.section == TMEngagingListIndex) {
        return TMEngagingListName;
    } else {
        TMSeries *series = [[[TMSeriesStore sharedStore] allSeries]
                            objectAtIndex:(indexPath.row)];
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
    if ([name isEqualToString:TMAllListName]) {
        TMTaskListViewController *taskListController = [[TMTaskListViewController alloc]
                                                initWithTitle:name];
        [self.navigationController pushViewController:taskListController animated:animated];
    } else if ([name isEqualToString:TMEngagingListName]) {
        TMEngagingViewController *evc = [[TMEngagingViewController alloc]
                                         initWithTitle:name];
        [self.navigationController pushViewController:evc animated:animated];
    } else {
        TMSeriesViewController *svc = [[TMSeriesViewController alloc]
                                                initWithTitle:name];
        [self.navigationController pushViewController:svc animated:animated];
    }
}

- (void)deleteSeriesAtIndexPath:(NSIndexPath *)indexPath
{
    TMSeries *series = [[[TMSeriesStore sharedStore] allSeries]
                        objectAtIndex:indexPath.row];
    for (TMTask *task in series.tasks) {
        [[TMTaskStore sharedStore] removeTask:task];
    }
    [[TMSeriesStore sharedStore] removeSeries:series];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    if ([[TMSeriesStore sharedStore] allSeries].count == 0) {
        [self toggleEdit];
    }
}

- (void)setupEditableCell:(TMListsViewEditableCell *)cell withText:(NSString *)text
{
    editField = cell.titleField;
    
    editField.text = text;
    [editField setPlaceholder:@""];
    editField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)endCellEdit
{
    if (editingIndexPath == nil)
        return;
    
    NSString *newTitle = editField.text;

    NSUInteger seriesIdx = editingIndexPath.row;
    TMSeries *series = [[[TMSeriesStore sharedStore] allSeries] objectAtIndex:seriesIdx];
    
    if (newTitle.length != 0 &&
        [[TMSeriesStore sharedStore] seriesByTitle:editField.text] == nil)
        series.title = newTitle;
    editingIndexPath = nil;
    [self.tableView reloadData];
}

- (void)showIdenticalTitleWarning
{
    addField.text = @"";
    addField.placeholder = @"Place enter a unique title";
}

@end
