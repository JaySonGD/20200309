//
//  YHNewOrderComptCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/11.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHNewOrderComptCell.h"
#import <Masonry.h>

@interface YHNewOrderComptCell ()

@property (nonatomic,weak) UILabel *titleL;

@end

@implementation YHNewOrderComptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initNewOrderComptCellUI];
    }
    return self;
}
- (void)initNewOrderComptCellUI{
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleL.superview).offset(10);
        make.top.equalTo(titleL.superview);
        make.bottom.equalTo(titleL.superview);
        make.width.equalTo(@200);
    }];
    
    UIButton *statusBtn = [[UIButton alloc] init];
    statusBtn.userInteractionEnabled = NO;
    [statusBtn setImage:[UIImage imageNamed:@"order_15"] forState:UIControlStateNormal];
    [statusBtn setImage:[UIImage imageNamed:@"order_16"] forState:UIControlStateSelected];
    self.statusBtn = statusBtn;
    [self.contentView addSubview:statusBtn];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(statusBtn.superview);
        make.top.equalTo(statusBtn.superview);
        make.bottom.equalTo(statusBtn.superview);
        make.width.equalTo(@60);
    }];
}

- (void)setCellInfo:(NSDictionary *)cellInfo{
    _cellInfo = cellInfo;
    self.titleL.text = cellInfo[@"realname"];
}

@end
