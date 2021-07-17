//
//  KKPickerColumnView.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import "KKPickerColumnView.h"
#import "KKPickerTableView.h"
#import "KKPickerTableViewCell.h"

#define kPickerTableViewCellReuseIdentifier @"KKPickerTableViewCellReuseIdentifier"

@interface KKPickerColumnView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) KKPickerTableView *topTableView;
@property (nonatomic, strong) KKPickerTableView *centerTableView;
@property (nonatomic, strong) KKPickerTableView *bottomTableView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSArray<KKPickerTableView *> *tableViewList;
@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation KKPickerColumnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.config = [[KKPickerConfig alloc] init];
        _selectedRow = -1; // 先置为 -1 防止重复点击, 返回时 >= 0 以防快速滑动还没结束动画就点击确定, 避免数组越界
        //  需要在设置 dataSource 后才能获取行数
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupUI];
        });
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.topView];
    [self addSubview:self.centerView];
    [self addSubview:self.bottomView];
    
    [self.topView addSubview:self.topTableView];
    [self.centerView addSubview:self.centerTableView];
    [self.bottomView addSubview:self.bottomTableView];
    
    [self.centerView addSubview:self.topLine];
    [self.centerView addSubview:self.bottomLine];
    
    self.tableViewList = @[self.topTableView, self.centerTableView, self.bottomTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _config.index * _config.rowHeight);
    self.centerView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.frame), _config.rowHeight);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.centerView.frame), CGRectGetWidth(self.frame), (_config.rows - 1 - _config.index) * _config.rowHeight);
    
    self.topTableView.frame = self.topView.bounds;
    self.centerTableView.frame = self.centerView.bounds;
    self.bottomTableView.frame = self.bottomView.bounds;
    
    self.topLine.frame = CGRectMake(_config.lineMargin, 0, CGRectGetWidth(self.frame) - _config.lineMargin * 2, 0.5f);
    self.bottomLine.frame = CGRectMake(_config.lineMargin, CGRectGetHeight(self.centerView.frame) - 0.5f, CGRectGetWidth(self.frame) - _config.lineMargin * 2, 0.5f);
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    //  初始化错误偏移修正
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomTableView setContentOffset:CGPointMake(0, 0.0f) animated:NO];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomTableView setContentOffset:CGPointMake(0, self->_config.rowHeight) animated:NO];
    });
}

#pragma mark - Actions
- (void)reloadData {
    [self.topTableView reloadData];
    [self.centerTableView reloadData];
    [self.bottomTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<NSIndexPath *> *indexPaths = [self.centerTableView indexPathsForVisibleRows] ?: @[];
        if (indexPaths.count > 1) {
            //  滚动居中修正
            NSLog(@"滚动居中修正 IndexPathsForVisibleRows: %@", indexPaths);
            [self selectRow:indexPaths[0].row animated:YES];
        } else if (indexPaths.count > 0) {
            [self didSelectRow:indexPaths[0].row];
        } else {
            NSLog(@"[KKPickerColumnView reloadData] 可能当前列无数据");
        }
    });
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    [self.centerTableView setContentOffset:CGPointMake(0, row * _config.rowHeight) animated:animated];
    [self didSelectRow:row];
}

- (NSInteger)selectedRow {
    return _selectedRow < 0 ? 0 : _selectedRow;
}

- (void)didSelectRow:(NSInteger)row {
    if (_selectedRow == row) {
        return;
    }
    _selectedRow = row;
    if ([self.delegate respondsToSelector:@selector(columnView:didSelectRow:)]) {
        [self.delegate columnView:self didSelectRow:row];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsInColumnView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[KKPickerTableViewCell class] forCellReuseIdentifier:kPickerTableViewCellReuseIdentifier];
    KKPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPickerTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (tableView == self.centerTableView) {
        cell.titleLabel.textColor = _config.tintColor;
    } else {
        cell.titleLabel.textColor = _config.textColor;
    }
    cell.titleLabel.textAlignment = _config.textAlignment;
    cell.titleLabel.font = _config.textFont;
    cell.titleLabel.text = [self.delegate columnView:self titleForRow:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _config.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.centerTableView setContentOffset:CGPointMake(0, indexPath.item * _config.rowHeight) animated:YES];
    [self didSelectRow:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //  同步三个 Tableview 的偏移值
    CGFloat y = scrollView.contentOffset.y;
    if (scrollView == self.topTableView) {
        self.centerTableView.contentOffset = CGPointMake(0, y + _config.index * _config.rowHeight);
        self.bottomTableView.contentOffset = CGPointMake(0, y + (_config.index + 1) * _config.rowHeight);
    }
    if (scrollView == self.centerTableView) {
        self.topTableView.contentOffset = CGPointMake(0, y - _config.index * _config.rowHeight);
        self.bottomTableView.contentOffset = CGPointMake(0, y + _config.rowHeight);
    }
    if (scrollView == self.bottomTableView) {
        self.topTableView.contentOffset = CGPointMake(0, y - (_config.index + 1) * _config.rowHeight);
        self.centerTableView.contentOffset = CGPointMake(0, y - _config.rowHeight);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //  设置滚动居中
    CGFloat y = MAX(targetContentOffset->y, -_config.rowHeight * _config.index);
    NSInteger row = floor(y / _config.rowHeight + 0.5);
    targetContentOffset->y = row * _config.rowHeight;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger row = round(scrollView.contentOffset.y / _config.rowHeight + 0.0);
    if (scrollView == self.topTableView) {
        row = row + _config.index;
    }
    if (scrollView == self.bottomTableView) {
        row = row - 1;
    }
    //  防止越界
    NSInteger lower = 0;
    NSInteger upper = MAX(0, [self.dataSource numberOfRowsInColumnView:self] - 1);
    if (row < lower) {
        row = lower;
    }
    if (row > upper) {
        row = upper;
    }
    //  滚动回弹修正
    CGFloat y = row * _config.rowHeight;
    [self.centerTableView setContentOffset:CGPointMake(0, y) animated:YES];
    //  滚动结束选中事件回调
    [self didSelectRow:row];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - Getter && Setter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.clipsToBounds = YES;
    }
    return _topView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _topView.clipsToBounds = YES;
    }
    return _centerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _topView.clipsToBounds = YES;
    }
    return _bottomView;
}

- (KKPickerTableView *)topTableView {
    if (!_topTableView) {
        _topTableView = [[KKPickerTableView alloc] init];
        CGFloat top = _config.index * _config.rowHeight;
        CGFloat bottom = -_config.rowHeight;
        self.topTableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        _topTableView.dataSource = self;
        _topTableView.delegate = self;
    }
    return _topTableView;
}

- (KKPickerTableView *)centerTableView {
    if (!_centerTableView) {
        _centerTableView = [[KKPickerTableView alloc] init];
        _centerTableView.dataSource = self;
        _centerTableView.delegate = self;
    }
    return _centerTableView;
}

- (KKPickerTableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[KKPickerTableView alloc] init];
        CGFloat top = -_config.rowHeight;
        CGFloat bottom = _config.rowHeight * (_config.rows - 1 - _config.index);
        _bottomTableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        _bottomTableView.dataSource = self;
        _bottomTableView.delegate = self;
    }
    return _bottomTableView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = _config.tintColor;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = _config.tintColor;
    }
    return _bottomLine;
}

@end
