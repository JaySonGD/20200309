
//
//  YHErrorDescCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/18.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHErrorDescCell.h"
#import "IQTextView.h"
@interface YHErrorDescCell ()

@property (weak, nonatomic) IBOutlet IQTextView *textV;
@end

@implementation YHErrorDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textV.placeholder = @"请填写故障描述";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
