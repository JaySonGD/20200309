//
//  ContrastCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/10/11.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "ContrastCell.h"
#import "YHTools.h"
#import "YHCommon.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface ContrastCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *valueLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silderVLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalMinLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalMaxLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silderWLC;
@property (weak, nonatomic) IBOutlet UIImageView *sliderImg;
@end
@implementation ContrastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setItem:(YHCellItem *)item{
    _item = item;
    self.iconIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1", item.icon]];
    self.nameLB.text = item.name;
    NSString *vstr = [NSString stringWithFormat:@"%.1fcm", [YHTools roundNumberStringWithRound:1 number:item.value]];
    
    
    
    NSMutableAttributedString *varrt = [[NSMutableAttributedString alloc] initWithString:vstr];
    [varrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[vstr rangeOfString:@"cm"]];
    
    self.valueLB.attributedText = varrt;
    
    if ((item.max - item.min) == 0) {
        return;
    }
    NSInteger value = item.value;
    if (item.value > item.max) {
        value = item.max;
    }
    if (item.value < item.min) {
        value = item.min;
    }
    float sliderW = screenWidth - self.sliderImg.frame.origin.x - 15;
    CGFloat sider = sliderW / (item.max - item.min) * (value - item.min);
    if (sider >= sliderW - 8) {
        sider = sliderW - 8;
    }
    self.silderVLC.constant = sider;
    YHLog(@"%@ %f %f", item.name, sliderW, sider);
    
     value = item.normalMin;
    if (item.normalMin > item.max) {
        value = item.max;
    }
    if (item.normalMin < item.min) {
        value = item.min;
    }
    sider = sliderW / (item.max - item.min) * (value - item.min);
    if (sider >= sliderW - 1) {
        sider = sliderW - 1;
    }
    self.normalMinLC.constant = sider;
    
    
    value = item.normalMax;
    if (item.normalMax > item.max) {
        value = item.max;
    }
    if (item.normalMax < item.min) {
        value = item.min;
    }
    sider = sliderW / (item.max - item.min) * (value - item.min);
    if (sider >= sliderW - 1) {
        sider = sliderW - 1;
    }
    self.normalMaxLC.constant = sider;
}
@end
