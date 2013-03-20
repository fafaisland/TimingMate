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
    static int counter = 0;

    self.title = [NSString stringWithFormat:@"Test Series %d", counter++];
}

@end
