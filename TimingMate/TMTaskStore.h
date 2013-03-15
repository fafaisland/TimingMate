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
    NSManagedObjectModel *model;
}

+ (TMTaskStore *)sharedStore;

- (NSArray *)allTasks;
- (TMTask *)createTask;

@end
