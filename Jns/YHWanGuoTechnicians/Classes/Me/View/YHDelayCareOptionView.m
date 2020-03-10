//
//  YHDelayCareOptionView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDelayCareOptionView.h"

#import "YHStoreTool.h"

@interface YHDelayCareOptionView ()

@property (nonatomic, weak) UILabel *optionTitleL;

@property (nonatomic, weak) UIButton *selectBtn;

@end

@implementation YHDelayCareOptionView

- (instancetype)init{
    if (self = [super init]) {
        [self initOptionView];
    }
    return self;
}
- (void)initOptionView{
    
    UILabel *optionTitleL = [[UILabel alloc] init];
    optionTitleL.font = [UIFont systemFontOfSize:17];
    optionTitleL.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    self.optionTitleL = optionTitleL;
    [self addSubview:optionTitleL];
    [optionTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(optionTitleL.superview);
        make.centerY.equalTo(optionTitleL.superview);
        make.left.equalTo(@0);
    }];
    
    UIButton *selectBtn = [[UIButton alloc] init];
    [selectBtn addTarget:self action:@selector(selectBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    [self addSubview:selectBtn];
    [self.selectBtn setImage:[UIImage imageNamed:@"buttonN"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"buttonP"] forState:UIControlStateSelected];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(optionTitleL);
        make.centerY.equalTo(selectBtn.superview);
        make.right.equalTo(selectBtn.superview).offset(0);
    }];
    
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.selectBtn.selected = isSelected;
}
- (void)setInfo:(NSDictionary *)info{
    _info = info;
    self.optionTitleL.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    self.optionTitleL.text = info[@"name"];
}
- (void)selectBtnClickEvent:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    NSMutableDictionary *delayCareLeakOptionData = [YHStoreTool ShareStoreTool].delayCareLeakOptionData;
    NSMutableArray *value =[delayCareLeakOptionData[self.optionIdStr] mutableCopy];
    if (!value) {
        value = [NSMutableArray array];
    }
    if (btn.selected) {
        NSMutableDictionary *addInfo = [self.info mutableCopy];
        [addInfo setValue:self.groupName forKey:@"groupName"];
      [value addObject:addInfo];
    
    }else{
    
        for (int i = 0; i<value.count; i++) {
            NSMutableDictionary *item = value[i];
            if ([item[@"value"] isEqualToString:self.info[@"value"]]) {
                 [value removeObjectAtIndex:i];
                break;
            }
        }
    }
    [delayCareLeakOptionData setValue: value forKey:self.optionIdStr];
    [[YHStoreTool ShareStoreTool] setDelayCareLeakOptionData:delayCareLeakOptionData];
}
@end
