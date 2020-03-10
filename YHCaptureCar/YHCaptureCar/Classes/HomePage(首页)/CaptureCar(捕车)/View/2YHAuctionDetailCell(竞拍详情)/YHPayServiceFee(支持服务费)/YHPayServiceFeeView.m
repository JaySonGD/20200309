//
//  YHPayServiceFeeView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHPayServiceFeeView.h"

@implementation YHPayServiceFeeView


+ (instancetype)payServiceFeeView{
    return [[NSBundle mainBundle] loadNibNamed:@"YHPayServiceFeeView" owner:nil options:nil].firstObject;
}

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

@end
