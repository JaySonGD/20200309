//
//  YHFailReasonView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/3/23.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHFailReasonView.h"

@implementation YHFailReasonView

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

@end
