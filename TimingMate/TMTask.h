//
//  TMTask.h
//  TimingMate
//
//  Created by Long Wei on 3/23/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TMRecord, TMSeries;

@interface TMTask : NSManagedObject

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

- (TMRecord *)createRecordBeginningAt:(NSDate *)beginTime
                             endingAt:(NSDate *)endTime
                        withTimeSpent:(int32_t)timeSpent;

@end
