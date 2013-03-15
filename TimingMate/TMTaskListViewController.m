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
    }
    return self;
}

@end
