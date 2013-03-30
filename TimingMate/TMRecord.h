//
//  TMRecord.h
//  TimingMate
//
//  Created by easonfafa on 3/22/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TMTask;

@interface TMRecord : NSManagedObject

@property (nonatomic, retain) NSDate * beginTime;
@property (nonatomic) int32_t timeSpent;
@property (nonatomic, retain) TMTask *task;

-(NSString *)getDateDay;
@end
