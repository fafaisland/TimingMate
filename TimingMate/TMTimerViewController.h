//
//  TMTimerViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTask;

@interface TMTimerViewController : UIViewController
{
}

- (id)initWithTask:(TMTask *)aTask;

@property (nonatomic, strong) TMTask *task;

@end
