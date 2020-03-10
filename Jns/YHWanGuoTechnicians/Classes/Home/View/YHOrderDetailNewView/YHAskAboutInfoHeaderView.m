//
//  YHAskAboutInfoHeaderView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/3.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAskAboutInfoHeaderView.h"

@interface YHAskAboutInfoHeaderView ()

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UILabel *askAboutInfoL;

@end

@implementation YHAskAboutInfoHeaderView

- (instancetype)init{
    if (self = [super init]) {
        [self initAskAboutInfoVC];
    }
    return self;
}
- (void)initAskAboutInfoVC{
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(contentView.superview).offset(-8);
        make.height.equalTo(contentView.superview).offset(-1);
        make.top.equalTo(@0);
    }];
    
    UILabel *askAboutInfoL = [[UILabel alloc] init];
    self.askAboutInfoL = askAboutInfoL;
    [contentView addSubview:askAboutInfoL];
    [askAboutInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(askAboutInfoL.superview);
    }];
    
    UIButton *jumpCheckCarPicBtn = [[UIButton alloc] init];
    jumpCheckCarPicBtn.titleLabel.font = askAboutInfoL.font;
    jumpCheckCarPicBtn.hidden = YES;
    [jumpCheckCarPicBtn setTitle:@"查看车辆外观标记图" forState:UIControlStateNormal];
    [jumpCheckCarPicBtn setTitleColor:askAboutInfoL.textColor forState:UIControlStateNormal];
    [jumpCheckCarPicBtn addTarget:self action:@selector(jumpToCheckCarPicture:) forControlEvents:UIControlEventTouchUpInside];
    [jumpCheckCarPicBtn sizeToFit];
    self.jumpCheckCarPicBtn = jumpCheckCarPicBtn;
    [contentView addSubview:jumpCheckCarPicBtn];
    [jumpCheckCarPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jumpCheckCarPicBtn.superview).offset(-10);
        make.centerY.equalTo(jumpCheckCarPicBtn.superview);
    }];
}

- (void)setTitle:(NSString *)title{
    
    self.askAboutInfoL.text = title;
    [self.askAboutInfoL sizeToFit];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView setRounded:self.contentView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8.0];
}

- (void)jumpToCheckCarPicture:(UIButton *)jumpBtn{
    
    if (_jumpToCarPicBlock) {
        _jumpToCarPicBlock();
    }
    
}
@end
