//
//  TMRecordListViewController.h
//  TimingMate
//
//  Created by easonfafa on 3/22/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMTask;

@interface TMRecordListViewController : UITableViewController
{
    NSArray *recordsArray;
}
- (id)initWithStyle:(UITableViewStyle)style
           withTask:(TMTask *)aTask
        withRecords:(NSSet *)reocrds;

- (IBAction)changetoAddRecordView:(id)sender;
@property (nonatomic, strong) TMTask *task;

@end
