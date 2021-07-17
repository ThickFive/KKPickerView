//
//  KKDatePicker.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/4.
//

#import "KKPickerViewController.h"
#import "NSDate+KKPicker.h"

/**
    时间选择器模式,  可以是任意连续的组合, 共 21 种, 范围在 [1, 21] 之间
 */
typedef NS_ENUM(NSInteger, KKDatePickerMode) {
    //  基本单元 6 种, 年月日时分秒
    KKDatePickerModeY       = 1 << 0,
    KKDatePickerModeM       = 1 << 1,
    KKDatePickerModeD       = 1 << 2,
    KKDatePickerModeH       = 1 << 3,
    KKDatePickerModem       = 1 << 4,   // 小写 m 分, 区别于 M 月
    KKDatePickerModeS       = 1 << 5,
    //  组合单元 - 分
    KKDatePickerModeMS      = KKDatePickerModem | KKDatePickerModeS,
    //  组合单元 - 时
    KKDatePickerModeHMS     = KKDatePickerModeH | KKDatePickerModeMS,
    KKDatePickerModeHM      = KKDatePickerModeH | KKDatePickerModem,
    //  组合单元 - 日
    KKDatePickerModeDH      = KKDatePickerModeD | KKDatePickerModeH,
    KKDatePickerModeDHM     = KKDatePickerModeDH | KKDatePickerModem,
    KKDatePickerModeDHMS    = KKDatePickerModeDHM | KKDatePickerModeS,
    //  组合单元 - 月
    KKDatePickerModeMD      = KKDatePickerModeM | KKDatePickerModeD,
    KKDatePickerModeMDH     = KKDatePickerModeMD | KKDatePickerModeH,
    KKDatePickerModeMDHM    = KKDatePickerModeMDH | KKDatePickerModem,
    KKDatePickerModeMDHMS   = KKDatePickerModeMDHM | KKDatePickerModeS,
    //  组合单元 - 年
    KKDatePickerModeYM      = KKDatePickerModeY | KKDatePickerModeM,
    KKDatePickerModeYMD     = KKDatePickerModeYM | KKDatePickerModeD,
    KKDatePickerModeYMDH    = KKDatePickerModeYMD | KKDatePickerModeH,
    KKDatePickerModeYMDHM   = KKDatePickerModeYMDH | KKDatePickerModem,
    KKDatePickerModeYMDHMS  = KKDatePickerModeYMDHM | KKDatePickerModeS,
};

NS_ASSUME_NONNULL_BEGIN

@interface KKDatePicker : KKPickerViewController
/**
    时间选择器模式, 共 21 种选择, 默认为 KKDatePickerModeYMDHM
 */
@property (nonatomic, assign) KKDatePickerMode pickerMode;
/**
    第一次显示的时间, 默认为当前时间 NSDate.now, 不要用它获取选择的时间, 用 selectedDate 回调
 */
@property (nonatomic, strong) NSDate *selectDate;
/**
    可选时间范围最小值, 默认为 0001-01-01 00:00
 */
@property (nonatomic, strong) NSDate *minDate;
/**
    可选时间范围最大值, 默认为 4001-01-01 00:00
 */
@property (nonatomic, strong) NSDate *maxDate;
/**
    获取选择的时间
 */
@property (nonatomic, copy) void (^selectedDate)(NSDateComponents *date);
@end

NS_ASSUME_NONNULL_END
