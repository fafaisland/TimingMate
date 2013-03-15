//
//  TMTaskListViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskListViewController.h"

#import "TMGlobals.h"
#import "TMTask.h"
#import "TMTaskStore.h"

@implementation TMTaskListViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [[TMTaskStore sharedStore] createTask];

        [self.navigationItem setTitle:TMAppName];
        
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Lists"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(showListSelectionView:)];
        [self.navigationItem setLeftBarButtonItem:listButton];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self action:@selector(addNewTask:)];
        [self.navigationItem setRightBarButtonItem:addButton];
    }
    return self;
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TMTaskStore sharedStore] allTasks].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:@"UITableViewCell"];
    }
    
    TMTask *t = [[[TMTaskStore sharedStore] allTasks] objectAtIndex:indexPath.row];
    cell.textLabel.text = t.title;
    
    return cell;
}

@end
