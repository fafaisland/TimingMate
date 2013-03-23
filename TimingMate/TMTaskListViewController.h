//
//  TMTaskListViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMTaskListViewController : UITableViewController
{
    NSMutableArray *tasks;
}

@property (nonatomic, copy) void (^listGenerationBlock)(NSMutableArray *);

- (id)initWithTitle:(NSString *)title listGenerationBlock:(void (^)(NSMutableArray*))block;

@end
