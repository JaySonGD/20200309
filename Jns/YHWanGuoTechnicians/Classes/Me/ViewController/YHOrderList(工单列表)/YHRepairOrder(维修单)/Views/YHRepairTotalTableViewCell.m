//
//  YHRepairTotalTableViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairTotalTableViewCell.h"

@implementation YHRepairTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    if (self.indexPath.row == 3) {
        self.itemNameL.textColor = [UIColor blackColor];
        self.itemNameL.font = [UIFont boldSystemFontOfSize:15];
    }else{
        
        self.itemNameL.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
        self.itemNameL.font = [UIFont systemFontOfSize:15];
    }
}

- (void)setCellModel:(NSDictionary *)cellModel{
    NSString *price = [NSString stringWithFormat:@"%@",cellModel[@"price"] ? cellModel[@"price"] :  @"0.00"];
    self.itemTotalL.text = [cellModel[@"name"] isEqualToString:@"项目工时"] ? [NSString stringWithFormat:@"%.1f工时",[price floatValue]] : [NSString stringWithFormat:@"￥%.2f",[price floatValue]];
    self.itemNameL.text = cellModel[@"name"];
}


@end
