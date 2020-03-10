//
//  YHBalanceView.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBalanceView.h"

@implementation YHBalanceView

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
