//
//  NSCalendar+KKPicker.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (KKPicker)
+ (NSCalendar *)shared;
+ (NSInteger)component:(NSCalendarUnit)unit fromDate:(NSDate *)date;
+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date;
+ (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
