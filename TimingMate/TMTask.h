//
//  TMTask.h
//  TimingMate
//
//  Created by Long Wei on 3/23/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "TMTimerListener.h"

@class TMRecord, TMSeries, TMTotalTimePerDayRecord, TMRunningRecord;

@interface TMTask : NSManagedObject <TMTimerListener>
{
    NSDate *recordBeginTime;
    int elapsedTimeOnRecord;
}

@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic) double expectedCompletionTime;
@property (nonatomic) BOOL isEngaging;
@property (nonatomic) BOOL isFinished;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *records;
@property (nonatomic, retain) TMSeries *series;
@end

@interface TMTask (CoreDataGeneratedAccessors)

- (void)addRecordsObject:(TMRecord *)value;
- (void)removeRecordsObject:(TMRecord *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;
- (NSMutableArray *)computeTotalTimePerDayRecords;

- (TMRecord *)createRecordBeginningAt:(NSDate *)beginTime
                        withTimeSpent:(int32_t)timeSpent;
- (int)expectedTimeHours;
- (int)expectedTimeMinutes;
- (int)getTotalTimeSpent;

- (void)beginNewRecord;
- (void)endNewRecord;
- (int)elapsedTimeOnRecord;

- (TMRunningRecord *)getRunningRecord;
- (void)restartRecordWithTime:(NSDate *)beginTime;

@end
