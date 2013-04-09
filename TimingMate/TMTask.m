//
//  TMTask.m
//  TimingMate
//
//  Created by Long Wei on 3/23/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTask.h"

#import "TMRecord.h"
#import "TMRunningRecord.h"
#import "TMSeries.h"
#import "TMTotalTimePerDayRecord.h"
#import "TMTaskStore.h"
#import "TMTimer.h"

@implementation TMTask

@dynamic creationTime;
@dynamic expectedCompletionTime;
@dynamic isEngaging;
@dynamic isFinished;
@dynamic title;
@dynamic records;
@dynamic series;

- (void)awakeFromInsert
{
    self.title = @"";
    self.expectedCompletionTime = 0.0;
    self.isFinished = NO;
    self.series = nil;
    self.creationTime = [NSDate date];
}

- (TMRecord *)createRecordBeginningAt:(NSDate *)beginTime
                        withTimeSpent:(int32_t)timeSpent
{
    NSString *TMRecordEntityName = NSStringFromClass([TMRecord class]);

    TMRecord *record = [NSEntityDescription insertNewObjectForEntityForName:TMRecordEntityName
                                        inManagedObjectContext:[TMTaskStore sharedStore].context];
    record.beginTime = beginTime;
    record.timeSpent = timeSpent;
    
    [self addRecordsObject:record];
    
    return record;
}

- (NSMutableArray *)computeTotalTimePerDayRecords
{
    if ([self.records count] > 0)
    {
        NSArray *recordsArray = [self.records allObjects];
        NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
            return [[obj1 beginTime] compare:[obj2 beginTime]];
        };
        NSArray *sortedRecordsArray = [recordsArray sortedArrayUsingComparator:sortBlock];
        NSMutableArray *totalTimePerDayRecordsArray = [[NSMutableArray alloc] init];
        for (TMRecord* r in sortedRecordsArray)
        {
            TMTotalTimePerDayRecord *lastRecord = [totalTimePerDayRecordsArray lastObject];
            if ([totalTimePerDayRecordsArray count] == 0 || [[r getDateDay] isEqualToString:lastRecord.someDay] == NO)
            {
                TMTotalTimePerDayRecord *ttpdRecord = [[TMTotalTimePerDayRecord alloc] initWithSomeDay:[r getDateDay] withSeconds:r.timeSpent];
                [totalTimePerDayRecordsArray addObject:ttpdRecord];
            }
            else{
                [[totalTimePerDayRecordsArray lastObject] addTimeInSeconds:r.timeSpent];
            }
        }
        return totalTimePerDayRecordsArray;
    }
    else{
        return nil;
    }
}

-(NSComparisonResult)compareByBeginTimeWithRecord1:(TMRecord *)TMRecord1 withRecord2:(TMRecord *)TMRecord2
{
    if (TMRecord1.beginTime > TMRecord2.beginTime)
    {
        return NSOrderedDescending;
    }
    else if (TMRecord1.beginTime == TMRecord2.beginTime)
    {
        return NSOrderedSame;
    }
    else{
        return NSOrderedAscending;
    }
}

- (int)expectedTimeHours
{
    return ((int)self.expectedCompletionTime) / 60;
}

- (int)expectedTimeMinutes
{
    return ((int)self.expectedCompletionTime) % 60;
}

- (int)getTotalTimeSpent
{
    int total = 0;
    for (TMRecord *record in self.records)
        total += record.timeSpent;
    return total;
}

- (void)beginNewRecord
{
    recordBeginTime = [[NSDate alloc] init];
    NSLog(@"Begin Time %@",recordBeginTime);
    elapsedTimeOnRecord = 0;
    [[TMTimer timer] addListener:self];
    [TMTaskStore sharedStore].currentTimingTask = self;
}

- (void)endNewRecord
{
    [[TMTimer timer] removeListener:self];
    if (elapsedTimeOnRecord == 0)
        return;

    [self createRecordBeginningAt:recordBeginTime
                             withTimeSpent:elapsedTimeOnRecord];
    [TMTaskStore sharedStore].currentTimingTask = nil;
}

- (int)elapsedTimeOnRecord
{
    return elapsedTimeOnRecord;
}

#pragma mark - Timer methods

- (void)receiveEventFromTimer:(TMTimer *)timer
{
    elapsedTimeOnRecord += 1;
}

- (void)receiveInterruptFromTimer:(TMTimer *)timer
{
    [[TMTimer timer] removeListener:self];
}

#pragma mark - Archiving

- (TMRunningRecord *)getRunningRecord
{
    TMRunningRecord *rr = [[TMRunningRecord alloc] init];
    rr.recordBeginTime = recordBeginTime;
    rr.taskURL = [[self objectID] URIRepresentation];
    return rr;
}

- (void)restartRecordWithTime:(NSDate *)beginTime;
{
    NSDate *now = [NSDate date];
    recordBeginTime = beginTime;
    elapsedTimeOnRecord = [now timeIntervalSinceDate:beginTime];
    [[TMTimer timer] addListener:self];
    [TMTaskStore sharedStore].currentTimingTask = self;
}

@end
