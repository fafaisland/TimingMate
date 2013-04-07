//
//  TMTaskStore.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskStore.h"

#import "TMSeries.h"
#import "TMTask.h"
#import "TMTimer.h"

@implementation TMTaskStore

@synthesize context, currentTimingTask;

- (id)init
{
    self = [super init];
    if (self) {
        TMTaskEntityName = NSStringFromClass([TMTask class]);
        currentTimingTask = nil;
    }
    
    return self;
}

- (NSArray *)allTasks
{
    if (!allTasks) {
        [self fetchAllTasks];
    }

    return allTasks;
}

- (void)fetchAllTasks
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:TMTaskEntityName
                                 inManagedObjectContext:context];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"creationTime"
                                                          ascending:NO];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"isFinished"
                                                          ascending:YES];
    [request setSortDescriptors:@[sd2,sd1]];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request
                                             error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    allTasks = [[NSMutableArray alloc] initWithArray:result];
}

- (NSArray *)allEngagingTasks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEngaging == YES"];
    return [allTasks filteredArrayUsingPredicate:predicate];
}

- (TMTask *)createAndAddTask
{
    TMTask *t = [NSEntityDescription insertNewObjectForEntityForName:TMTaskEntityName
                                              inManagedObjectContext:context];
    [allTasks insertObject:t atIndex:0];
    return t;
}

- (void)removeTask:(TMTask *)t
{
    if (currentTimingTask == t) {
        [t endNewRecord];
        [[TMTimer timer] sendInterrupt];
    }
    [context deleteObject:t];
    [allTasks removeObjectIdenticalTo:t];
}

- (NSString *)taskArchivePath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

#pragma mark - Static methods

+ (TMTaskStore *)sharedStore
{
    static TMTaskStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

@end
