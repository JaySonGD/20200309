//
//  YHMaintenanceCollectionCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/11/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHMaintenanceCollectionCell.h"

@interface YHMaintenanceCollectionCell ()

@property (nonatomic, weak) UIButton *targetBtn;

@end

@implementation YHMaintenanceCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addView];
    }
    return self;
}
- (void)addView{

    UIButton *itemBtn = [[UIButton alloc] init];
    itemBtn.userInteractionEnabled = NO;
    [itemBtn setImage:[UIImage imageNamed:@"buttonN"] forState:UIControlStateNormal];
    [itemBtn setImage:[UIImage imageNamed:@"buttonP"] forState:UIControlStateSelected];
    
    self.itemBtn = itemBtn;
    [self.contentView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(@0);
        make.centerY.equalTo(itemBtn.superview);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
//    UIColor *mainTextColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0];
    titleL.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    titleL.font = [UIFont systemFontOfSize:14.0];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleL.superview);
        make.left.equalTo(itemBtn.mas_right).offset(10);
        make.right.equalTo(@(-10));
        make.height.equalTo(itemBtn);
    }];
    
    UIButton *targetBtn = [[UIButton alloc] init];
    self.targetBtn = targetBtn;
    [self.contentView addSubview:targetBtn];
    [targetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(targetBtn.superview);
        make.height.equalTo(targetBtn.superview);
        make.left.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    [targetBtn addTarget:self action:@selector(buttonSelectEvent) forControlEvents:UIControlEventTouchUpInside];
   
}
- (void)setInfo:(NSDictionary *)info{
    _info = info;
    
    self.titleL.text = info[@"itemName"];
    self.itemBtn.selected = [[NSString stringWithFormat:@"%@",info[@"checkedStatus"]] isEqualToString:@"0"] ? NO: YES;
}
- (void)setIsCanEdit:(BOOL)isCanEdit{
    _isCanEdit = isCanEdit;
    self.targetBtn.userInteractionEnabled = isCanEdit;
    
}
- (void)buttonSelectEvent{
    
    self.itemBtn.selected = !self.itemBtn.selected;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.itemBtn.selected) {
        [dict setValue:@"1" forKey:[NSString stringWithFormat:@"%@",self.info[@"itemId"]]];
    }else{
        [dict setValue:@"0" forKey:[NSString stringWithFormat:@"%@",self.info[@"itemId"]]];
    }
    if (_clickEditBtnEvent) {
        _clickEditBtnEvent(dict);
    }
}
@end
