//
//  KKPickerViewController.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/4.
//

#import "KKPickerViewController.h"

@interface KKPickerViewController ()
@property (nonatomic, strong) UIButton *tapButton;  //  Tap 手势会导致 TableViewCell 无法点击, 因此改用按钮来实现
@end

@implementation KKPickerViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    [self.view addSubview:self.tapButton];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.titleView];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    //  修复 iOS 14 消失动画起始位置的问题
    KKPickerConfig *config = self.pickerView.config;
    CGFloat titleHeight = 50.f;
    CGFloat pickerHeight = config.rows * config.rowHeight + config.padding.top + config.padding.bottom;
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat totalHeight = titleHeight + pickerHeight + bottom;
    
    self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), width, totalHeight);
    self.titleView.frame = CGRectMake(0, 0, width, titleHeight);
    self.pickerView.frame =  CGRectMake(0, titleHeight, width, pickerHeight);
    self.tapButton.frame = CGRectMake(0, 0, width, CGRectGetMinY(self.contentView.frame));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showPickerView];
    });
}

#pragma mark - KKPickerViewDataSource, KKPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(KKPickerView *)pickerView {
    return self.data.count;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    return self.data[component].count;
}

- (NSString *)pickerView:(KKPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.data[component][row];
}

- (void)pickerView:(KKPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //  
}

#pragma mark - KKPickerTitleViewDelegate
- (void)titleView:(KKPickerTitleView *)titleView didClickCancelButton:(UIButton *)sender {
    [self dismissPickerView];
}

- (void)titleView:(KKPickerTitleView *)titleView didClickConfirmButton:(UIButton *)sender {
    NSInteger count = self.pickerView.numberOfComponents;
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:i];
        [mArr addObject:@(selectedRow)];
    }
    if (self.selectedRows) {
        self.selectedRows(mArr.copy);
    }
    [self dismissPickerView];
}

#pragma mark - Actions
- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:self animated:YES completion:nil];
}

- (void)tapAction:(UIButton *)sender {
    [self dismissPickerView];
}

- (void)showPickerView {
    [UIView animateWithDuration:0.25 animations:^{
        CGSize size = self.contentView.frame.size;
        self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - size.height, size.width, size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissPickerView {
    [UIView animateWithDuration:0.25 animations:^{
        CGSize size = self.contentView.frame.size;
        self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), size.width, size.height);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Getter && Setter
- (UIButton *)tapButton {
    if (!_tapButton) {
        _tapButton = [[UIButton alloc] init];
        [_tapButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (KKPickerView *)pickerView {
    if (!_pickerView) {
        KKPickerConfig *config = [[KKPickerConfig alloc] init];
        config.padding = UIEdgeInsetsMake(0, 36, 0, 36);
        
        _pickerView = [[KKPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.config = config;
    }
    return _pickerView;
}

- (KKPickerTitleView *)titleView {
    if (!_titleView) {
        KKPickerConfig *config = [[KKPickerConfig alloc] init];
        config.title = @"请选择";
        
        _titleView = [[KKPickerTitleView alloc] init];
        _titleView.delegate = self;
        _titleView.config = config;
    }
    return _titleView;
}

@end
