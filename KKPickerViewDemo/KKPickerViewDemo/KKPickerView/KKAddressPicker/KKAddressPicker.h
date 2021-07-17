//
//  KKAddressPicker.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/11.
//

//  数据来源 https://github.com/91renb/BRPickerView

#import "KKPickerViewController.h"
#import "KKAddressModel.h"

typedef NS_ENUM(NSInteger, KKAddressPickerMode) {
    KKAddressPickerModeProvince = 1 << 0,                   //  1
    KKAddressPickerModeCity     = 1 << 0 | 1 << 1,          //  3
    KKAddressPickerModeArea     = 1 << 0 | 1 << 1 | 1 << 2  //  7
};

NS_ASSUME_NONNULL_BEGIN

@interface KKAddressPicker : KKPickerViewController
/**
    地址选择器模式, 共 3 种选择
 */
@property (nonatomic, assign) KKAddressPickerMode pickerMode;
/**
    获取选择的地址
 */
@property (nonatomic, copy) void (^selectedAddress)(KKProvinceModel * _Nonnull province, KKCityModel * _Nonnull city, KKAreaModel * _Nonnull area);
@end

NS_ASSUME_NONNULL_END
