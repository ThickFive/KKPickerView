//
//  NSDate+KKPicker.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/5.
//

#import "NSDate+KKPicker.h"

@implementation NSDate (KKPicker)

- (NSDate *)dateBeforeDays:(NSInteger)days {
    return [NSDate dateWithTimeInterval:- 24 * 3600 * days sinceDate:self];
}

- (NSDate *)dateOfLastDay {
    NSDate *day = [NSDate dateWithTimeIntervalSinceNow: - 24 * 3600];
    NSDateComponents *components = [NSCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:day];
    return [NSDate dateOfYear:components.year month:components.month day:components.day];
}

- (NSDate *)dateOfLastYear {
    NSInteger year = [NSCalendar component:NSCalendarUnitYear fromDate:self];
    return [NSDate dateOfYear: year - 1];
}

+ (NSDate *)dateOfYear:(NSInteger)year {
    return [self dateOfYear:year month:1 day:1 hour:0 minute:0 second:0];
}

+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month {
    return [self dateOfYear:year month:month day:1 hour:0 minute:0 second:0];
}

+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self dateOfYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    return [self dateOfYear:year month:month day:day hour:hour minute:0 second:0];
}

+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self dateOfYear:year month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar shared];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

@end
