//
//  KKPickerColumnView.h
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import "KKPickerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KKPickerColumnViewDataSource, KKPickerColumnViewDelegate;

#pragma mark - KKPickerColumnView
@interface KKPickerColumnView : UIView
@property (nonatomic, weak) id<KKPickerColumnViewDataSource> dataSource;
@property (nonatomic, weak) id<KKPickerColumnViewDelegate> delegate;
@property (nonatomic, strong) KKPickerConfig *config;
- (void)reloadData;
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;
- (NSInteger)selectedRow;
@end

#pragma mark - KKPickerColumnViewDataSource
@protocol KKPickerColumnViewDataSource <NSObject>
@required
- (NSInteger)numberOfRowsInColumnView:(KKPickerColumnView *)columnView;
@end

#pragma mark - KKPickerColumnViewDelegate
@protocol KKPickerColumnViewDelegate <NSObject>
- (NSString *)columnView:(KKPickerColumnView *)columnView titleForRow:(NSInteger)row;
@optional
- (NSAttributedString *)columnView:(KKPickerColumnView *)columnView attributedTitleForRow:(NSInteger)row;
- (void)columnView:(KKPickerColumnView *)columnView didSelectRow:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
