//
//  YHPersonNormalCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHPersonNormalCell.h"

@implementation YHPersonNormalCell


- (void)layoutSubviews{
    [super layoutSubviews];
    
     self.megain.active = self.iconView.image;
}

@end
