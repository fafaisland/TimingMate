//
//  TMAddRecordViewController.h
//  TimingMate
//
//  Created by easonfafa on 3/24/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTask;

@interface TMAddRecordViewController : UIViewController <UITextFieldDelegate>
{
    NSDate *beginTime;
    int32_t duration;
    __weak IBOutlet UITextField *beginTimeField;
    __weak IBOutlet UITextField *durationField;
}

@property (nonatomic, strong) TMTask *task;

- (id)initWithTask:(TMTask *)aTask;

@end
