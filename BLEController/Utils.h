//
//  Utils.h
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString *)pickRandomValue:(NSArray *)values;
+ (NSDateComponents *)getInfoDate;
+ (NSString *)getFullTextDate;
+ (NSString *)getDayTextDate;
+ (NSString *)getMonthShortTextDate;
+ (NSString *)getMonthText:(int)number;
+ (NSString *)getMonthShortText:(int)number;
+ (int)numberOfHoursToday;

@end
