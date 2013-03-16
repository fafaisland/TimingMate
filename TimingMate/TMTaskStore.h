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
}

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (TMTaskStore *)sharedStore;

- (void)loadAllTasks;
- (NSArray *)allTasks;
- (TMTask *)createTask;

@end
