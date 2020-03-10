//
//  YHBuyersInfoView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/4/8.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBuyersInfoView.h"

@implementation YHBuyersInfoView

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

@end
