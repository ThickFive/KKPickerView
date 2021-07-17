//
//  KKPickerConfig.m
//  KKPickerView
//
//  Created by tonghang on 2021/6/3.
//

#import "KKPickerConfig.h"

@implementation KKPickerConfig

- (instancetype)init {
    if (self = [super init]) {
        #pragma mark - PickerView Config
        self.type = KKPickerViewTypeDefault;
        self.textFont = [UIFont systemFontOfSize:16];
        self.tintColor = [UIColor systemBlueColor];
        self.textColor = [UIColor lightGrayColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.rowHeight = 44.0f;
        self.rows = 5;
        self.index = 1;
        self.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        self.lineMargin = 0;
        
        #pragma mark - TitleView Config
        self.title = @" ";
        self.titleFont = [UIFont systemFontOfSize:18];
        self.buttonFont = [UIFont systemFontOfSize:16];
        self.titleColor = [UIColor blackColor];
        self.cancelButtonColor = [UIColor lightGrayColor];
        self.confirmButtonColor = [UIColor systemBlueColor];
        self.buttonMargin = 20.0f;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    KKPickerConfig *config = [[[self class] allocWithZone:zone] init];
    config.type = self.type;
    config.textFont = self.textFont;
    config.tintColor = self.tintColor;
    config.textColor = self.textColor;
    config.textAlignment = self.textAlignment;
    config.rowHeight = self.rowHeight;
    config.rows = self.rows;
    config.index = self.index;
    config.padding = self.padding;
    config.lineMargin = self.lineMargin;
    config.title = self.title;
    config.titleFont = self.titleFont;
    config.buttonFont = self.buttonFont;
    config.titleColor = self.titleColor;
    config.cancelButtonColor = self.cancelButtonColor;
    config.confirmButtonColor = self.confirmButtonColor;
    config.buttonMargin = self.buttonMargin;
    return config;
}

@end
