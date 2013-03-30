//
//  TMRecordListPerDayViewController.h
//  TimingMate
//
//  Created by easonfafa on 3/26/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMTask;

@interface TMRecordListPerDayViewController : UITableViewController
{
    NSMutableArray *totalTimePerDayRecordArray;
}
@property (nonatomic, strong) TMTask *task;

- (id)initWithStyle:(UITableViewStyle)style
           withTask:(TMTask *)aTask;
@end
