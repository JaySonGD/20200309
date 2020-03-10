//
//  YHMapSearchCell.m
//  YHCaptureCar
//
//  Created by mwf on 2018/6/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHMapSearchCell.h"

@implementation YHMapSearchCell

- (void)refreshUIWithModel:(YHReservationModel *)model
{
    self.nameLabel.text = model.name;
    self.addrLabel.text = model.address;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
