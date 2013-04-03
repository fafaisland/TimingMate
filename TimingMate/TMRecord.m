//
//  TMRecord.m
//  TimingMate
//
//  Created by easonfafa on 3/22/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMRecord.h"
#import "TMTask.h"


@implementation TMRecord

@dynamic beginTime;
@dynamic timeSpent;
@dynamic task;


-(NSString *)getDateDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.beginTime];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    return [NSString stringWithFormat:@"%02d-%02d-%02d", year, month, day];
}

-(NSString *)getHourAndMinute
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:self.beginTime];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    return [NSString stringWithFormat:@"%02d:%02d", hour, minute];
}
@end
