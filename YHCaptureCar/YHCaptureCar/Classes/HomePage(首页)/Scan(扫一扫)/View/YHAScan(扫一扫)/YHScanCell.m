//
//  YHScanCell.m
//  YHCaptureCar
//
//  Created by mwf on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHScanCell.h"

@implementation YHScanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshUIWithVinStr:(NSString *)vin{
    self.vinL.text = vin;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
