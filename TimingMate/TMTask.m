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

@end
