//
//  PCHomeLeftCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/11/5.
//  Copyright © 2019 toceansoft. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "YHCommon.h"
#import "YHTools.h"
#import "PCPostureCard.h"

#import "YHModelItem.h"
#import "PCHomeLeftCell.h"
@interface PCHomeLeftCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *valueLB;
@property (weak, nonatomic) IBOutlet UILabel *changeLB;

@property (weak, nonatomic) IBOutlet UILabel *figureL;
//体态结论
@property (weak, nonatomic) IBOutlet UILabel *nothingL;
@property (weak, nonatomic) IBOutlet UILabel *postureLevelL;
@property (weak, nonatomic) IBOutlet UIImageView *postureLeftImage;
@property (weak, nonatomic) IBOutlet UIImageView *postureRightImage;
@property (weak, nonatomic) IBOutlet UILabel *headFL;
@end
@implementation PCHomeLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bgView.bounds;
    gradient.colors = @[(id)YHColor0X(0xC3B08F,1.0).CGColor,(id)YHColor0X(0xF1E5CE,1.0).CGColor];
    gradient.startPoint = CGPointMake(0.5, 1);
    gradient.endPoint = CGPointMake(0.5, 0);
//    [self.bgView.layer addSublayer:gradient];
//    YHViewRadius(self.bgView, 8);
//    YHLayerBorder(self.bgView, YHColor0X(0xDECFB4, 1.0), 0.5);
 
}


- (void)postureLoad:(PCPostureCard *)item{
    self.valueLB.hidden = !(item.value);
    self.postureLevelL.hidden = !(item.value);
    self.headFL.hidden = !(item.value);
    self.postureLeftImage.hidden = !(item.value);
    self.postureRightImage.hidden = !(item.value);
    self.nothingL.hidden = (item.value);
    self.nameLB.text = item.name;
    self.valueLB.text = [NSString stringWithFormat:@"%.2f", [YHTools roundNumberStringWithRound:2 number:item.value.floatValue]];
    self.postureLevelL.text = @{@"normal" : @"低", @"mild" : @"中", @"severe" : @"高"}[item.level];//normal 低 mild 中 severe 高
    UIColor *cl =@{
                   @"normal" : YHColor(72, 206, 136),
                   @"mild" : YHColor(250, 146, 96),
                   @"severe" : YHColor(250, 80, 82)
                   }[item.level];
    self.postureLevelL.backgroundColor = cl;
    self.valueLB.textColor = cl;
    self.postureLeftImage.image = item.regionImg;
    [self.postureRightImage sd_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholderImage:nil];
}

- (void)setItem:(YHCellItem *)item{
    _item = item;
    self.iconIV.image = [UIImage imageNamed:item.icon];
    self.nameLB.text = item.name;
    
    //if (!(item.value >0  || item.change > 0)) {
    if (IsEmptyStr(item.reportTime)) {

        NSString *vstr = @"暂无数据";
        NSMutableAttributedString *varrt = [[NSMutableAttributedString alloc] initWithString:vstr];
        [varrt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[vstr rangeOfString:@"暂无数据"]];
        self.valueLB.attributedText = varrt;
        self.changeLB.attributedText = nil;
        self.figureL.hidden = YES;
        return;
    }
    
    self.figureL.hidden = NO;
    
    //NSString *vstr = [NSString stringWithFormat:@"%.1fcm",roundf(item.value*10) * 0.1];
    //NSString *vstr = [NSString stringWithFormat:@"%.1fcm",((NSInteger)(item.value*10+0.5)) * 0.1];
    NSString *vstr = [NSString stringWithFormat:@"%.1fcm", [YHTools roundNumberStringWithRound:1 number:item.normal]];

    
    
    NSMutableAttributedString *varrt = [[NSMutableAttributedString alloc] initWithString:vstr];
    [varrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[vstr rangeOfString:@"cm"]];

    self.valueLB.attributedText = varrt;
    
    
    
    //NSString *cstr = [NSString stringWithFormat:@"%.1fcm",roundf(item.change*10)*0.1];
    //NSString *cstr = [NSString stringWithFormat:@"%.1fcm",((NSInteger)(item.change*10+0.5))*0.1];
    double d = [YHTools roundNumberStringWithRound:1 number:item.change];
    NSString *cstr = [NSString stringWithFormat:@"%@%.1fcm",((d < 0)? (@"减少") : (d > 0? (@"增加") : (@""))), fabs(d)];

    NSMutableAttributedString *carrt = [[NSMutableAttributedString alloc] initWithString:cstr];
    [carrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[cstr rangeOfString:@"cm"]];
    [carrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[cstr rangeOfString:@"减少"]];
    [carrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[cstr rangeOfString:@"增加"]];
    
    self.changeLB.attributedText = carrt;
}

@end
