//
//  TMSeries.m
//  TimingMate
//
//  Created by Long Wei on 3/19/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMSeries.h"
#import "TMTask.h"


@implementation TMSeries

@dynamic title;
@dynamic tasks;

- (void)awakeFromInsert
{
    self.title = @"Test Series";
}

@end
