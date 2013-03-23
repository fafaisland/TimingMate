//
//  TMRecordListViewController.h
//  TimingMate
//
//  Created by easonfafa on 3/22/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMRecordListViewController : UITableViewController
{
    NSArray *recordsArray;
}
- (id)initWithStyle:(UITableViewStyle)style
        withRecords:(NSSet *)reocrds;

@end
