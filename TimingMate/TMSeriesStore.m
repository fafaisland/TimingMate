//
//  TMSeriesStore.m
//  TimingMate
//
//  Created by Long Wei on 3/23/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMSeriesStore.h"

#import "TMSeries.h"

@implementation TMSeriesStore

@synthesize context;

- (id)init
{
    self = [super init];
    if (self) {
        TMSeriesEntityName = NSStringFromClass([TMSeries class]);
    }
    
    return self;
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

- (void)createAndAddSeriesWithTitle:(NSString *)title
{
    TMSeries *s = [NSEntityDescription insertNewObjectForEntityForName:TMSeriesEntityName
                                                inManagedObjectContext:context];
    s.title = title;
    [allSeries addObject:s];
}

- (void)removeSeries:(TMSeries *)s
{
    [context deleteObject:s];
    [allSeries removeObjectIdenticalTo:s];
}

- (NSInteger)indexOfSeriesByTitle:(NSString *)title
{
    return [allSeries indexOfObject:[self seriesByTitle:title]];
}

- (TMSeries *)seriesByTitle:(NSString *)title
{
    for (NSInteger i = 0; i < allSeries.count; i++) {
        TMSeries *s = [allSeries objectAtIndex:i];
        if ([s.title localizedCompare:title] == NSOrderedSame)
            return s;
    }
    return nil;
}

#pragma mark - Static methods

+ (TMSeriesStore *)sharedStore
{
    static TMSeriesStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

@end
