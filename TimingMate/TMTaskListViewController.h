//
//  TMTaskListViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "thirdparty/SideSwipeTableViewController.h"

@interface TMTaskListViewController : SideSwipeTableViewController
{
    NSMutableArray *tasks;
    
    UIBarButtonItem *addButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *deleteDoneButton;
    
    BOOL needsReload;
    
    NSArray* sideSwipeButtonData;
    NSMutableArray* sideSwipeButtons;
}

@property (nonatomic, copy) void (^listGenerationBlock)(NSMutableArray *);

- (id)initWithTitle:(NSString *)title listGenerationBlock:(void (^)(NSMutableArray*))block;
- (void)setNeedsReload;

@end
