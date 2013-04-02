//
//  TMSeriesViewController.h
//  TimingMate
//
//  Created by Long Wei on 4/2/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMTaskListViewController.h"

@class TMSeries;

@interface TMSeriesViewController : TMTaskListViewController
{
    TMSeries *series;
}

- (id)initWithTitle:(NSString *)title;

@end
