//
//  TMListsViewController.h
//  TimingMate
//
//  Created by Long Wei on 3/18/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMListsViewController : UITableViewController <UITextFieldDelegate>
{
    BOOL isAdding;
    __weak UITextField *addField;
    
    UIBarButtonItem *addButton;
    UIBarButtonItem *addDoneButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *deleteDoneButton;
}

- (void)pushDefaultList;

@end
