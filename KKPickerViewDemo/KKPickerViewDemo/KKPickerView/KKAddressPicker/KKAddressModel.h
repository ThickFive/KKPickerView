//
//  KKAddressModel.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - KKAddressModel
@interface KKAddressModel : NSObject
/**
    编码
 */
@property (nonatomic, copy) NSString *code;
/**
    名称
 */
@property (nonatomic, strong) NSString *name;
/**
    索引
 */
@property (nonatomic, assign) NSInteger index;
@end

#pragma mark - 省
@interface KKProvinceModel : KKAddressModel
/**
    城市数组
 */
@property (nonatomic, copy) NSArray *citylist;
@end

#pragma mark - 市
@interface KKCityModel : KKAddressModel
/**
    地区数组
 */
@property (nonatomic, copy) NSArray *arealist;
@end

#pragma mark - 区
@interface KKAreaModel : KKAddressModel

@end

NS_ASSUME_NONNULL_END
