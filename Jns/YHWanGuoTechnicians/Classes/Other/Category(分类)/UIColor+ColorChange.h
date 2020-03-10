//
//  UIColor+ColorChange.h
//  MirrorSpace
//
//  Created by liusongApple on 2017/10/7.
//  Copyright © 2017年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

/**
 颜色转换:（以#开头）十六进制的颜色转换为UIColor(RGB)
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
