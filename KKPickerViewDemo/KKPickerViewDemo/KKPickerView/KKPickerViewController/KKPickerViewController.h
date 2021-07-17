//
//  KKPickerViewController.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "KKPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKPickerViewController : UIViewController <KKPickerViewDataSource, KKPickerViewDelegate, KKPickerTitleViewDelegate>
@property (nonatomic, strong) KKPickerView *pickerView;
@property (nonatomic, strong) KKPickerTitleView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void (^selectedRows)(NSArray<NSNumber *> *rows);
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *data;
- (void)show;
@end

NS_ASSUME_NONNULL_END
