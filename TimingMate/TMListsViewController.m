//
//  TMListsViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/18/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMListsViewController.h"

#import "TMGlobals.h"
#import "TMListsViewEditableCell.h"
#import "TMSeries.h"
#import "TMSeriesStore.h"
#import "TMTaskListViewController.h"
#import "TMTaskStore.h"

NSString * const TMAllListName = @"All";
NSString * const TMEngagingListName = @"Engaging";

NSString * const TMListsViewEditableCellIdentifier = @"EditableCell";

enum { TMAllListIndex = 0,
       TMEngagingListIndex = 1,
       TMDefaultListEnd = 2 };

@implementation TMListsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = TMListsTitle;
        
        addButton = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                              target:self action:@selector(toggleAdd)];
        addDoneButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"Done"
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(toggleAdd)];
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
    
    isAdding = NO;
    [self switchButtonToAdd:YES];
    
    self.navigationItem.leftBarButtonItem = editButton;
    self.editing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self usualRowCount] + (isAdding ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if ([indexPath compare:editingIndexPath] == NSOrderedSame) {
        TMListsViewEditableCell *editableCell = [tableView
                    dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        [self setupEditableCell:editableCell withText:[self listNameFromRow:indexPath.row]];
        return editableCell;
    }
    
    if (indexPath.row < [self usualRowCount]) {
        UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = [self listNameFromRow:indexPath.row];
        
        return cell;
    } else {
        TMListsViewEditableCell *editableCell = [tableView
                    dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        [self setupEditableCell:editableCell withText:@""];
        return editableCell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < TMDefaultListEnd)
        return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self endCellEdit];

        TMSeries *series = [[[TMSeriesStore sharedStore] allSeries] objectAtIndex:indexPath.row-TMDefaultListEnd];
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
        if (indexPath.row < TMDefaultListEnd)
            return;

        [self endCellEdit];

        editingIndexPath = indexPath;
        [self.tableView reloadData];
    } else {
        if (indexPath.row >= [self usualRowCount])
            return;

        [self pushListNamed:[self listNameFromRow:indexPath.row] animated:YES];
    }
}

#pragma mark - Button handlers

- (void)toggleAdd
{
    if (isAdding) {
        if (editField.text.length != 0) {
            if ([[TMSeriesStore sharedStore] seriesByTitle:editField.text] == nil) {
                [self addSeries:editField.text];
            } else {
                [self showIdenticalTitleWarning];
                return;
            }
        }
    } else {
        if (self.isEditing)
            [self toggleEdit];
    }

    isAdding = !isAdding;
    [self switchButtonToAdd:!isAdding];
    [self.tableView reloadData];
}

- (void)toggleEdit
{
    if (self.isEditing) {
        [self endCellEdit];
        [self setEditing:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    } else {
        if (isAdding)
            [self toggleAdd];
        [self setEditing:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:editDoneButton animated:YES];
    }
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[TMSeriesStore sharedStore] seriesByTitle:editField.text] != nil) {
        [self textFieldDidEndEditing:textField];
        return NO;
    }

    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isAdding)
        [self toggleAdd];
    else if (self.isEditing) {
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
    [[TMSeriesStore sharedStore] createAndAddSeriesWithTitle:title];
}

- (void)switchButtonToAdd:(BOOL)showingAdd
{
    [self.navigationItem setRightBarButtonItem:(showingAdd ? addButton : addDoneButton)
                                      animated:YES];
}

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

- (void (^)(NSMutableArray*))listGenerationBlockFromName:(NSString *)name
{
    if (name == TMAllListName)
        return ^(NSMutableArray * list){
                   [list removeAllObjects];
                   [list addObjectsFromArray:[[TMTaskStore sharedStore] allTasks]];
               };
    else if (name == TMEngagingListName) {
        return ^(NSMutableArray * list){
            [list removeAllObjects];
            [list addObjectsFromArray:[[TMTaskStore sharedStore] allEngagingTasks]];
        };
    } else {
        return ^(NSMutableArray * list){
            [list removeAllObjects];
            NSSet *tasks = [[TMSeriesStore sharedStore] seriesByTitle:name].tasks;
            for (TMTask *task in tasks) {
                [list addObject:task];
            }
        };
    }
}

- (void)pushListNamed:(NSString *)name animated:(BOOL)animated
{
    TMTaskListViewController *taskListController = [[TMTaskListViewController alloc]
                                                    initWithTitle:name
                                                    listGenerationBlock:
                                                    [self listGenerationBlockFromName:name]];
    [self.navigationController pushViewController:taskListController animated:animated];
}

- (NSUInteger)usualRowCount
{
    NSUInteger seriesCount = [[TMSeriesStore sharedStore] allSeries].count;
    return TMDefaultListEnd + seriesCount;
}

- (void)deleteSeriesAtIndexPath:(NSIndexPath *)indexPath
{
    TMSeries *series = [[[TMSeriesStore sharedStore] allSeries]
                        objectAtIndex:indexPath.row-TMDefaultListEnd];
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
    [editField setPlaceholder:@"Series name"];
    [editField performSelector:@selector(becomeFirstResponder)
                    withObject:nil
                    afterDelay:0.1f];
    editField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)endCellEdit
{
    if (editingIndexPath == nil)
        return;
    
    NSString *newTitle = editField.text;

    NSUInteger seriesIdx = editingIndexPath.row - TMDefaultListEnd;
    TMSeries *series = [[[TMSeriesStore sharedStore] allSeries] objectAtIndex:seriesIdx];
    
    if (newTitle.length != 0 &&
        [[TMSeriesStore sharedStore] seriesByTitle:editField.text] == nil)
        series.title = newTitle;
    editingIndexPath = nil;
    [self.tableView reloadData];
}

- (void)showIdenticalTitleWarning
{
    editField.text = @"";
    editField.placeholder = @"Place enter a unique title";
}

@end
