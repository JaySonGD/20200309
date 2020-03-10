//
//  TTZButton.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZButton.h"

@implementation TTZButton

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnImageWidth = self.imageView.bounds.size.width;
    CGFloat btnLabelWidth = self.titleLabel.bounds.size.width;
    CGFloat margin = 0;
    
    btnImageWidth += margin;
    btnLabelWidth += margin;
    
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];

}

@end
