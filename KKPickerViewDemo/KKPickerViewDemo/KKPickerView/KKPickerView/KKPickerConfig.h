//
//  KKPickerConfig.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KKPickerViewType) {
    KKPickerViewTypeDefault = 0,    //  默认文字全部居中
    KKPickerViewTypeJustify         //  两端分散对齐, 适用于大于 1 列的情况, 最好是 2/3 列
};

NS_ASSUME_NONNULL_BEGIN

@interface KKPickerConfig : NSObject <NSCopying>
#pragma mark - PickerView Config
/**
    整体文字对齐类型, 默认每列都居中    | -- A -- | -- B -- | -- C -- |
    设置为 KKPickerViewTypeJustify 后   | A ----- | -- B -- | ----- C |
 */
@property (nonatomic, assign) KKPickerViewType type;
/**
    字体, 默认为 16
 */
@property (nonatomic, strong) UIFont *textFont;
/**
    字体高亮颜色, 默认为 蓝色
 */
@property (nonatomic, strong) UIColor *tintColor;
/**
    字体颜色, 默认为 灰色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
    字体对齐方式, 默认为 NSTextAlignmentCenter
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/**
    行高, 默认为 44
 */
@property (nonatomic, assign) CGFloat rowHeight;
/**
    显示行数, 默认为 5 行
    －　－　－　－
    －　－　－　－
    ＋　＋　＋　＋
    －　－　－　－
    －　－　－　－
 *  rows = 5, index = 2
 */
@property (nonatomic, assign) NSInteger rows;
/**
    居中高亮行索引, 默认为 1 (从 0 开始)
    －　－　－　－
    ＋　＋　＋　＋
    －　－　－　－
    －　－　－　－
 *  rows = 4, index = 1
 */
@property (nonatomic, assign) NSInteger index;
/**
    内边距, 默认为 (top:  0, left: 0, bottom: 0, right: 0)
    －　－　－　－ －　－　－　－
    |                    top                       |
    |           －　－　－　－            |
    |           －　－　－　－            |
    |   left   ＋　＋　＋　＋  right   |            <-----  KKPIckerView
    |           －　－　－　－            |
    |           －　－　－　－            |
    |                  bottom                   |
    －　－　－　－ －　－　－　－
 */
@property (nonatomic, assign) UIEdgeInsets padding;
/**
    分割线左右边距, 默认为 0
 */
@property (nonatomic, assign) CGFloat lineMargin;

#pragma mark - TitleView Config
/**
    标题, 默认为空 " "
 */
@property (nonatomic, copy) NSString *title;
/**
    标题字体, 默认为  18
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
    按钮字体, 默认为 16
 */
@property (nonatomic, strong) UIFont *buttonFont;
/**
    标题颜色, 默认为黑色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
    标题颜色, 默认为灰色
 */
@property (nonatomic, strong) UIColor *cancelButtonColor;
/**
    标题颜色, 默认为蓝色
 */
@property (nonatomic, strong) UIColor *confirmButtonColor;
/**
    按钮左右边距, 默认为 20
    －　－　－　－ －　－　－　－
    | ☒        KKPickerTitleView     ☑ |
    －　－　－　－ －　－　－　－
 */
@property (nonatomic, assign) CGFloat buttonMargin;

@end

NS_ASSUME_NONNULL_END
