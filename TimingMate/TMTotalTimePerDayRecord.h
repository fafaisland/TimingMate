//
//  TMTotalTimePerDayRecord.h
//  TimingMate
//
//  Created by easonfafa on 3/28/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMTotalTimePerDayRecord : NSObject

@property (nonatomic, retain) NSString * someDay;
@property (nonatomic) int32_t totalTimeInSeconds;

- (id)initWithSomeDay:(NSString *)day withSeconds:(int32_t)seconds;
- (void)addTimeInSeconds:(int32_t)seconds;
@end
