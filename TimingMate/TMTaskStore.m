//
//  TMTaskStore.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskStore.h"

#import "TMTask.h"

@implementation TMTaskStore

- (id)init
{
    self = [super init];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                             initWithManagedObjectModel:model];
        
        NSURL *storeURL = [NSURL fileURLWithPath:[self taskArchivePath]];
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        
        [self loadAllTasks];
    }
    
    return self;
}

- (NSArray *)allTasks
{
    return allTasks;
}

- (TMTask *)createTask
{
    TMTask *t = [NSEntityDescription insertNewObjectForEntityForName:@"TMTask"
                                              inManagedObjectContext:context];
    [t setDefaultData];
    
    [allTasks addObject:t];
    
    return t;
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
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"TMTask"];
        [request setEntity:e];
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
