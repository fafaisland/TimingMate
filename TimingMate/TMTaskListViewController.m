//
//  TMTaskListViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskListViewController.h"

#import "TMEditTaskViewController.h"
#import "TMTask.h"
#import "TMTaskStore.h"
#import "TMTimerViewController.h"

@implementation TMTaskListViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self.navigationItem setTitle:@"All"];
        
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Lists"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(showListSelectionView:)];
        self.navigationItem.leftBarButtonItem = listButton;
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self action:@selector(addNewTask:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Button handlers

- (void)addNewTask:(id)sender
{
    TMTask *t = [[TMTaskStore sharedStore] createTask];
    
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                      initWithTask:t
                                      asNewTask:YES];
    [etvc setDismissBlock:^{
        [[TMTaskStore sharedStore] addTask:t];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:etvc];
    [self presentViewController:nc animated:YES completion:nil];
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
    
    TMTask *t = [[[TMTaskStore sharedStore] allTasks] objectAtIndex:indexPath.row];
    cell.textLabel.text = t.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMTask *t = [[[TMTaskStore sharedStore] allTasks] objectAtIndex:indexPath.row];
    TMTimerViewController *tvc = [[TMTimerViewController alloc] initWithTask:t];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TMTaskStore sharedStore] allTasks].count;
}

@end
