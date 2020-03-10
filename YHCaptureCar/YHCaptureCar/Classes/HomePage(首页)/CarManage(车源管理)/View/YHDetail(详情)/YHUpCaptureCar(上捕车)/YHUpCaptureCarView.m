//
//  YHUpCaptureCarView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHUpCaptureCarView.h"

@implementation YHUpCaptureCarView


- (IBAction)clickBtn:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_priceTF becomeFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
