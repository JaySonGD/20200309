//
//  YHWorkbordOrderCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/27.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkbordOrderCell.h"
@interface YHWorkbordOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderModelL;
@property (weak, nonatomic) IBOutlet UILabel *orderIdL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *carKML;
@property (weak, nonatomic) IBOutlet UILabel *carDateL;
@end
@implementation YHWorkbordOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loaddataSource:(NSDictionary*)info{
    NSString *orderModelStr =  @{@"G" : @"维保工单", @"W"  : @"维修工单", @"B" : @"保养工单", @"J" : @"全车检测工单"}[info[@"billType"]];
    _orderModelL.text = orderModelStr;
    _orderIdL.text = info[@"billNumber"];
    _carKML.text = info[@"tripDistance"];
    _dateL.text = info[@"endTime"];
    _carDateL.text = info[@"livingAge"];
}
@end
