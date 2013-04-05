//
//  TMTimer.h
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMTimer : NSObject
{
    NSTimer *timer;
    NSMutableArray *listeners;
}

+ (TMTimer *)timer;
- (void)startTimerWithTimeInterval:(NSTimeInterval)interval;
- (void)stopTimer;
- (void)addListener:(id)listener;
- (void)removeListener:(id)listener;

@end
