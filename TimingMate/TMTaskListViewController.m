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
#import "TMTask.h"
#import "TMTaskStore.h"
#import "TMTimerViewController.h"
#import "thirdparty/SideSwipeTableViewCell.h"

#define BUTTON_LEFT_MARGIN 10.0
#define BUTTON_SPACING 25.0

@interface TMTaskListViewController (PrivateStuff)
-(void) setupSideSwipeView;
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage;
@end

@implementation TMTaskListViewController

@synthesize listGenerationBlock;

- (id)init
{
    self = [super init];
    if (self) {
        needsReload = NO;

        UIBarButtonItem *listButton = [[UIBarButtonItem alloc]
                                       initWithTitle:TMListsTitle
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(showListSelectionView:)];
        self.navigationItem.leftBarButtonItem = listButton;
        
        addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self action:@selector(addNewTask:)];
        deleteButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Delete"
                         style:UIBarButtonItemStyleBordered
                         target:self
                         action:@selector(toggleDelete)];
        deleteDoneButton = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                            target:self
                            action:@selector(toggleDelete)];
        self.navigationItem.rightBarButtonItems = @[addButton, deleteButton];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
        listGenerationBlock:(void (^)(NSMutableArray*))block
{
    self = [self init];
    if (self) {
        self.navigationItem.title = title;
        self.listGenerationBlock = block;
        
        tasks = [NSMutableArray array];
        block(tasks);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (needsReload)
    {
        [[TMTaskStore sharedStore] fetchAllTasks];
        listGenerationBlock(tasks);
        needsReload = NO;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

#pragma mark - Button handlers

- (void)showListSelectionView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNewTask:(id)sender
{
    TMTask *t = [[TMTaskStore sharedStore] createTask];
    
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                      initWithTask:t
                                      asNewTask:YES];
    [etvc setDismissBlock:^{
        [self addTask:t];
    }];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:etvc];
    [self presentViewController:nc animated:YES completion:nil];
    
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
}

- (void)toggleDelete
{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItems = @[addButton, deleteButton];
    } else {
        [self removeSideSwipeView:YES];
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItems = @[addButton, deleteDoneButton];
    }
}

#pragma mark - Table methods

- (UITableViewCell *)tableView:(UITableView *)theTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    SideSwipeTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SideSwipeTableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:CellIdentifier];
    }

    TMTask *t = [tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = t.title;
    
    if (t.isFinished) {
        cell.textLabel.textColor = [UIColor grayColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    //cell.supressDeleteButton = ![self gestureRecognizersSupported];
    cell.supressDeleteButton = NO;
    
    return cell;
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
    TMTask *t = [tasks objectAtIndex:indexPath.row];
    [self showTimerViewForTask:t];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tasks.count;
}

- (void)reloadRowsAtIndexPaths:(NSIndexPath*)indexPath
{
    NSIndexPath* rowToReload = indexPath;
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Helper methods

- (void)addTask:(TMTask *)task
{
    [[TMTaskStore sharedStore] addTask:task];
    
    listGenerationBlock(tasks);
    [self.tableView reloadData];
    
    /*
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
     */
}

- (void)showTimerViewForTask:(TMTask *)task
{
    TMTimerViewController *tvc = [[TMTimerViewController alloc] initWithTask:task];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)setNeedsReload
{
    needsReload = YES;
}

#pragma mark - SideSwipeView

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
    /*[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"%@ on cell %d", [buttonInfo objectForKey:@"title"], indexPath.row]
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:@"OK", nil] show];*/
    if ([buttonInfo objectForKey:@"title"] == @"Delete")
    {
        NSLog(@"Delete");
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        [[TMTaskStore sharedStore] removeTask:t];
        [tasks removeObject:t];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if ([buttonInfo objectForKey:@"title"] == @"Engage")
    {
        NSLog(@"Engage");
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        t.isEngaging = !t.isEngaging;
        if (t.isEngaging == YES)
        {
            [self changeButtonImageColorTo:@"yellow" on:button with:buttonInfo];
        }
        else{
            [self changeButtonImageColorTo:@"gray" on:button with:buttonInfo];
        }
    }
    else if ([buttonInfo objectForKey:@"title"] == @"Finish"){
        NSLog(@"Finish");
        TMTask *t = [tasks objectAtIndex:indexPath.row];
        t.isFinished = !t.isFinished;
        if (t.isFinished == YES)
        {
            [self changeButtonImageColorTo:@"yellow" on:button with:buttonInfo];
        }
        else{
            [self changeButtonImageColorTo:@"gray" on:button with:buttonInfo];
        }
        [self reloadRowsAtIndexPaths:indexPath];
    }
    else{
        NSLog(@"Long Gun Du Zi~~~!!!");
    }
    
    [self removeSideSwipeView:YES];
}

# pragma color methods
- (void) changeButtonImageColorTo:(NSString *)color on:(UIButton *)button with:(NSDictionary *) buttonInfo
{
    UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
    UIImage* colorImage = nil;
    if (color == @"yellow")
    {
        colorImage = [self imageFilledWith:[UIColor colorWithRed:255.0f/255.0f green:215.0f/255.0f blue:0.0f/255.0f alpha:1.0f] using:buttonImage];
    }
    else if (color == @"gray")
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
