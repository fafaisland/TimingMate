//
//  TMSeries.h
//  TimingMate
//
//  Created by Long Wei on 3/19/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TMTask;

@interface TMSeries : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface TMSeries (CoreDataGeneratedAccessors)

- (void)addTasksObject:(TMTask *)value;
- (void)removeTasksObject:(TMTask *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
