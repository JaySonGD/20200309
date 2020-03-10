//
//  YHCaptureCarCell3.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCaptureCarCell3.h"

@implementation YHCaptureCarCell3


- (IBAction)clickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
