//
//  YHServiceDetailCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/20.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHServiceDetailCell.h"

@interface YHServiceDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *detailL;

@end

@implementation YHServiceDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)load:(NSString*)detail{
    _detailL.text = detail;
}
@end
