//
//  YHCustomLeftAndRightButton.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCustomLeftAndRightButton.h"

@implementation YHCustomLeftAndRightButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    titleFrame.origin.x = 0;
    imageViewFrame.origin.x =  self.titleLabel.frame.size.width +2;
    
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageViewFrame;
   
}
@end
