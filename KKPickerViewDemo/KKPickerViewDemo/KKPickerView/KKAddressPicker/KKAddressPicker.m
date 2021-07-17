//
//  KKAddressPicker.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/11.
//

#import "KKAddressPicker.h"

@interface KKAddressPicker ()
@property (nonatomic, strong) NSArray *addressModel;
@property (nonatomic, assign) NSInteger province;   //  索引 - 省
@property (nonatomic, assign) NSInteger city;       //  索引 - 市
@property (nonatomic, assign) NSInteger area;       //  索引 - 区
@property (nonatomic, strong) NSArray<KKProvinceModel *> *provinces;
@property (nonatomic, strong) NSArray<KKCityModel *> *citys;
@property (nonatomic, strong) NSArray<KKAreaModel *> *areas;
@property (nonatomic, assign) NSInteger minUnit;    // 最小单位 省-0 市-1 区-2
@property (nonatomic, assign) NSInteger maxUnit;    // 最大单位 省-0 市-1 区-2
@end

@implementation KKAddressPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAddressModel];
    [self reloadAddressComponents];
}

- (void)initAddressModel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KKCity" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *provinceList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //  省
    NSMutableArray *mProvinceArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < provinceList.count; i++) {
        KKProvinceModel *province = [[KKProvinceModel alloc] init];
        province.index = i;
        province.code = [provinceList[i] objectForKey:@"code"];
        province.name = [provinceList[i] objectForKey:@"name"];
        //  市
        NSArray *cityList = [provinceList[i] objectForKey:@"cityList"];
        NSMutableArray *mCityArr = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < cityList.count; j++) {
            KKCityModel *city = [[KKCityModel alloc] init];
            city.index = j;
            city.code = [cityList[j] objectForKey:@"code"];
            city.name = [cityList[j] objectForKey:@"name"];
            //  区
            NSArray *areaList = [cityList[j] objectForKey:@"areaList"];
            NSMutableArray *mAreaArr = [[NSMutableArray alloc] init];
            for (NSInteger k = 0; k < areaList.count; k++) {
                KKAreaModel *area = [[KKAreaModel alloc] init];
                area.index = k;
                area.code = [areaList[k] objectForKey:@"code"];
                area.name = [areaList[k] objectForKey:@"name"];
                [mAreaArr addObject:area];
            }
            city.arealist = mAreaArr.copy;
            [mCityArr addObject:city];
        }
        province.citylist = mCityArr.copy;
        [mProvinceArr addObject:province];
    }
    self.addressModel = mProvinceArr.copy;
}

- (void)reloadAddressComponents {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (NSInteger i = self.minUnit; i <= self.maxUnit; i++) {
        switch (i) {
            case 0: [mArr addObject:[self getProvinces]]; break;
            case 1: [mArr addObject:[self getCitys]]; break;
            case 2: [mArr addObject:[self getAreas]]; break;
            default: break;
        }
    }
    self.data = mArr.copy;
}

- (NSArray<NSString *> *)getProvinces {
    self.provinces = self.addressModel;
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.provinces.count; i++) {
        [mArrS addObject: self.provinces[i].name];
    }
    return mArrS.copy;
}

- (NSArray<NSString *> *)getCitys {
    if (self.province < self.provinces.count) {
        self.citys = self.provinces[self.province].citylist;
    } else {
        self.citys = @[];
    }
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.citys.count; i++) {
        [mArrS addObject: self.citys[i].name];
    }
    return mArrS.copy;
}

- (NSArray<NSString *> *)getAreas {
    if (self.city < self.citys.count) {
        self.areas = self.citys[self.city].arealist;
    } else {
        self.areas = @[];
    }
    NSMutableArray *mArrS = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.areas.count; i++) {
        [mArrS addObject: self.areas[i].name];
    }
    return mArrS.copy;
}

#pragma mark - KKPickerViewDelegate, KKPickerViewDataSource(数据源方法直接继承自 KKPickerViewController)
- (void)pickerView:(KKPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger unit = component + self.minUnit;
    switch (unit) {
        case 0:
        {
            if (row < 0 || row >= self.provinces.count) return;
            self.province = row;
            [self reloadAddressComponents:component];
        }
            break;
        case 1:
        {
            if (row < 0 || row >= self.citys.count) return;
            self.city = row;
            [self reloadAddressComponents:component];
        }
            break;
        case 2:
        {
            if (row < 0 || row >= self.areas.count) return;
            self.area = row;
            [self reloadAddressComponents:component];
        }
            break;
        default:
            break;
    }
}

- (void)reloadAddressComponents:(NSInteger)component {
    [self reloadAddressComponents];
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
    if (self.selectedAddress) {
        KKProvinceModel *province = self.province < self.provinces.count ? self.provinces[self.province] : nil;
        KKCityModel *city = self.city < self.citys.count ? self.citys[self.city] : nil;
        KKAreaModel *area = self.area < self.areas.count ? self.areas[self.area] : nil;
        self.selectedAddress(province, city, area);
    }
}

#pragma mark - Getter && Setter
- (void)setPickerMode:(KKAddressPickerMode)pickerMode {
    _pickerMode = pickerMode;
    for (NSInteger i = 0; i < 3; i++) {
        if ((pickerMode & 1 << i) > 0) {
            self.minUnit = i;
            break;
        }
    }
    for (NSInteger i = 0; i < 3; i++) {
        if ((pickerMode & 1 << i) > 0) {
            self.maxUnit = i;
        }
    }
}

@end
