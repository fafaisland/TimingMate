//
//  TMTopBarViewController.m
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTopBarViewController.h"

#import "TMTimer.h"

@interface TMTopBarViewController ()

@end

@implementation TMTopBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TMTimer timer] addListener:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveEventFromTimer:(TMTimer *)timer
{
    static int foo = 0;
    
    [label setText:[NSString stringWithFormat:@"%d", foo++]];
}

@end
