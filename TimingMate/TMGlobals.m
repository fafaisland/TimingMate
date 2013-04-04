//
//  TMGlobals.m
//  TimingMate
//
//  Created by Long Wei on 3/15/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMGlobals.h"

#import "TMTaskListViewController.h"

NSString * const TMListsTitle = @"Lists";

NSString * TMMakeTimeString(int hours, int minutes, int seconds)
{
    NSMutableString *timeStr = [NSMutableString string];
    if (hours != 0)
        [timeStr appendString:[NSString stringWithFormat:@"%d hr ", hours]];

    [timeStr appendString:[NSString stringWithFormat:@"%d min", minutes]];
    
    if (seconds != 0)
        [timeStr appendString:[NSString stringWithFormat:@"% d sec", seconds]];
    
    return timeStr;
}
