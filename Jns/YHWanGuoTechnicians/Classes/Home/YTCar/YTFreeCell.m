//
//  YTFreeCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTFreeCell.h"
#import "YTWarranty.h"

@interface YTFreeCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalLB;
@property (weak, nonatomic) IBOutlet UILabel *serviceLB;
@property (weak, nonatomic) IBOutlet UILabel *maintainLB;

@end

@implementation YTFreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YTExtended *)model{
    _model = model;
    self.serviceLB.text = [NSString stringWithFormat:@"¥ %.2f",model.system_total_price.floatValue];
    self.maintainLB.text = [NSString stringWithFormat:@"¥ %.2f",model.shop_price.floatValue];
    self.totalLB.text = [NSString stringWithFormat:@"¥ %.2f",model.total_price.floatValue];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
