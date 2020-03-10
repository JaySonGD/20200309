
//
//  YHCarVersionCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarVersionCell.h"
#import <Masonry.h>
#import "YHCommon.h"
#import "UIColor+ColorChange.h"


// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface YHCarVersionCell ()

/**
 车辆版本号
 */
@property (strong , nonatomic)UILabel *carVersionL;

@end

@implementation YHCarVersionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YHCarVersionModel *)model{
    _model = model;
    self.carVersionL.text = model.carModelFullName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self setUpUI];  //设置UI
//    }
//    return self;
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];  //设置UI
    }
    return self;
}

-(void)setUpUI{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self addSubview:_selectBtn];
    //选择按钮约束
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.width.height.equalTo(@20);
        make.centerY.mas_equalTo(self);
    }];
    
    _carVersionL = [[UILabel alloc]init];
    _carVersionL.font = [UIFont systemFontOfSize:14];
    _carVersionL.textAlignment = NSTextAlignmentLeft;
    _carVersionL.backgroundColor = [UIColor whiteColor];
    _carVersionL.numberOfLines = 0;
    [self addSubview:_carVersionL];
    [_carVersionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectBtn.mas_right).mas_offset(@10);
        make.right.equalTo(self).mas_offset(@-10);
        make.centerY.mas_equalTo(_selectBtn);
        make.height.mas_equalTo(@55);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - 1,screenWidth,1)];
        [self addSubview:view];
        view.backgroundColor = [UIColor colorWithHexString:@"E2E2E5"];
    });
}

@end
