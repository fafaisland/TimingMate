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

    if (hours != 0 || minutes != 0)
        [timeStr appendString:[NSString stringWithFormat:@"%d min ", minutes]];

    [timeStr appendString:[NSString stringWithFormat:@"%d sec", seconds]];
    
    return timeStr;
}

NSString * TMMakeTimeStringFromHoursMinutes(int hours, int minutes)
{
    NSMutableString *timeStr = [NSMutableString string];
    if (hours != 0)
        [timeStr appendString:[NSString stringWithFormat:@"%d hr ", hours]];

    [timeStr appendString:[NSString stringWithFormat:@"%d min ", minutes]];
    
    return timeStr;
}

NSString * TMMakeTimeStringFromSeconds(int seconds)
{
    int hours = seconds / 3600;
    int secondsLeft = seconds % 3600;
    
    int minutes = secondsLeft / 60;
    secondsLeft = secondsLeft % 60;
    
    return TMMakeTimeString(hours, minutes, secondsLeft);
}
