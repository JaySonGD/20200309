//
//  YHStoreBookingCellA.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/17.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStoreBookingCellA.h"

@implementation YHStoreBookingCellA

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.plateNumberTF.isCarNo = YES;
}

//- (IBAction)clickBtn:(UIButton *)sender {
//    if (self.btnClickBlock) {
//        self.btnClickBlock(sender);
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
