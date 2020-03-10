//
//  Created by Jayson on 2019/6/28.
//  Copyright © 2019年 HJ. All rights reserved.


#import "PCHistoryCell.h"
#import "YHModelItem.h"
#import "YHTools.h"

#import "YHCommon.h"

@interface PCHistoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *valueLB;
@property (weak, nonatomic) IBOutlet UILabel *unitLB;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PCHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bgView.bounds;
    gradient.colors = @[(id)YHColor0X(0xC3B08F,1.0).CGColor,(id)YHColor0X(0xF1E5CE,1.0).CGColor];
    gradient.startPoint = CGPointMake(0.5, 1);
    gradient.endPoint = CGPointMake(0.5, 0);
    [self.bgView.layer addSublayer:gradient];
    YHViewRadius(self.bgView, 10);
    YHLayerBorder(self.bgView, YHColor0X(0xDECFB4, 1.0), 0.5);

}

- (void)setItem:(YHCellItem *)item{
    _item = item;
    self.iconIV.image = [UIImage imageNamed:item.icon];
    self.nameLB.text = item.name;
    
    //NSString *vstr = [NSString stringWithFormat:@"%.1f",roundf(item.value*10) * 0.1];
    //NSString *vstr = [NSString stringWithFormat:@"%.1f",((NSInteger)(item.value*10+0.5)) * 0.1];
    NSString *vstr = [NSString stringWithFormat:@"%.1f", [YHTools roundNumberStringWithRound:1 number:item.normal]];



    //NSMutableAttributedString *varrt = [[NSMutableAttributedString alloc] initWithString:vstr];
    //[varrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[vstr rangeOfString:@"cm"]];
    
    //self.valueLB.attributedText = varrt;
    self.valueLB.text = vstr;
    
    self.unitLB.text = [item.name isEqualToString:@"体重"]? @"kg" : @"cm";
    
}

@end
