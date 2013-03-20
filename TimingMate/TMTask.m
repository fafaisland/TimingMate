//
//  TMTask.m
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTask.h"

@implementation TMTask

@dynamic expectedCompletionTime;
@dynamic isEngaging;
@dynamic isFinished;
@dynamic title;
@dynamic creationTime;
@dynamic series;

- (void)awakeFromInsert
{
    self.title = @"Task";
    self.expectedCompletionTime = 0.0;
    self.isFinished = NO;
    self.series = nil;
    self.creationTime = [NSDate date];
}

@end
