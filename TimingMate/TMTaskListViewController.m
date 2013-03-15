//
//  TMTaskListViewController.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskListViewController.h"

#import "TMGlobals.h"

@implementation TMTaskListViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
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

@end
