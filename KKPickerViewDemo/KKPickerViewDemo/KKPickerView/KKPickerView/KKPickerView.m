//
//  KKPickerView.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import "KKPickerView.h"
#import "KKPickerColumnView.h"

@interface KKPickerView () <KKPickerColumnViewDataSource, KKPickerColumnViewDelegate>
@property (nonatomic, strong) NSArray<KKPickerColumnView *> *columnList;
@end

@implementation KKPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.config = [[KKPickerConfig alloc] init];
        //  需要在设置 dataSource 后才能获取列数
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupUI];
        });
    }
    return self;
}

- (void)setupUI {
    NSInteger count = [self.dataSource numberOfComponentsInPickerView:self];
    _numberOfComponents = count;
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        KKPickerColumnView *columnView = [[KKPickerColumnView alloc] init];
        columnView.dataSource = self;
        columnView.delegate = self;
        columnView.config = self.config.copy;
        //  实现两端文字与边对齐
        if (columnView.config.type == KKPickerViewTypeJustify && count > 1) {
            if (i == 0) {
                columnView.config.textAlignment = NSTextAlignmentLeft;
            } else if (i == count - 1) {
                columnView.config.textAlignment = NSTextAlignmentRight;
            }
        }
        [self addSubview:columnView];
        [mArr addObject:columnView];
    }
    self.columnList = mArr.copy;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets padding = _config.padding;
    NSInteger count = self.columnList.count;
    CGFloat x = padding.left;
    CGFloat y = padding.top;
    CGFloat w = (self.frame.size.width - padding.left - padding.right) / count;
    CGFloat h = (self.frame.size.height - padding.top - padding.bottom);
    for (int i = 0; i < count; i++) {
        KKPickerColumnView *columnView = self.columnList[i];
        columnView.frame = CGRectMake(x, y, w, h);
        x += w;
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
}

#pragma mark - <#title#>
- (void)reloadAllComponents {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.columnList = @[];
    [self setupUI];
}

- (void)reloadComponent:(NSInteger)component {
    if (component < self.columnList.count) {
        [self.columnList[component] reloadData];
    } else {
        NSLog(@"Component %zd not exists", component);
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    if (component < self.columnList.count) {
        [self.columnList[component] selectRow:row animated:animated];
    } else {
        NSLog(@"Component %zd not exists", component);
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    if (component < self.columnList.count) {
        return [self.columnList[component] selectedRow];
    } else {
        NSLog(@"Component %zd not exists", component);
        return -1;
    }
}

#pragma mark - KKPickerColumnViewDataSource, KKPickerColumnViewDelegate
- (NSInteger)numberOfRowsInColumnView:(KKPickerColumnView *)columnView {
    return [self.dataSource numberOfRowsInComponent:[self componentOfColumnView:columnView]];
}

- (NSString *)columnView:(KKPickerColumnView *)columnView titleForRow:(NSInteger)row {
    return [self.delegate pickerView:self titleForRow:row forComponent:[self componentOfColumnView:columnView]];
}

- (void)columnView:(KKPickerColumnView *)columnView didSelectRow:(NSInteger)row {
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:[self componentOfColumnView:columnView]];
    }
}

- (NSInteger)componentOfColumnView:(KKPickerColumnView *)columnView {
    NSInteger count = self.columnList.count;
    for (int i = 0; i < count; i++) {
        if (columnView == self.columnList[i]) {
            return i;
        }
    }
    return 0;
}

- (NSArray<KKPickerColumnView *> *)columnList {
    if (!_columnList) {
        _columnList = @[];
    }
    return _columnList;
}

@end
