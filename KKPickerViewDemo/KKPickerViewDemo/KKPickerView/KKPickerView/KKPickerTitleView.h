//
//  KKPickerTitleView.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import "KKPickerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KKPickerTitleViewDelegate;

@interface KKPickerTitleView : UIView
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, weak) id<KKPickerTitleViewDelegate> delegate;
@property (nonatomic, strong) KKPickerConfig *config;
@property (nonatomic, copy) NSString *title;
@end

@protocol KKPickerTitleViewDelegate <NSObject>

- (void)titleView:(KKPickerTitleView *)titleView didClickCancelButton:(UIButton *)sender;
- (void)titleView:(KKPickerTitleView *)titleView didClickConfirmButton:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
