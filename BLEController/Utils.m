//
//  Utils.m
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)pickRandomValue:(NSArray *)values{
    
    int max = (int)values.count;
    int random = arc4random() % max;
    return [NSString stringWithFormat:@"%@", [values objectAtIndex:random]];
    
}

+ (NSDateComponents *)getInfoDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSDate *date = [NSDate new];
    
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_PE"];
    [dateFormatter setLocale:frLocale];    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:date];
    return components;
}

+ (NSString *)getFullTextDate{
    NSDateComponents *components = [self getInfoDate];
    NSString *month = [self getMonthText:[components month]];
    return [NSString stringWithFormat:@"Hoy,%d de %@", [components day], month];
}

+ (NSString *)getDayTextDate{
    NSDateComponents *components = [self getInfoDate];
    return [NSString stringWithFormat:@"%d", [components day]];
}

+ (NSString *)getMonthShortTextDate{
    NSDateComponents *components = [self getInfoDate];
    return [self getMonthShortText: [components month]];
}

+ (NSString *)getMonthText:(int)number{
    NSString *month;
    switch (number) {
        case 1:
            month = @"Enero";
            break;
        case 2:
            month = @"Febrero";
            break;
        case 3:
            month = @"Marzo";
            break;
        case 4:
            month = @"Abril";
            break;
        case 5:
            month = @"Mayo";
            break;
        case 6:
            month = @"Junio";
            break;
        case 7:
            month = @"Julio";
            break;
        case 8:
            month = @"Agosto";
            break;
        case 9:
            month = @"Septiembre";
            break;
        case 10:
            month = @"Octubre";
            break;
        case 11:
            month = @"Noviembre";
            break;
        case 12:
            month = @"Diciembre";
            break;
        default:
            break;
    }
    return month;
}

+ (NSString *)getMonthShortText:(int)number{
    NSString *month = [self getMonthText:number];
    if ([month length] > 3) {
        month = [[month substringToIndex:3] uppercaseString];
    }
    return month;
}

+ (int)numberOfHoursToday{
    NSDateComponents *components = [self getInfoDate];
    int hours = (int)[components hour];
    return hours;
}

@end
