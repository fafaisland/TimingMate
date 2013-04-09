//
//  TMTopBarViewController.h
//  TimingMate
//
//  Created by Long Wei on 4/4/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TMTimerListener.h"

@interface TMTopBarViewController : UIViewController <TMTimerListener>
{
    IBOutlet UILabel *label;
    UITapGestureRecognizer * tapRecognizer;
}

- (void)setLabelFromElapsedTime;

@end
