//
//  TMTimer.m
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTimer.h"

#import "TMTimerListener.h"

@implementation TMTimer

- (id)init
{
    self = [super init];
    if (self) {
        listeners = [NSMutableArray array];
    }
    return self;
}

- (void)startTimerWithTimeInterval:(NSTimeInterval)interval
{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                 target:self
                                               selector:@selector(fireTimer)
                                               userInfo:nil
                                                repeats:YES];
    }
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)addListener:(id)listener
{
    if (![listeners containsObject:listener])
        [listeners addObject:listener];
}

- (void)removeListener:(id)listener
{
    [listeners removeObject:listener];
}

- (void)fireTimer
{
    for (id listener in listeners)
        [listener receiveEventFromTimer:self];
}

- (void)sendInterrupt
{
    [self stopTimer];
    while (listeners.count != 0) {
        id listener = [listeners objectAtIndex:listeners.count-1];
        [listener receiveInterruptFromTimer:self];
    }
}

+ (TMTimer *)timer
{
    static TMTimer *timer = nil;
    if (!timer)
        timer = [[super allocWithZone:nil] init];
    
    return timer;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self timer];
}

@end
