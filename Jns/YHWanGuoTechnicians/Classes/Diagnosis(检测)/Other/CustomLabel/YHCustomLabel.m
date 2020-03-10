

//
//  YHCustomLabel.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/15.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCustomLabel.h"

@implementation YHCustomLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
