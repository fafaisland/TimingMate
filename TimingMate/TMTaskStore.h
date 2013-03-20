//
//  TMTaskStore.h
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMTask;

@interface TMTaskStore : NSObject
{
    NSMutableArray *allTasks;
    NSMutableArray *allSeries;
    NSManagedObjectContext *context;
    
    NSString *TMTaskEntityName;
    NSString *TMSeriesEntityName;
}

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (TMTaskStore *)sharedStore;

- (TMTask *)createTask;
- (void)addTask:(TMTask *)t;
- (void)removeTask:(TMTask *)t;
- (void)loadAllTasks;
- (void)createAndAddSeries;
- (BOOL)saveChanges;

- (NSArray *)allTasks;
- (NSArray *)allSeries;

@end
