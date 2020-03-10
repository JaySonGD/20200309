//
//  YHSitesDetailCellA.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/17.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSitesDetailCellA.h"

@implementation YHSitesDetailCellA

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickBtn:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

- (void)refreshUIWithModel:(YHSiteDetailModel *)model{
    self.shopNameL.text = model.name;
    self.customerNameL.text = model.contact_name;
//    self.customerPhoneL.titleLabel.text = model.contact_tel;
    [self.customerPhoneL setTitle:model.contact_tel forState:UIControlStateNormal];
    self.bookDateL.text = model.address;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
