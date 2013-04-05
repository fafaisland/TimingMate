//
//  TMTimerListener.h
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMTimer;

@protocol TMTimerListener <NSObject>

- (void)receiveEventFromTimer:(TMTimer *)timer;

@end
