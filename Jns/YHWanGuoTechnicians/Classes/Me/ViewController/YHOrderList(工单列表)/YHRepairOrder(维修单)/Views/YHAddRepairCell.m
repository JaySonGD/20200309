//
//  YHAddRepairCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/29.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAddRepairCell.h"

@implementation YHAddRepairCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [self.closeBtn addTarget:self action:@selector(closeCellCallBack) forControlEvents: UIControlEventTouchUpInside];
}

- (void)closeCellCallBack{
    
    if (_closeCellCallBbackBlock) {
        _closeCellCallBbackBlock(_indexPath);
    }
}

@end
