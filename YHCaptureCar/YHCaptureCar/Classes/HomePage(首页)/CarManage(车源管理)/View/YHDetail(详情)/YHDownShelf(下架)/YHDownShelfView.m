//
//  YHDownShelfView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHDownShelfView.h"

@implementation YHDownShelfView

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_priceTF becomeFirstResponder];
}

@end
