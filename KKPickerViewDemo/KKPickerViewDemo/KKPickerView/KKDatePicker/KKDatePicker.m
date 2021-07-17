//
//  KKDatePicker.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/4.
//

/*
    时间范围的确定方式, T 表示时间戳, 分别用指定 年/月/日/时/分 初/尾的时间戳与 minDate/maxDate 比较, 
    e.g. M T12 表示指定年 Y-12-1 00:00 的时间戳
    Y = [Y(min), Y(max)]
    M = [T1 > Tmin ? 1 : M(min), T12 < Tmax ? 12 : M(max)]
    D = [T1 > Tmin ? 1 : D(min), T28-31 < Tmax ? 28-31 : D(max)]
    以此类推 ...
 */

#import "KKDatePicker.h"

@interface KKDatePicker ()
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) NSArray<NSNumber *> *years;
@property (nonatomic, strong) NSArray<NSNumber *> *months;
@property (nonatomic, strong) NSArray<NSNumber *> *days;
@property (nonatomic, strong) NSArray<NSNumber *> *hours;
@property (nonatomic, strong) NSArray<NSNumber *> *minutes;
@property (nonatomic, strong) NSArray<NSNumber *> *seconds;
@property (nonatomic, assign) NSInteger minUnit;    // 最小单位 年-0 月-1 日-2 时-3 分-4 秒-5
@property (nonatomic, assign) NSInteger maxUnit;    // 最大单位 年-0 月-1 日-2 时-3 分-4 秒-5
@end

@implementation KKDatePicker

- (instancetype)init {
    if (self = [super init]) {
        self.pickerMode = KKDatePickerModeYMDHM;    // 默认值
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    self.selectedRows = ^(NSArray<NSNumber *> * _Nonnull rows) {
        for (NSInteger i = 0; i < rows.count; i ++) {
            NSInteger unit = i + weakSelf.minUnit;
            switch (unit) {
                case 0: weakSelf.year = weakSelf.years[rows[i].integerValue].integerValue; break;
                case 1: weakSelf.month = weakSelf.months[rows[i].integerValue].integerValue; break;
                case 2: weakSelf.day = weakSelf.days[rows[i].integerValue].integerValue; break;
                case 3: weakSelf.hour = weakSelf.hours[rows[i].integerValue].integerValue; break;
                case 4: weakSelf.minute = weakSelf.minutes[rows[i].integerValue].integerValue; break;
                case 5: weakSelf.second = weakSelf.seconds[rows[i].integerValue].integerValue; break;
                default: break;
            }
        }
    };
    //  初始化选择范围, 设置默认显示日期
    [self initSelectedDate];
}

- (void)initSelectedDate {
    NSDateComponents *components = [NSCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self.selectDate];
    
    switch (self.minUnit) { // fallthrougth whitout break;
        case 5: self.minute = components.minute; self.minutes = @[@(components.minute)];
        case 4: self.hour = components.hour; self.hours = @[@(components.hour)];
        case 3: self.month = components.month; self.months = @[@(components.month)];
        case 2: self.day = components.day; self.days = @[@(components.day)];
        case 1: self.year = components.year; self.years = @[@(components.year)];
        default: break;
    }
    
    //  必须
    [self reloadDateComponents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger indexYear = components.year - self.years[0].integerValue;
        [self selectRow:indexYear inUnit:0 animated:NO];
        NSInteger indexMonth = components.month - self.months[0].integerValue;
        [self selectRow:indexMonth inUnit:1 animated:NO];
        NSInteger indexDay = components.day - self.days[0].integerValue;
        [self selectRow:indexDay inUnit:2 animated:NO];
        NSInteger indexHour = components.hour - self.hours[0].integerValue;
        [self selectRow:indexHour inUnit:3 animated:NO];
        NSInteger indexMinute = components.minute - self.minutes[0].integerValue;
        [self selectRow:indexMinute inUnit:4 animated:NO];
        NSInteger indexSecond = components.second - self.seconds[0].integerValue;
        [self selectRow:indexSecond inUnit:5 animated:NO];
    });
}

- (void)reloadDateComponents {
    NSArray *years = [self getYears];
    NSArray *months = [self getMonths];
    NSArray *days = [self getDays];
    NSArray *hours = [self getHours];
    NSArray *minutes = [self getMinutes];
    NSArray *seconds = [self getSeconds];
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (NSInteger i = self.minUnit; i <= self.maxUnit; i++) {
        switch (i) {
            case 0: [mArr addObject:years]; break;
            case 1: [mArr addObject:months]; break;
            case 2: [mArr addObject:days]; break;
            case 3: [mArr addObject:hours]; break;
            case 4: [mArr addObject:minutes]; break;
            case 5: [mArr addObject:seconds]; break;
            default: break;
        }
    }
    self.data = mArr.copy;
}

- (NSArray<NSString *> *)getYears {
    NSInteger min = [NSCalendar component:NSCalendarUnitYear fromDate:self.minDate];
    NSInteger max = [NSCalendar component:NSCalendarUnitYear fromDate:self.maxDate];
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    NSMutableArray *mArrN = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++) {
        [mArrS addObject:[NSString stringWithFormat:@"%zd年", i]];
        [mArrN addObject:@(i)];
    }
    self.years = mArrN.copy;
    return mArrS.copy;
}

- (NSArray<NSString *> *)getMonths {
    NSDate *date01 = [NSDate dateOfYear:self.year month:1 day:1 hour:0 minute:0];
    NSDate *date12 = [NSDate dateOfYear:self.year month:12 day:1 hour:0 minute:0];
    NSInteger min = [date01 compare:self.minDate] == NSOrderedDescending ? 1 : [NSCalendar component:NSCalendarUnitMonth fromDate:self.minDate];
    NSInteger max = [date12 compare:self.maxDate] == NSOrderedAscending ? 12 : [NSCalendar component:NSCalendarUnitMonth fromDate:self.maxDate];
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    NSMutableArray *mArrN = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++) {
        [mArrS addObject:[NSString stringWithFormat:@"%zd月", i]];
        [mArrN addObject:@(i)];
    }
    self.months = mArrN.copy;
    return mArrS.copy;
}

- (NSArray<NSString *> *)getDays {
    NSDate *date01 = [NSDate dateOfYear:self.year month:self.month day:1 hour:0 minute:0];
    NSInteger day = [NSCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date01].length;
    NSDate *date12 = [NSDate dateOfYear:self.year month:self.month day:day hour:0 minute:0];
    NSInteger min = [date01 compare:self.minDate] == NSOrderedDescending ? 1 : [NSCalendar component:NSCalendarUnitDay fromDate:self.minDate];
    NSInteger max = [date12 compare:self.maxDate] == NSOrderedAscending ? day : [NSCalendar component:NSCalendarUnitDay fromDate:self.maxDate];
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    NSMutableArray *mArrN = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++) {
        [mArrS addObject:[NSString stringWithFormat:@"%zd日", i]];
        [mArrN addObject:@(i)];
    }
    self.days = mArrN.copy;
    return mArrS.copy;
}

- (NSArray<NSString *> *)getHours {
    NSDate *date01 = [NSDate dateOfYear:self.year month:self.month day:self.day hour:0 minute:0];
    NSDate *date12 = [NSDate dateOfYear:self.year month:self.month day:self.day hour:23 minute:0];
    NSInteger min = [date01 compare:self.minDate] == NSOrderedDescending ? 0 : [NSCalendar component:NSCalendarUnitHour fromDate:self.minDate];
    NSInteger max = [date12 compare:self.maxDate] == NSOrderedAscending ? 23 : [NSCalendar component:NSCalendarUnitHour fromDate:self.maxDate];
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    NSMutableArray *mArrN = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++) {
        [mArrS addObject:[NSString stringWithFormat:@"%zd时", i]];
        [mArrN addObject:@(i)];
    }
    self.hours = mArrN.copy;
    return mArrS.copy;
}

- (NSArray<NSString *> *)getMinutes {
    NSDate *date01 = [NSDate dateOfYear:self.year month:self.month day:self.day hour:self.hour minute:0];
    NSDate *date12 = [NSDate dateOfYear:self.year month:self.month day:self.day hour:self.hour minute:59];
    NSInteger min = [date01 compare:self.minDate] == NSOrderedDescending ? 0 : [NSCalendar component:NSCalendarUnitMinute fromDate:self.minDate];
    NSInteger max = [date12 compare:self.maxDate] == NSOrderedAscending ? 59 : [NSCalendar component:NSCalendarUnitMinute fromDate:self.maxDate];
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    NSMutableArray *mArrN = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++) {
        [mArrS addObject:[NSString stringWithFormat:@"%zd分", i]];
        [mArrN addObject:@(i)];
    }
    self.minutes = mArrN.copy;
    return mArrS.copy;
}

- (NSArray<NSString *> *)getSeconds {
    NSDate *date01 = [NSDate dateOfYear:self.year month:self.month day:self.day hour:self.hour minute:self.minute second:0];
    NSDate *date12 = [NSDate dateOfYear:self.year month:self.month day:self.day hour:self.hour minute:self.minute second:59];
    NSInteger min = [date01 compare:self.minDate] == NSOrderedDescending ? 0 : [NSCalendar component:NSCalendarUnitSecond fromDate:self.minDate];
    NSInteger max = [date12 compare:self.maxDate] == NSOrderedAscending ? 59 : [NSCalendar component:NSCalendarUnitSecond fromDate:self.maxDate];
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    NSMutableArray *mArrN = [[NSMutableArray alloc] init];
    for (NSInteger i = min; i <= max; i++) {
        [mArrS addObject:[NSString stringWithFormat:@"%zd秒", i]];
        [mArrN addObject:@(i)];
    }
    self.seconds = mArrN.copy;
    return mArrS.copy;
}

#pragma mark - KKPickerViewDelegate, KKPickerViewDataSource(数据源方法直接继承自 KKPickerViewController)
- (void)pickerView:(KKPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger unit = component + self.minUnit;
    switch (unit) {
        case 0:
        {
            if (row < 0 || row >= self.years.count) return;
            self.year = self.years[row].integerValue;
            [self reloadDateComponents:component];
        }
            break;
        case 1:
        {
            if (row < 0 || row >= self.months.count) return;
            self.month = self.months[row].integerValue;
            [self reloadDateComponents:component];
        }
            break;
        case 2:
        {
            if (row < 0 || row >= self.days.count) return;
            self.day = self.days[row].integerValue;
            [self reloadDateComponents:component];
        }
            break;
        case 3:
        {
            if (row < 0 || row >= self.hours.count) return;
            self.hour = self.hours[row].integerValue;
            [self reloadDateComponents:component];
        }
            break;
        case 4:
        {
            if (row < 0 || row >= self.minutes.count) return;
            self.minute = self.minutes[row].integerValue;
            [self reloadDateComponents:component];
        }
            break;
        case 5:
        {
            if (row < 0 || row >= self.seconds.count) return;
            self.second = self.seconds[row].integerValue;
        }
            break;
        default:
            break;
    }
}

- (void)reloadDateComponents:(NSInteger)component {
    [self reloadDateComponents];
    //  更新后面所有列
    for (NSInteger i = component + 1; i <= self.maxUnit - self.minUnit; i++) {
        [self.pickerView reloadComponent:i];
    }
}

- (void)selectRow:(NSInteger)row inUnit:(NSInteger)unit animated:(BOOL)animated {
    NSInteger component = unit - self.minUnit;
    if (component < 0 || component > self.maxUnit - self.minUnit) return;
    [self.pickerView selectRow:row inComponent:component animated:animated];
}

#pragma mark - KKPickerTitleViewDelegate
- (void)titleView:(KKPickerTitleView *)titleView didClickConfirmButton:(UIButton *)sender {
    [super titleView:titleView didClickConfirmButton:sender];
    if (self.selectedDate) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = self.year;
        components.month = self.month;
        components.day = self.day;
        components.hour = self.hour;
        components.minute = self.minute;
        components.second = self.second;
        self.selectedDate(components);
    }
}

#pragma mark - Getter && Setter
- (NSDate *)minDate {
    if (!_minDate) {
        _minDate = [NSDate dateOfYear:1];
    }
    return _minDate;
}

- (NSDate *)maxDate {
    if (!_maxDate) {
        _maxDate = [NSDate dateOfYear:4001];
    }
    return _maxDate;
}

- (NSDate *)selectDate {
    if (!_selectDate) {
        _selectDate = [NSDate date];
    }
    return _selectDate;
}

- (void)setPickerMode:(KKDatePickerMode)pickerMode {
    _pickerMode = pickerMode;
    for (NSInteger i = 0; i < 6; i++) {
        if ((pickerMode & 1 << i) > 0) {
            self.minUnit = i;
            break;
        }
    }
    for (NSInteger i = 0; i < 6; i++) {
        if ((pickerMode & 1 << i) > 0) {
            self.maxUnit = i;
        }
    }
}

@end
