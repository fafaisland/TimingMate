//
//  TMListsViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/18/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMListsViewController : UITableViewController
    <UITextFieldDelegate, UIAlertViewDelegate>
{
    __weak UITextField *editField;
    __weak UITextField *addField;

    UIBarButtonItem *editButton;
    UIBarButtonItem *editDoneButton;
    
    NSIndexPath *indexOfSeriesToBeDeleted;
    NSIndexPath *editingIndexPath;
    
    BOOL switchingViews;
}

- (void)pushDefaultList;

@end
