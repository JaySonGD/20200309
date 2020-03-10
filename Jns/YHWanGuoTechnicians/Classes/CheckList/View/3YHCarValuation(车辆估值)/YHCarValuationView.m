//
//  YHCarValuationView.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarValuationView.h"

@implementation YHCarValuationView

- (void)drawRect:(CGRect)rect
{
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.pushPhoneTF becomeFirstResponder];
}

- (IBAction)clickButton:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self removeFromSuperview];
            break;
        case 2:
        {
            if (self.btnClickBlock) {
                self.btnClickBlock(sender);
            }
        }
            break;
        default:
            break;
    }
}

@end
