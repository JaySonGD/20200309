//
//  YHPersonEspecialCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHPersonEspecialCell.h"

@implementation YHPersonEspecialCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isRequireCorner) {
        [self setRounded:self.bounds corners:UIRectCornerAllCorners radius:8.0];
    }
}


@end
