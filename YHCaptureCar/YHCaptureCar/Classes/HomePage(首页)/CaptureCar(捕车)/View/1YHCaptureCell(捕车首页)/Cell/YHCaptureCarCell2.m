//
//  YHCaptureCarCell2.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCaptureCarCell2.h"
#import "YHCommon.h"
#import <UIImageView+WebCache.h>

@implementation YHCaptureCarCell2

- (void)refreshUIWithModel:(YHCaptureCarModel0 *)model WithTag:(NSInteger)tag
{
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"carPicture"]];
    self.describeLabel.text = model.name;
    self.useTimeLabel.text = model.useTime;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.mileage];
    self.bidTimeLabel.text = model.bidTime;
    
    //竞价成功
    if (tag == 1) {
        self.priceRemindingLabel.text = @"竞得价";
        self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.ultimatelyPrice floatValue]];
        self.priceLabel.textColor = [UIColor redColor];
        [self.auctionSuccessImageView setImage:[UIImage imageNamed:@"icon_auctionSuccess"]];
    //竞价记录:ultimatelyPrice
    } else {
        //是否有效（我是否是最高价: 0 无效（不是最高价） ;1 有效（是最高价）)
        if ([model.status isEqualToString:@"1"]) {
            self.priceRemindingLabel.text = @"竞得价";
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万", [model.ultimatelyPrice floatValue]];
            self.priceLabel.textColor = [UIColor redColor];
            [self.auctionSuccessImageView setImage:[UIImage imageNamed:@"icon_auctionSuccess"]];
        } else if ([model.status isEqualToString:@"0"]){
            self.priceRemindingLabel.text = @"最终价格";
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.ultimatelyPrice  floatValue] ];
                                    
            self.priceLabel.textColor = YHLightGrayColor;
            [self.auctionSuccessImageView setImage:[UIImage imageNamed:@"icon_uncompetitive"]];
        }
    }
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
