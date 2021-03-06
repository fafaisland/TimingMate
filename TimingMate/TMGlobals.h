//
//  TMGlobals.h
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

extern NSString * const TMListsTitle;

NSString * TMMakeTimeString(int hours, int minutes, int seconds);
NSString * TMMakeTimeStringFromHoursMinutes(int hours, int minutes);
NSString * TMMakeTimeStringFromSeconds(int seconds);
NSString * TMTimerStringFromSeconds(int seconds);
