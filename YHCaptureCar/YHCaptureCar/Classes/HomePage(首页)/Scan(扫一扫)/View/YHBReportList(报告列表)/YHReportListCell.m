//
//  YHReportListCell.m
//  YHCaptureCar
//
//  Created by mwf on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHReportListCell.h"

@implementation YHReportListCell

- (void)refreshUIWithModel:(YHReportListModel *)model{
    self.checkTimeL.text = model.creationTime;
    self.checkTypeL.text = model.billTypeName;
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
