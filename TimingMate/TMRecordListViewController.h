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
    NSMutableArray *recordsMutableArray;
    NSArray *recordsArray;
    NSString *day;
}
- (id)initWithStyle:(UITableViewStyle)style withTask:(TMTask *)aTask withSomeDay:(NSString *)someDay;


- (IBAction)changetoAddRecordView:(id)sender;
@property (nonatomic, strong) TMTask *task;

@end
