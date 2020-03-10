//
//  YHBusinessInfoView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBusinessInfoView.h"

@implementation YHBusinessInfoView

- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

@end
