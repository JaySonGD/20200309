//
//  YHOrderInfoSelectCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/16.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderInfoSelectCell.h"
#import <Masonry.h>
#import "UIColor+ColorChange.h"

@interface YHOrderInfoSelectCell()

@property (nonatomic, weak) UILabel *labelL;

@property (nonatomic, weak) UISegmentedControl *controll;

@end

@implementation YHOrderInfoSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSelectCellUI];
    }
    return self;
}
- (void)initSelectCellUI{
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *labelL = [[UILabel alloc] init];
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
    
    UISegmentedControl *controll = [[UISegmentedControl alloc] initWithItems:@[@"运营",@"非运营"]];
    [self setUpWithUISegmentedControl:controll];
    self.controll = controll;
    [self.contentView addSubview:controll];
    
}

-(void)setUpWithUISegmentedControl:(UISegmentedControl *)seg
{
    [seg setTintColor:[UIColor colorWithHexString:@"e2e2e5"]];
    
    //选中的文字颜色
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    //未选中的文字颜色
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#383838"]} forState:UIControlStateNormal];
    
    //选择状态的背景图片
    [seg setBackgroundImage:[UIImage imageNamed:@"蓝色"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //选择状态的背景图片
    [seg setBackgroundImage:[UIImage imageNamed:@"白色"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    seg.layer.cornerRadius = 5;
    seg.layer.masksToBounds = YES;
    seg.layer.borderWidth = 1;
    seg.layer.borderColor = [UIColor colorWithHexString:@"bebebe"].CGColor;
}

- (void)setModel:(YHDiagnosisOrderModel *)model{
    _model = model;
    
    self.labelL.text = model.title;
    if ([model.subTitle containsString:@"运营"]) {
        self.controll.selectedSegmentIndex = [model.subTitle isEqualToString:@"运营"] ? 0 : 1;
        [self.controll setTitle:@"运营" forSegmentAtIndex:0];
        [self.controll setTitle:@"非运营" forSegmentAtIndex:1];
    }
    
    if ([model.subTitle containsString:@"私户"] || [model.subTitle containsString:@"公户"]) {
        self.controll.selectedSegmentIndex = [model.subTitle isEqualToString:@"私户"] ? 0 : 1;
        [self.controll setTitle:@"私户" forSegmentAtIndex:0];
        [self.controll setTitle:@"公户" forSegmentAtIndex:1];
    }
    [self.controll sizeToFit];
    [self.controll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.controll.superview).offset(-20);
        make.top.equalTo(self.controll.superview).offset(12);
        make.bottom.equalTo(self.controll.superview).offset(-12);
    }];
}
@end
