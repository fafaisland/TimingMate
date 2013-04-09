//
//  TMRunningRecord.h
//  TimingMate
//
//  Created by Long Wei on 4/8/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMRunningRecord : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *recordBeginTime;
@property (nonatomic, strong) NSURL *taskURL;

@end
