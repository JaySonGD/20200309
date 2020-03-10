//
//  YHBaseView.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseView.h"
#import "YHCommon.h"

@implementation YHBaseView

-(void)setLabelBorder:(UILabel *)label
{
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [YHColor(40, 152, 240) CGColor];
    label.layer.cornerRadius = 2.f;
}

-(void)setButtonBorder:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [YHColor(40, 152, 240) CGColor];
    button.layer.cornerRadius = 2.f;
}

@end
