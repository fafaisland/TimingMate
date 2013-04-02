//
//  TMEngagingViewController.m
//  TimingMate
//
//  Created by Long Wei on 4/2/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMEngagingViewController.h"

#import "TMTask.h"
#import "TMTaskStore.h"

@interface TMEngagingViewController ()

@end

@implementation TMEngagingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.navigationItem.title = title;
        self.listGenerationBlock = ^(NSMutableArray * list){
            [list removeAllObjects];
            [list addObjectsFromArray:[[TMTaskStore sharedStore] allEngagingTasks]];
        };
        
        tasks = [NSMutableArray array];
        self.listGenerationBlock(tasks);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)viewIncludesTask:(TMTask *)task
{
    return task.isEngaging;
}

@end
