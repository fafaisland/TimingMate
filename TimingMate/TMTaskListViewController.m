//
//  TMTaskListViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskListViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "TMEditTaskViewController.h"
#import "TMGlobals.h"
#import "TMListsViewEditableCell.h"
#import "TMTask.h"
#import "TMTaskStore.h"
#import "TMTimerViewController.h"
#import "thirdparty/SideSwipeTableViewCell.h"

#define BUTTON_LEFT_MARGIN 10.0
#define BUTTON_SPACING 25.0

enum { TMEditSectionIndex = 0,
       TMTaskSectionIndex = 1,
       TMSectionsEnd = 2 };

@interface TMTaskListViewController (PrivateStuff)
-(void) setupSideSwipeView;
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage;
@end

@implementation TMTaskListViewController

@synthesize listGenerationBlock, onLoadBlock;

- (id)init
{
    self = [super init];
    if (self) {
        taskToRefresh = nil;

        UIBarButtonItem *listButton = [[UIBarButtonItem alloc]
                                       initWithTitle:TMListsTitle
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(showListSelectionView:)];
        self.navigationItem.leftBarButtonItem = listButton;
        
        deleteButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Delete"
                         style:UIBarButtonItemStyleBordered
                         target:self
                         action:@selector(toggleDelete)];
        deleteDoneButton = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                            target:self
                            action:@selector(toggleDelete)];
        self.navigationItem.rightBarButtonItem = deleteButton;
        
        finishedTaskColor = [UIColor grayColor];
        unfinishedTaskColor = [UIColor blackColor];
        
        onLoadBlock = nil;
        clickedAccessoryButton = NO;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    self = [self init];
    if (self) {
        self.navigationItem.title = title;
        listGenerationBlock = ^(NSMutableArray * list){
            [list removeAllObjects];
            [list addObjectsFromArray:[[TMTaskStore sharedStore] allTasks]];
        };
        
        tasks = [NSMutableArray array];
        listGenerationBlock(tasks);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (taskToRefresh)
    {
        [[TMTaskStore sharedStore] fetchAllTasks];
        listGenerationBlock(tasks);
        taskToRefresh = nil;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TMListsViewEditableCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:TMListsViewEditableCellIdentifier];

    // Setup the title and image for each button within the side swipe view
    sideSwipeButtonData = [NSArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Delete", @"title", @"trash.png", @"image", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Engage", @"title", @"engage.png", @"image", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Finish", @"title", @"finish.png", @"image", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Profile", @"title", @"person.png", @"image", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Links", @"title", @"paperclip.png", @"image", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Action", @"title", @"action.png", @"image", nil],
                           nil];
    sideSwipeButtons = [[NSMutableArray alloc] initWithCapacity:sideSwipeButtonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    clickedAccessoryButton = NO;
    
    if (onLoadBlock) {
        onLoadBlock();
        onLoadBlock = nil;
    }
}

#pragma mark - Button handlers

- (void)showListSelectionView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*CGRect f = self.navigationController.view.frame;
 [CATransaction begin];
 CATransition *tr = [CATransition animation];
 tr.duration = 0.25;
 tr.type = kCATransitionMoveIn;
 tr.subtype = kCATransitionFromLeft;
 [nc.view.layer addAnimation:tr forKey:nil];
 nc.view.frame = CGRectMake(f.origin.x, f.origin.y,
 f.size.width, f.size.height);
 [self.navigationController.view addSubview:nc.view];
 [CATransaction commit];*/

- (void)toggleDelete
{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = deleteButton;
    } else {
        [self removeSideSwipeView:YES];
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = deleteDoneButton;
    }
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (clickedAccessoryButton || [textField.text isEqualToString:@""])
        return;

    TMTask *newTask = [self createAndSetupNewTask];
    newTask.title = textField.text;
    [self reloadWithTask:newTask];
    addField.text = @"";
}

#pragma mark - Table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TMSectionsEnd;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == TMTaskSectionIndex) {

        SideSwipeTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SideSwipeTableViewCell alloc]
                                 initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
        }

        TMTask *t = [tasks objectAtIndex:indexPath.row];
        cell.textLabel.text = t.title;
        
        if (t.isFinished) {
            cell.textLabel.textColor = finishedTaskColor;
        } else {
            cell.textLabel.textColor = unfinishedTaskColor;
        }
        //cell.supressDeleteButton = ![self gestureRecognizersSupported];
        cell.supressDeleteButton = NO;
        
        return cell;
    } else {
        TMListsViewEditableCell *editableCell = [tableView
                                                 dequeueReusableCellWithIdentifier:TMListsViewEditableCellIdentifier];
        addField = editableCell.titleField;
        addField.text = @"";
        [addField setPlaceholder:@"Add a new task"];
        addField.delegate = self;
        editableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        editableCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        return editableCell;
    }
}
         
- (void)tableView:(UITableView *)tableView
        accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    clickedAccessoryButton = YES;
    [self addNewTaskWithTitle:addField.text];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)
    editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        [[TMTaskStore sharedStore] removeTask:t];
        [tasks removeObject:t];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TMTaskSectionIndex) {
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        [self showTimerViewForTask:t];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TMTaskSectionIndex)
        return tasks.count;
    else
        return 1;
}

- (void)reloadRowsAtIndexPaths:(NSIndexPath*)indexPath
{
    NSIndexPath* rowToReload = indexPath;
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TMTaskSectionIndex)
        return YES;
    return NO;
}

#pragma mark - Helper methods

- (void)addNewTaskWithTitle:(NSString *)title
{
    TMTask *t = [self createAndSetupNewTask];
    t.title = title;
    
    [self presentViewForAddingTask:t];
}

- (TMTask *)createAndSetupNewTask
{
    TMTask *t = [[TMTaskStore sharedStore] createAndAddTask];
    return t;
}

- (void)reloadWithTask:(TMTask *)task
{
    listGenerationBlock(tasks);

    if ([self viewIncludesTask:task])
    {
        NSInteger lastSection = [self numberOfSectionsInTableView:self.tableView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:lastSection-1];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (void)removeTask:(TMTask *)task
{
    [[TMTaskStore sharedStore] removeTask:task];
}

- (void)showTimerViewForTask:(TMTask *)task
{
    TMTimerViewController *tvc = [[TMTimerViewController alloc] initWithTask:task];
    [tvc setTaskListView:self];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)refreshTask:(TMTask *)task;
{
    taskToRefresh = task;
}

- (void)changeColorForCell:(UITableViewCell *)cell color:(UIColor *)color
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    cell.textLabel.textColor = color;
    [UIView commitAnimations];
}

- (void)presentViewForAddingTask:(TMTask *)task
{
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                      initWithTask:task
                                      asNewTask:YES];
    [etvc setTaskListView:self];
    [etvc setDismissBlock:^{
        [self reloadWithTask:task];
    }];
    [etvc setCancelBlock:^{
        [self removeTask:task];
    }];
    [self.navigationController pushViewController:etvc animated:YES];
}

- (BOOL)viewIncludesTask:(TMTask *)task
{
    return YES;
}

#pragma mark - SideSwipeView

- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{
    CGPoint location = [recognizer locationInView:tableView];
    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:location];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

    if (!cell || ![self swipeIsEnabledForSection:indexPath.section])
        return;
    
    TMTask *t = [tasks objectAtIndex:indexPath.row];
    
    NSDictionary* engageButtonInfo = [sideSwipeButtonData objectAtIndex:1];
    UIButton *engageButton = [sideSwipeButtons objectAtIndex:1];
    NSDictionary* finishButtonInfo = [sideSwipeButtonData objectAtIndex:2];
    UIButton *finishButton = [sideSwipeButtons objectAtIndex:2];
    if (t.isEngaging)
    {
        [self changeButtonImageColorTo:@"yellow" on:engageButton with:engageButtonInfo];
    }else{
        [self changeButtonImageColorTo:@"gray" on:engageButton with:engageButtonInfo];
    }
    if (t.isFinished) {
        [self changeButtonImageColorTo:@"yellow" on:finishButton with:finishButtonInfo];
    } else {
        [self changeButtonImageColorTo:@"gray" on:finishButton with:finishButtonInfo];
    }
    [super swipe:recognizer direction:direction];
    
}

- (BOOL)swipeIsEnabledForSection:(NSInteger)section
{
    return YES;
}

- (void)setupSideSwipeView
{
    // Add the background pattern
    self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:sideSwipeView.frame];
    shadowImageView.alpha = 0.6;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    // Iterate through the button data and create a button for each entry
    CGFloat leftEdge = BUTTON_LEFT_MARGIN;
    for (NSDictionary* buttonInfo in sideSwipeButtonData)
    {
        // Create the button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Make sure the button ends up in the right place when the cell is resized
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        // Get the button image
        UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
        
        // Set the button's frame
        button.frame = CGRectMake(leftEdge, sideSwipeView.center.y - buttonImage.size.height/2.0, buttonImage.size.width, buttonImage.size.height);
        
        // Add the image as the button's background image
        // [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        UIImage* grayImage = [self imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
        //UIImage* grayImage = [self imageFilledWith:[UIColor colorWithRed:255.0f/255.0f green:215.0f/255.0f blue:0.0f/255.0f alpha:1.0f] using:buttonImage];
        [button setImage:grayImage forState:UIControlStateNormal];
        
        // Add a touch up inside action
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Keep track of the buttons so we know the proper text to display in the touch up inside action
        [sideSwipeButtons addObject:button];
        
        // Add the button to the side swipe view
        [self.sideSwipeView addSubview:button];
        
        // Move the left edge in prepartion for the next button
        leftEdge = leftEdge + buttonImage.size.width + BUTTON_SPACING;
    }
}

- (IBAction) touchUpInsideAction:(UIButton*)button
{
    NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    
    NSUInteger index = [sideSwipeButtons indexOfObject:button];
    NSDictionary* buttonInfo = [sideSwipeButtonData objectAtIndex:index];
    
    if ([[buttonInfo objectForKey:@"title"] isEqualToString:@"Delete"])
    {
        NSLog(@"Delete");
        NSLog(@"%d",index);
        [self removeSideSwipeView:NO];
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        [[TMTaskStore sharedStore] removeTask:t];
        [tasks removeObject:t];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if ([[buttonInfo objectForKey:@"title"] isEqualToString:@"Engage"])
    {
        NSLog(@"Engage");
        NSLog(@"%d",index);
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        t.isEngaging = !t.isEngaging;
        if (t.isEngaging)
        {
            [self changeButtonImageColorTo:@"yellow" on:button with:buttonInfo];
        }
        else{
            [self changeButtonImageColorTo:@"gray" on:button with:buttonInfo];
        }
    }
    else if ([[buttonInfo objectForKey:@"title"] isEqualToString:@"Finish"]){
        NSLog(@"Finish");
        NSLog(@"%d",index);
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        t.isFinished = !t.isFinished;
        if (t.isFinished)
        {
            [self changeButtonImageColorTo:@"yellow" on:button with:buttonInfo];
            [self changeColorForCell:self.sideSwipeCell color:finishedTaskColor];
        }
        else{
            [self changeButtonImageColorTo:@"gray" on:button with:buttonInfo];
            [self changeColorForCell:self.sideSwipeCell color:unfinishedTaskColor];
        }
    }
    else {
        [self removeSideSwipeView:YES];
    }
}

# pragma color methods
- (void) changeButtonImageColorTo:(NSString *)color on:(UIButton *)button with:(NSDictionary *) buttonInfo
{
    UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
    UIImage* colorImage = nil;
    if ([color isEqualToString:@"yellow"])
    {
        colorImage = [self imageFilledWith:[UIColor colorWithRed:255.0f/255.0f green:215.0f/255.0f blue:0.0f/255.0f alpha:1.0f] using:buttonImage];
    }
    else if ([color isEqualToString:@"gray"])
    {
        colorImage = [self imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
    }
    [button setImage:colorImage forState:UIControlStateNormal];
}

// Convert the image's fill color to the passed in color
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    // Fill with color
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

@end
