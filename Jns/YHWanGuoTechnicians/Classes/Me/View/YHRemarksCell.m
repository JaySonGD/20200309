//
//  YHRemarksCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/7/3.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHRemarksCell.h"
#import "IQTextView.h"
@interface YHRemarksCell ()
@property (weak, nonatomic) IBOutlet IQTextView *textView;

@end

@implementation YHRemarksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textView.placeholder = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(NSString*)info{
    _textView.text = info;
}

@end
