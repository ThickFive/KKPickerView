//
//  KKPickerView.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

//  参考  https://github.com/xiaozhuxiong121/PGPickerView

#import <UIKit/UIKit.h>
#import "KKPickerConfig.h"
#import "KKPickerTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KKPickerViewDataSource, KKPickerViewDelegate;

#pragma mark - KKPickerView

/**
    KKPickerView 结构示意图, 用 KKPickerConfig 来配置字体, 颜色, 行高, 间距等一系列属性
 
    －　－　－　－ －　－　－　－
    | ☒      KKPickerTitleView     ☑ |
    －　－　－　－ －　－　－　－
    |                    top                       |
    |           －　－　－　－            |
    |           －　－　－　－            |
    |   left   ＋　＋　＋　＋  right   |   ←   KKPIckerView, 包含多个列 KKPickerColumnView
    |           －　－　－　－            |
    |           －　－　－　－            |
    |                  bottom                   |
    －　－　－　－ －　－　－　－
            ↑
    [KKPickerColumnView, ...]   ←       －  KKPickerTableView   每个列由三个重叠的 TableView 组成
                             ＋  KKPickerTableView   (中间高亮)
                             －  KKPickerTableView      ←    KKPickerTableViewCell 0
                                                    KKPickerTableViewCell 1
                                                    KKPickerTableViewCell 2
                                                    KKPickerTableViewCell 3
                                                    KKPickerTableViewCell 4
                                                        ...
 */
@interface KKPickerView : UIView
@property (nonatomic, weak) id<KKPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<KKPickerViewDelegate> delegate;
@property (nonatomic, strong) KKPickerConfig *config;
@property (nonatomic, assign, readonly) NSInteger numberOfComponents;
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
@end

#pragma mark - KKPickerViewDataSource
@protocol KKPickerViewDataSource <NSObject>
@required
- (NSInteger)numberOfComponentsInPickerView:(KKPickerView *)pickerView;
- (NSInteger)numberOfRowsInComponent:(NSInteger)component;
@end

#pragma mark - KKPickerViewDelegate
@protocol KKPickerViewDelegate <NSObject>
- (NSString *)pickerView:(KKPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
@optional
- (NSAttributedString *)pickerView:(KKPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (CGFloat)pickerView:(KKPickerView *)pickerView widthForComponent:(NSInteger)component;
- (void)pickerView:(KKPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

NS_ASSUME_NONNULL_END
