//
//  ViewController.m
//  KKPickerViewDemo
//
//  Created by tonghang on 2021/7/17.
//

#import "ViewController.h"
#import "KKPickerView.h"
#import "KKPickerTitleView.h"
#import "KKPickerViewController.h"
#import "KKDatePicker.h"
#import "KKAddressPicker.h"

@interface ViewController () <KKPickerViewDataSource, KKPickerViewDelegate, KKPickerTitleViewDelegate>
@property (nonatomic, strong) KKPickerView *pickerView;
@property (nonatomic, strong) KKPickerTitleView *titleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.titleView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.pickerView.frame = CGRectMake(0, 20, 200, 200);
    self.pickerView.frame = self.view.bounds;
    self.titleView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 50.0f);
}

#pragma mark - KKPickerViewDataSource, KKPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(KKPickerView *)pickerView {
    return 5;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    return component + 5;
}

- (NSString *)pickerView:(KKPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%zd-%zd", component, row];
}

- (void)pickerView:(KKPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"KKPickerView did select row at %zd-%zd", component, row);
}

#pragma mark - KKPickerTitleViewDelegate
- (void)titleView:(KKPickerTitleView *)titleView didClickCancelButton:(UIButton *)sender {
    NSLog(@"KKPickerTitleView 点击取消");
    do {
        KKDatePicker *picker = [[KKDatePicker alloc] init];
        picker.pickerMode = KKDatePickerModeYMDHM;
        picker.minDate = [NSDate dateOfYear:2021 month:05 day:23 hour:12 minute:05 second:9];
        picker.maxDate = [NSDate dateOfYear:2021 month:11 day:04 hour:02 minute:21 second:3];
        picker.selectedDate = ^(NSDateComponents * _Nonnull date) {
            NSLog(@"%@", date);
        };
        picker.pickerView.config.index = 2;
        [picker show];
    } while(NO);
}

- (void)titleView:(KKPickerTitleView *)titleView didClickConfirmButton:(UIButton *)sender {
    NSLog(@"KKPickerTitleView 点击确认");
    do {
        KKAddressPicker *picker = [[KKAddressPicker alloc] init];
        picker.pickerMode = KKAddressPickerModeArea;
//        picker.pickerMode = KKAddressPickerModeCity;
//        picker.pickerMode = KKAddressPickerModeProvince;
        picker.selectedAddress = ^(KKProvinceModel * _Nullable province, KKCityModel * _Nullable city, KKAreaModel * _Nullable area) {
            NSLog(@"%@ - %@ - %@", province.name, city.name, area.name);
        };
        picker.pickerView.config.index = 1;
        [picker show];
    } while(NO);
}

- (KKPickerView *)pickerView {
    if (!_pickerView) {
        KKPickerConfig *config = [[KKPickerConfig alloc] init];
        config.type = KKPickerViewTypeDefault;
        config.rowHeight = 44;
        config.rows = 5;
        config.index = 1;
        config.padding = UIEdgeInsetsMake(150, 36, 150, 36);
        
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
        config.title = @"自定义标题";
        _titleView = [[KKPickerTitleView alloc] init];
        _titleView.delegate = self;
//        _titleView.config.title = config;
        _titleView.config.title = @"自定义标题";
    }
    return _titleView;
}

@end
