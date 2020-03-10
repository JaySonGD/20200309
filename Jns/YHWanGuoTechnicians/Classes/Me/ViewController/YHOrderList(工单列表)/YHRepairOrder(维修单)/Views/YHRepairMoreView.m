//
//  YHRepairMoreView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHRepairMoreView.h"

@implementation YHRepairMoreView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewEvent)];
    [self addGestureRecognizer:tapGes];
}

- (void)tapViewEvent{
   
    if (_tapViewGesTure) {
        _tapViewGesTure();
    }
}

- (void)setIs_sysCase:(BOOL)is_sysCase{
    _is_sysCase = is_sysCase;
    self.reNameHeight.constant = is_sysCase ? 0 : 44;
}

@end
