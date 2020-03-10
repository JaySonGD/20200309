//
//  YHWorkboardCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkboardCell.h"
#import <UIImageView+WebCache.h>

@interface YHWorkboardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *carLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UIButton *packageB;
@property (weak, nonatomic) IBOutlet UIButton *delB;

@end

@implementation YHWorkboardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loaddataSource:(NSDictionary*)info index:(NSInteger)index{
    _delB.tag = index;
    NSNumber *deleteAuth = info[@"deleteAuth"];
    _delB.hidden = !(deleteAuth.boolValue);

    [_carLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.wanguoqiche.com/files/logo/%@.jpg", info[@"carBrandLogo"]]] placeholderImage:[UIImage imageNamed:@""]];
    _carNumberL.text = [NSString stringWithFormat:@"%@%@%@",info[@"plateNumberP"],info[@"plateNumberC"],info[@"plateNumber"]];
    
    _nameL.text = info[@"name"];
    _phoneL.text = info[@"phone"];
    _dateL.text = info[@"appointmentDate"];
    
    //业务类型 1:维修 2:保养 3:检测
    NSNumber *serviceType = info[@"serviceType"];
    [_packageB setTitle:@[@"",@"维修", @"保养",@"检测"][serviceType.integerValue] forState:UIControlStateNormal];
}
@end
