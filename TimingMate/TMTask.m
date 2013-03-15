//
//  TMTask.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTask.h"


@implementation TMTask

@dynamic title;
@dynamic expectedCompletionTime;
@dynamic isFinished;
@dynamic series;

- (id)init
{
    self = [super init];
    if (self) {
        [self setValue:@"Task" forKey:@"title"];
        self.expectedCompletionTime = 0.0;
        self.isFinished = NO;
        self.series = nil;
    }

    return self;
}

- (void)setDefaultData
{
    self.title = @"Task";
    self.expectedCompletionTime = 0.0;
    self.isFinished = NO;
    self.series = nil;
}

@end
