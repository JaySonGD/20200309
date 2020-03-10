//
//  YHCloseWorkListView.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/8/15.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCloseWorkListView.h"

@implementation YHCloseWorkListView

- (void)drawRect:(CGRect)rect
{
    //self.backgroundColor = YHColorA(127, 127, 127, 0.5);
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_reasonTF becomeFirstResponder];
}

- (IBAction)clickBtn:(UIButton *)sender {
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
