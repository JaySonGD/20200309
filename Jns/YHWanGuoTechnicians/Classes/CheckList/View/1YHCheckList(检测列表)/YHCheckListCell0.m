//
//  YHCheckListCell0.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckListCell0.h"
#import "YHCommon.h"
#import <UIImageView+WebCache.h>

@implementation YHCheckListCell0

- (void)refreshUIWithModel:(YHCheckListModel0 *)model WithBalanceed:(BOOL)isBalanceed
{
    self.cellView.layer.cornerRadius = 10;
    self.cellView.layer.masksToBounds = YES;
    self.carDealerNameL.text = model.carDealerName;
    self.addressL.text = model.address;
    
//    if (self.addressL.numberOfLines == 1) {
//        self.addressViewHeight.constant = 21;
//    } else {
//        self.addressViewHeight.constant = 36;
//    }
//    
    self.contactPhoneL.text = model.contactPhone;
    self.bookTimeL.text = model.bookTime;
    self.carNumL.text = [NSString stringWithFormat:@"%@/%@",model.finishCarNum,model.carNum];

    if (!IsEmptyStr(model.amount)) {
        self.amountL.text = [NSString stringWithFormat:@"¥%@",model.amount];
        self.amountV.hidden = NO;
    } else {
        self.amountV.hidden = YES;
    }
    
    if (isBalanceed == YES) {
        //0:未完成
        if ([model.status isEqualToString:@"0"]) {
            self.balanceV.hidden = NO;
        //1:已完成   2:关闭
        } else {
            self.balanceV.hidden = YES;
        }
    } else {
        self.balanceV.hidden = YES;
    }
}

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
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
