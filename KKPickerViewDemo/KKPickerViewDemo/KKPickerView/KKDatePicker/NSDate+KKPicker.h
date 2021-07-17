//
//  NSDate+KKPicker.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/5.
//

#import <Foundation/Foundation.h>
#import "NSCalendar+KKPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (KKPicker)
- (NSDate *)dateBeforeDays:(NSInteger)days;
- (NSDate *)dateOfLastDay;  //  e.g. 2021-02-05 10:23:05 ->  2021-02-04 00:00:00
- (NSDate *)dateOfLastYear; //  e.g. 2021-02-05 10:23:05 ->  2020-01-01 00:00:00
+ (NSDate *)dateOfYear:(NSInteger)year;
+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month;
+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;
+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)dateOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
@end

NS_ASSUME_NONNULL_END
