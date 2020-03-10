//
//  BlockButton.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/3/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)doAction:(UIButton *)button {
    
    self.block(button);
}


@end
