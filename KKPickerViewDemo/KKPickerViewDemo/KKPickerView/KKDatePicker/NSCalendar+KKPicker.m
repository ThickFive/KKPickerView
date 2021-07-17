//
//  NSCalendar+KKPicker.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/5.
//

#import "NSCalendar+KKPicker.h"

@implementation NSCalendar (KKPicker)

static NSCalendar *_shardInstance;

+ (NSCalendar *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shardInstance = [NSCalendar currentCalendar];
    });
    return _shardInstance;
}

+ (NSInteger)component:(NSCalendarUnit)unit fromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar shared];
    return [calendar component:unit fromDate:date];
}

+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar shared];
    return [calendar components:unitFlags fromDate:date];
}

+ (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar shared];
    return [calendar rangeOfUnit:smaller inUnit:larger forDate:date];
}

@end
