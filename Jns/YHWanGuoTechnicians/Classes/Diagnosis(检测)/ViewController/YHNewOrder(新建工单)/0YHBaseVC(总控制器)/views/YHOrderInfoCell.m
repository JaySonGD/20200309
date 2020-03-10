//
//  YHOrderInfoCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/16.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderInfoCell.h"
#import <Masonry.h>

@interface YHOrderInfoCell ()

@property (nonatomic, weak) UILabel *labelL;

@property (nonatomic, weak) UILabel *subtitleL;

@end

@implementation YHOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{

    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
  
    UILabel *labelL = [[UILabel alloc] init];
    labelL.textColor = [UIColor blackColor];
    labelL.font = [UIFont systemFontOfSize:15.0];
    labelL.textAlignment = NSTextAlignmentLeft;
    self.labelL = labelL;
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2.0 - 20;
    [self.contentView addSubview:labelL];
    [labelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelL.superview).offset(20);
        make.top.equalTo(labelL.superview);
        make.bottom.equalTo(labelL.superview);
        make.width.mas_equalTo((width));
    }];
    
    
    UILabel *subtitleL = [[UILabel alloc] init];
    subtitleL.textColor = [UIColor blackColor];
    subtitleL.font = [UIFont systemFontOfSize:14.0];
    subtitleL.textAlignment = NSTextAlignmentRight;
    self.subtitleL = subtitleL;
    [self.contentView addSubview:subtitleL];
    [subtitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelL.mas_right);
        make.top.equalTo(labelL);
        make.bottom.equalTo(labelL);
        make.width.equalTo(labelL);
    }];
}
- (void)setOrderInfoModel:(YHDiagnosisOrderModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    
    self.subtitleL.text = orderInfoModel.subTitle;
    self.labelL.text = orderInfoModel.title;
}
@end
