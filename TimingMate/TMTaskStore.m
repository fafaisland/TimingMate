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

@implementation TMTaskStore

@synthesize context;

- (id)init
{
    self = [super init];
    if (self) {
        TMTaskEntityName = NSStringFromClass([TMTask class]);
        TMSeriesEntityName = NSStringFromClass([TMSeries class]);
    }
    
    return self;
}

- (NSArray *)allTasks
{
    return allTasks;
}

- (NSArray *)allSeries
{
    if (!allSeries) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription
                          entityForName:TMSeriesEntityName
                          inManagedObjectContext:context];
        NSError *error;
        NSArray *result = [context executeFetchRequest:request
                                                 error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        allSeries = result.mutableCopy;
    }
    
    return allSeries;
}

- (TMTask *)createTask
{
    TMTask *t = [NSEntityDescription insertNewObjectForEntityForName:TMTaskEntityName
                                              inManagedObjectContext:context];
    return t;
}

- (void)addTask:(TMTask *)t
{
    [allTasks insertObject:t atIndex:0];
}

- (void)removeTask:(TMTask *)t
{
    [context deleteObject:t];
    [allTasks removeObjectIdenticalTo:t];
}

- (NSString *)taskArchivePath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllTasks
{
    if (!allTasks) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:TMTaskEntityName
                                             inManagedObjectContext:context];
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request
                                                 error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        allTasks = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (void)createAndAddSeries
{
    TMSeries *t = [NSEntityDescription insertNewObjectForEntityForName:TMSeriesEntityName
                                              inManagedObjectContext:context];
    [allSeries addObject:t];
}

- (NSInteger)indexOfSeriesByTitle:(NSString *)title
{
    for (NSInteger i = 0; i < allSeries.count; i++) {
        if ([[allSeries objectAtIndex:i] title] == title)
            return i;
    }
    return -1;
}

- (BOOL)saveChanges
{
    NSError *error = nil;
    BOOL successful = [context save:&error];
    if (!successful) {
        
    }
    return successful;
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
