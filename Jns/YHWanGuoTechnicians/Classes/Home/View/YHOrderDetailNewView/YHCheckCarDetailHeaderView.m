//
//  YHCheckCarDetailHeaderView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckCarDetailHeaderView.h"

#import "YHCustomLeftAndRightButton.h"

@interface YHCheckCarDetailHeaderView ()

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UILabel *checkSecL;

@property (nonatomic, weak) UILabel *checkResultL;

@property (nonatomic, weak) UILabel *checkResultLR;

@property (nonatomic, weak) YHCustomLeftAndRightButton *openOrCloseBtn;

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation YHCheckCarDetailHeaderView

- (instancetype)init{
    if (self = [super init]) {
       
    }
    return self;
}

- (void)initCheckCarDetailHeaderViewUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView.superview).offset(-16);
        make.left.equalTo(@8);
        make.height.equalTo(contentView.superview).offset(-1);
        make.top.equalTo(@0);
    }];
    
    UILabel *checkSecL = [[UILabel alloc] init];
    checkSecL.font = [UIFont systemFontOfSize:15.5];
    checkSecL.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    self.checkSecL = checkSecL;
    [contentView addSubview:checkSecL];
    [checkSecL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(checkSecL.superview).offset(-8);
//        make.height.equalTo(checkSecL.superview);
        make.top.equalTo(@10);
    }];
    
    YHCustomLeftAndRightButton *openOrCloseBtn = [[YHCustomLeftAndRightButton alloc] init];
    openOrCloseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.openOrCloseBtn = openOrCloseBtn;
    [openOrCloseBtn setTitleColor:[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0] forState:UIControlStateNormal];
    [openOrCloseBtn setImage:[UIImage imageNamed:@"setPartArrow"] forState:UIControlStateNormal];
    [openOrCloseBtn sizeToFit];
    [openOrCloseBtn addTarget:self action:@selector(openOrCloseBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:openOrCloseBtn];
    [openOrCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(openOrCloseBtn.superview).offset(-8);
        make.centerY.equalTo(checkSecL);
        
    }];
    
    if([self.billType isEqualToString:@"J007"]){//尾气的单
        
    UILabel *checkResultL = [[UILabel alloc] init];
    checkResultL.font = [UIFont systemFontOfSize:14];
    checkResultL.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
    self.checkResultL = checkResultL;
    [contentView addSubview:checkResultL];
    self.checkResultL.text = @"判定结果";
    [checkResultL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(checkSecL.mas_bottom).offset(8);
        
    }];
    
    UILabel *checkResultLR = [[UILabel alloc] init];
    checkResultLR.font = [UIFont systemFontOfSize:14];
    checkResultLR.textColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0];
    self.checkResultLR = checkResultLR;
    [contentView addSubview:checkResultLR];
    [checkResultLR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openOrCloseBtn);
        make.centerY.equalTo(checkResultL);
    }];
        
    }
}

- (void)openOrCloseBtnTouchUpInsideEvent:(UIButton *)btn{
    
        if (_rigitBtnClickedEvent) {
            _rigitBtnClickedEvent(!self.isOpen,self.sectionIndex);
        }
}

- (void)setHeaderTitle:(NSString *)text{
    
     self.checkSecL.text = text;
}

- (void)setHeaderResultTitle:(NSString *)text{
    
    self.checkResultLR.text = [text isEqualToString:@"0"] ? @"不合格" : [text isEqualToString:@"1"] ? @"合格" : text;
}

- (void)isNeedOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (isOpen) {
      
        [self.openOrCloseBtn setTitle:@"收起" forState:UIControlStateNormal];
        [self.openOrCloseBtn setImage:[UIImage imageNamed:@"setPartUpArrow"] forState:UIControlStateNormal];
        
    }else{
        [self.openOrCloseBtn setTitle:@"展开" forState:UIControlStateNormal];
        [self.openOrCloseBtn setImage:[UIImage imageNamed:@"setPartArrow"] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    if (!self.sectionCount) {
         [self.contentView setRounded:self.contentView.bounds corners:UIRectCornerAllCorners radius:8.0];
        return;
    }
    
    if (!self.problemCount && !self.isOpen) {
        [self.contentView setRounded:self.contentView.bounds corners:UIRectCornerAllCorners radius:8.0];
        return;
    }
    
     [self.contentView setRounded:self.contentView.bounds corners:UIRectCornerTopRight | UIRectCornerTopLeft radius:8.0];
    
}

@end
