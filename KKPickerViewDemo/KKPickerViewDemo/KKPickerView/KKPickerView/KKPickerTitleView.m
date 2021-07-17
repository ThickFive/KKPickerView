//
//  KKPickerTitleView.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import "KKPickerTitleView.h"

@interface KKPickerTitleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation KKPickerTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.config = [[KKPickerConfig alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupUI];
        });
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat centerY = CGRectGetHeight(self.frame) / 2;
    
    [self.cancelButton sizeToFit];
    CGFloat w1 = CGRectGetWidth(self.cancelButton.frame);
    CGFloat h1 = CGRectGetHeight(self.cancelButton.frame);
    CGFloat x1 = _config.buttonMargin;
    CGFloat y1 = centerY - h1 / 2;
    self.cancelButton.frame = CGRectMake(x1, y1, w1, h1);
    
    [self.confirmButton sizeToFit];
    CGFloat w2 = CGRectGetWidth(self.cancelButton.frame);
    CGFloat h2 = CGRectGetHeight(self.confirmButton.frame);
    CGFloat x2 = CGRectGetWidth(self.frame) - _config.buttonMargin - w2;
    CGFloat y2 = centerY - h2 / 2;
    self.confirmButton.frame = CGRectMake(x2, y2, w2, h2);
    
    self.titleLabel.frame = CGRectMake(x1 + w1, 0, x2 - (x1 + w1), CGRectGetHeight(self.frame));
}

- (void)buttonAction:(UIButton *)sender {
    if (sender == self.cancelButton) {
        if ([self.delegate respondsToSelector:@selector(titleView:didClickCancelButton:)]) {
            [self.delegate titleView:self didClickCancelButton:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(titleView:didClickConfirmButton:)]) {
            [self.delegate titleView:self didClickConfirmButton:sender];
        }
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = _config.titleFont;
        _titleLabel.textColor = _config.titleColor;
        _titleLabel.text = _config.title;
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = _config.buttonFont;
        [_cancelButton setTitleColor:_config.cancelButtonColor forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = _config.buttonFont;
        [_confirmButton setTitleColor:_config.confirmButtonColor forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
