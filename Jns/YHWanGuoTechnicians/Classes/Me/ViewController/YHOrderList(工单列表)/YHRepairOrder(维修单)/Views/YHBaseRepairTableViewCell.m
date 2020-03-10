//
//  YHBaseRepairTableViewCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/24.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"

@implementation YHBaseRepairTableViewCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isNeedRaidus){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setRounded:self.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8.0];
        });
    }
}
@end
