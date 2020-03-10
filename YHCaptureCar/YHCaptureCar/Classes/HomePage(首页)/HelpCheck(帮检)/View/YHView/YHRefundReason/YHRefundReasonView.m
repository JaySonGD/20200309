//
//  YHRefundReasonView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/4/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRefundReasonView.h"

@implementation YHRefundReasonView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_refundReasonTF becomeFirstResponder];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}


@end
