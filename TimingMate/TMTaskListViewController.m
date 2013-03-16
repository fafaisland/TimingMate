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

@implementation TMTaskListViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [[TMTaskStore sharedStore] createTask];

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
    
    [self.navigationController pushViewController:etvc animated:YES];
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
    TMEditTaskViewController *etvc = [[TMEditTaskViewController alloc]
                                      initWithTask:t
                                      asNewTask:NO];
    
    [self.navigationController pushViewController:etvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TMTaskStore sharedStore] allTasks].count;
}

@end
