//
//  YHRepairCollectionViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairCollectionViewCell.h"

@interface YHRepairCollectionViewCell ()

@property (nonatomic, weak) UILabel *titelL;

@end

@implementation YHRepairCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{

    UILabel *titelL = [UILabel new];
    self.titelL = titelL;
    [self.contentView addSubview:titelL];
    [titelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titelL.superview);
    }];
    titelL.textAlignment = NSTextAlignmentCenter;
    titelL.font = [UIFont systemFontOfSize:14.0];
    titelL.textColor = [UIColor colorWithRed:202.0/255.0 green:202.0/255.0 blue:202.0/255.0 alpha:1.0];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titelL.text = title;
}
- (void)setSelectTitle:(BOOL)isSelect{
    self.titelL.textColor = isSelect ? [UIColor colorWithRed:63.0/255.0 green:159.0/255.0 blue:245.0/255.0 alpha:1.0]:[UIColor colorWithRed:202.0/255.0 green:202.0/255.0 blue:202.0/255.0 alpha:1.0];
}
- (void)setIsNoCanEdit:(BOOL)isNoCanEdit{
    
    if ([self.title isEqualToString:@"设置配件"] && isNoCanEdit) {
        self.title = @"所需配件";
    }
    
    if ([self.title isEqualToString:@"设置耗材"] && isNoCanEdit) {
        self.title = @"所需耗材";
    }
}
@end
