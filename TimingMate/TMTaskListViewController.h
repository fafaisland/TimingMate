//
//  TMTaskListViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "thirdparty/SideSwipeTableViewController.h"

@class TMTask;

@interface TMTaskListViewController : SideSwipeTableViewController
    <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *tasks;

    UIBarButtonItem *deleteButton;
    UIBarButtonItem *deleteDoneButton;
    
    TMTask *taskToRefresh;
    
    NSArray* sideSwipeButtonData;
    NSMutableArray* sideSwipeButtons;
    
    UIColor *finishedTaskColor;
    UIColor *unfinishedTaskColor;
    
    UITextField *addField;
    BOOL clickedAccessoryButton;
}

@property (nonatomic, copy) void (^listGenerationBlock)(NSMutableArray *);
@property (nonatomic, copy) void (^onLoadBlock)(void);

- (id)initWithTitle:(NSString *)title;
- (void)refreshTask:(TMTask *)task;
- (void)presentViewForAddingTask:(TMTask *)task;

@end
