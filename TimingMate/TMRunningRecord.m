//
//  TMRunningRecord.m
//  TimingMate
//
//  Created by Long Wei on 4/8/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import "TMRunningRecord.h"

@implementation TMRunningRecord

@synthesize recordBeginTime, taskURL;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.recordBeginTime = [aDecoder decodeObjectForKey:@"recordBeginTime"];
        self.taskURL = [aDecoder decodeObjectForKey:@"taskURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:recordBeginTime forKey:@"recordBeginTime"];
    [aCoder encodeObject:taskURL forKey:@"taskURL"];
}

@end
