//
//  TMTask.h
//  TimingMate
//
//  Created by Long Wei on 3/17/13.
//  Copyright (c) 2013 TimingMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TMTask : NSManagedObject

@property (nonatomic) double expectedCompletionTime;
@property (nonatomic) BOOL isFinished;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic, retain) NSManagedObject *series;

- (void)setDefaultData;

@end
