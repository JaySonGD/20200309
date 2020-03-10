//
//  YHMarginMutableButton.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/8/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHMarginMutableButton.h"

@implementation YHMarginMutableButton

- (void)setFrame:(CGRect)frame{
    frame.size.width = frame.size.width + 8;;
    [super setFrame:frame];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
}
@end
