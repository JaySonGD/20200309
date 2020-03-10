//
//  YHMyPriceView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHMyPriceView.h"

@implementation YHMyPriceView

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

- (void)drawRect:(CGRect)rect
{
    [self setLabelBorder:self.addRangeLabel];
    [self setButtonBorder:self.reduceButton];
    [self setButtonBorder:self.addButton];
}

@end
