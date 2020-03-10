//
//  TTZHeaderTagCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZHeaderTagCell.h"

#import "TTZSurveyModel.h"

@implementation TTZHeaderTagCell
{
    UIButton *_tagTitleButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:YHNaviColor forState:UIControlStateSelected];
        [btn setTitleColor:YHColor(209, 209, 209) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.left.right.mas_equalTo(self.contentView).offset(0);
        }];
        [btn setTitle:@"444" forState:UIControlStateNormal];
        btn.selected = YES;
        btn.userInteractionEnabled = NO;
        _tagTitleButton = btn;
    }
    return self;
}

- (void)setTagModel:(TTZGroundModel *)tagModel{
    _tagModel = tagModel;
    [_tagTitleButton setTitle:tagModel.projectName forState:UIControlStateNormal];
    _tagTitleButton.selected = tagModel.isSelected;
}

@end


@implementation TTZValueCell
{
    UIButton *_titleButton;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:YHColor(89, 87, 85) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.left.right.mas_equalTo(self.contentView).offset(0);
        }];
        btn.userInteractionEnabled = NO;
        _titleButton = btn;
    }
    return self;
}

- (void)setModel:(TTZValueModel *)model{
    _model = model;
    _titleButton.selected = model.isSelected;
    [_titleButton setTitle:model.name forState:UIControlStateNormal];
    if (model.isSelected) {
        _titleButton.backgroundColor = YHNaviColor;
        kViewBorderRadius(_titleButton, 8, 0.5, YHNaviColor);
    }else{
        _titleButton.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(_titleButton, 8, 0.5, YHColor(171, 174, 174));
    }
    

}
@end
