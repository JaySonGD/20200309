//
//  UIView+add.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "UIView+add.h"

@implementation UIView (add)

- (void)setRounded:(CGRect)rect corners:(UIRectCorner)corners radius:(CGFloat)radius{
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    maskPath.lineWidth   = 0.f;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end


