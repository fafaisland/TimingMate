//
//  TMTask.m
//  TimingMate
//
//  Created by Long Wei on 3/23/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTask.h"
#import "TMRecord.h"
#import "TMSeries.h"
#import "TMTotalTimePerDayRecord.h"
#import "TMTaskStore.h"

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
    self.title = @"Task";
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
        NSArray *sortedRecordsArray = [recordsArray sortedArrayUsingSelector:@selector(compareByBeginTime:)];
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
@end
