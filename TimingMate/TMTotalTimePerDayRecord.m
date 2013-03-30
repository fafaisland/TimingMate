//
//  TMTotalTimePerDayRecord.m
//  TimingMate
//
//  Created by easonfafa on 3/28/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTotalTimePerDayRecord.h"

@implementation TMTotalTimePerDayRecord

@synthesize someDay;
@synthesize totalTimeInSeconds;
- (id)initWithSomeDay:(NSString *)day withSeconds:(int32_t)seconds
{
    self = [super init];
    if (self) {
        someDay = day;
        totalTimeInSeconds = seconds;
    }
    return self;
}
- (void)addTimeInSeconds:(int32_t)seconds
{
    totalTimeInSeconds += seconds;
}
@end
