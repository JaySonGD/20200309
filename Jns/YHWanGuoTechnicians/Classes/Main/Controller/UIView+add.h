//
//  UIView+add.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (add)
/**
 * 设置view的倒角
 * rect : view的bounds
 * corners: 枚举,指定四个角
            UIRectCornerTopLeft     = 1 << 0, 左上
            UIRectCornerTopRight    = 1 << 1, 右上
            UIRectCornerBottomLeft  = 1 << 2, 左下
            UIRectCornerBottomRight = 1 << 3, 右下
            UIRectCornerAllCorners  = ~0UL
 */
- (void)setRounded:(CGRect)rect corners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
