//
//  TMTaskListViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskListViewController.h"

#import "TMEditTaskViewController.h"
#import "TMGlobals.h"
#import "TMTask.h"
#import "TMTaskStore.h"
#import "TMTimerViewController.h"

@implementation TMTaskListViewController

@synthesize listGenerationBlock;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
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
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItems = @[addButton, deleteButton];
    } else {
        [self setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItems = @[addButton, deleteDoneButton];
    }

}

#pragma mark - Table methods

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
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

@end
