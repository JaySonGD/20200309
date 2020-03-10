//
//  TTZTextField.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZTextField.h"

@implementation TTZTextField



- (void)layoutSubviews{
    [super layoutSubviews];
    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
    placeholderLabel.frame = self.bounds;
    
}

@end
