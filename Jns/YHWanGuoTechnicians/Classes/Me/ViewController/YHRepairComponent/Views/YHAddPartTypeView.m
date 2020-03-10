//
//  YHAddPartTypeView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAddPartTypeView.h"
#import <Masonry.h>
#import "YHCommon.h"

#define border_color [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:0.7]
#define text_color [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1.0]
#define boedr_radius 8.0

@interface YHAddPartTypeView ()

@property (nonatomic, weak) UIButton *leftBtn;

@property (nonatomic, weak) UIButton *rightBtn;

@end

@implementation YHAddPartTypeView

- (instancetype)init{
    if (self = [super init]) {
        [self initAddPartTypeView];
    }
    return self;
}
- (void)initAddPartTypeView{
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *nameL = [[UILabel alloc] init];
    nameL.text = @"配件类型";
    [nameL sizeToFit];
    [self addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.height.equalTo(nameL.superview);
        make.top.equalTo(@0);
        
    }];
    
    UIView *maskView = [[UIView alloc] init];
    maskView.userInteractionEnabled = YES;
    maskView.layer.borderWidth = 1.0;
    maskView.layer.borderColor = border_color.CGColor;
    maskView.layer.cornerRadius = boedr_radius;
    maskView.layer.masksToBounds = YES;
    [self addSubview:maskView];
    CGFloat margin = 11.0;
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(margin));
        make.right.equalTo(maskView.superview).offset(-19);
        make.bottom.equalTo(maskView.superview).offset(-margin);
        make.width.equalTo(@108);
    }];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitleColor:text_color forState:UIControlStateNormal];
    [rightBtn setTitle:@"耗材" forState:UIControlStateNormal];
    self.rightBtn = rightBtn;
    
    [rightBtn addTarget:self action:@selector(selectBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightBtn.superview).offset(-20);
        make.top.equalTo(@(margin + 1.0));
        make.bottom.equalTo(rightBtn.superview).offset(-(margin + 1.0));
        make.width.equalTo(@53);
    }];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setTitle:@"配件" forState:UIControlStateNormal];
    self.leftBtn = leftBtn;
    [leftBtn addTarget:self action:@selector(selectBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightBtn.mas_left);
        make.top.equalTo(rightBtn);
        make.bottom.equalTo(rightBtn);
        make.width.equalTo(@53);
    }];
}
- (void)selectBtnClickEvent:(UIButton *)targetBtn{
    
    if (targetBtn == self.leftBtn) {
        self.isSelectLeftBtn = YES;
    }
   
    if (targetBtn == self.rightBtn) {
        self.isSelectLeftBtn = NO;
    }
    
    if (_selectBtnClickEvent) {
        _selectBtnClickEvent(self.isSelectLeftBtn);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftBtn setRounded:self.leftBtn.bounds corners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:boedr_radius];
    [self.rightBtn setRounded:self.rightBtn.bounds corners:UIRectCornerTopRight | UIRectCornerBottomRight radius:boedr_radius];
}

- (void)setIsSelectLeftBtn:(BOOL)isSelectLeftBtn{
    
    _isSelectLeftBtn = isSelectLeftBtn;
    if (isSelectLeftBtn) {
        self.leftBtn.backgroundColor = YHNaviColor;
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = [UIColor whiteColor];
        [self.rightBtn setTitleColor:text_color forState:UIControlStateNormal];
    }else{
        self.leftBtn.backgroundColor = [UIColor whiteColor];
        [self.leftBtn setTitleColor:text_color forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = YHNaviColor;
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
