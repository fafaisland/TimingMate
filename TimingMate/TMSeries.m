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

- (int)getTotalTimeSpent
{
    int total = 0;
    for (TMTask *task in self.tasks)
        total += [task getTotalTimeSpent];
    return total;
}

- (int)getAverageTimeSpentPerTask
{
    if (self.tasks.count == 0)
        return 0;

    return [self getTotalTimeSpent] / self.tasks.count;
}

@end
