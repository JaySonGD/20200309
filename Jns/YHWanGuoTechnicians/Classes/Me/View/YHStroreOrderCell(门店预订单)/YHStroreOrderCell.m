//
//  YHStroreOrderCell.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/8/27.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStroreOrderCell.h"

@implementation YHStroreOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBtn:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

@end
