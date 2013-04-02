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
    NSManagedObjectContext *context;
    
    NSString *TMTaskEntityName;
}

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (TMTaskStore *)sharedStore;

- (TMTask *)createAndAddTask;
- (void)addTask:(TMTask *)t;
- (void)removeTask:(TMTask *)t;

- (NSArray *)allTasks;
- (void)fetchAllTasks;
- (NSArray *)allEngagingTasks;

@end
