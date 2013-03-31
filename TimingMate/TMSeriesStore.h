//
//  TMSeriesStore.h
//  TimingMate
//
//  Created by Long Wei on 3/23/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMSeries;

@interface TMSeriesStore : NSObject
{
    NSMutableArray *allSeries;
    NSManagedObjectContext *context;

    NSString *TMSeriesEntityName;
}

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (TMSeriesStore *)sharedStore;

- (NSArray *)allSeries;
- (void)createAndAddSeriesWithTitle:(NSString *)title;
- (void)removeSeries:(TMSeries *)s;

- (NSInteger)indexOfSeriesByTitle:(NSString *)title;
- (TMSeries *)seriesByTitle:(NSString *)title;

@end
