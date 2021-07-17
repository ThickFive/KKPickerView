//
//  KKPickerTableView.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import "KKPickerTableView.h"

@implementation KKPickerTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

@end
