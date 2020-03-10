//
//  YHProfitDetailCell.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHProfitDetailCell.h"

@interface YHProfitDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *profitTitleL;
/** VIN */
@property (weak, nonatomic) IBOutlet UILabel *VINContentL;
/** 返现时间 */
@property (weak, nonatomic) IBOutlet UILabel *backCashTimeL;
/** 返现金额 */
@property (weak, nonatomic) IBOutlet UILabel *backCashNumberL;




@end

@implementation YHProfitDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    
    self.profitTitleL.text = info[@"fullName"];
    self.VINContentL.text = info[@"vin"];
    self.backCashTimeL.text = info[@"cbDate"];
    CGFloat cbAmount = [info[@"cbAmount"] floatValue];
    self.backCashNumberL.text = [NSString stringWithFormat:@"￥ %.2f",cbAmount];
}

- (void)setFrame:(CGRect)frame{
    
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
