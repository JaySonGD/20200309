//
//  YTPlanCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "YTPlanCell.h"
#import "YTPlanModel.h"

@interface YTPlanCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *hideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideLayout;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *linkPrice;

@end

@implementation YTPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setModel:(YTPlanModel *)model{
    _model = model;
    
    NSInteger quality_time_int = model.quality_time;
    NSInteger quality_km_int = model.quality_km;

    if(![model isKindOfClass:[YTPlanModel class]]){
        quality_time_int = [[NSString stringWithFormat:@"%ld",(long)model.quality_time] integerValue];
        quality_km_int = [[NSString stringWithFormat:@"%ld",(long)model.quality_km] integerValue];

    }
    //——quality_time    int    质保时间：默认0,单位月,前端处理：>=12个月要转为x年x个月
    //——quality_km    int    质保公里数：默认0,单位(公里数),前端处理：转为以万为单位
    
    NSInteger year = quality_time_int /12;
    NSInteger mouth = quality_time_int %12;
    
    NSString *quality_time;
    if (year == 0 && mouth == 0) {
        
    }else if(mouth == 0){
        quality_time = [NSString stringWithFormat:@"%ld年",year];
    }else if(year == 0){
        quality_time = [NSString stringWithFormat:@"%ld个月",mouth];
    }else{
        quality_time = [NSString stringWithFormat:@"%ld年%ld个月",year,mouth];
    }
    

    NSInteger tenThousand = quality_km_int /10000;
    NSInteger thousand = quality_km_int %10000;
    NSString *quality_km;
    if (tenThousand == 0 && thousand == 0) {
        
    }else if(tenThousand == 0){// 小于一万
        quality_km = [NSString stringWithFormat:@"%ld公里",thousand];
    }else{
        quality_km = [NSString stringWithFormat:@"%ld万公里",tenThousand = quality_km_int/10000.0];
    }
    
    NSString *msg;
    if (!quality_time && !quality_km) {
        msg = @"无质保";
    }else if (!quality_time){
        msg = [NSString stringWithFormat:@"JNS·PICC提供%@质保",quality_km];
    }else if (!quality_km){
        msg = [NSString stringWithFormat:@"JNS·PICC提供%@质保",quality_time];
    }else{
        msg = [NSString stringWithFormat:@"JNS·PICC提供%@或%@质保",quality_time,quality_km];
    }

    if ([self.orderType isEqualToString:@"J004"]) {
        msg = self.caseName;;
    }
    
    [self.titleLB setImage:[UIImage imageNamed:model.is_sys? @"组 8669" : @""] forState:UIControlStateNormal];
    [self.titleLB setTitle:model.is_sys?[NSString stringWithFormat:@"  %@",model.name]:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
//    self.desLB.text = msg;
    self.desLB.hidden = YES;
    NSString *price = [NSString stringWithFormat:@"¥ %.2f",model.total_price.floatValue];
    self.priceLB.text = price;
    
    
    if ([self.orderType isEqualToString:@"J002"] && model.isOnlyOne) {
        [self.titleLB setTitle:model.is_sys?[NSString stringWithFormat:@"  方案1"]:[NSString stringWithFormat:@"方案1"] forState:UIControlStateNormal];
        model.name = @"方案1";
    }

}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([self.orderType isEqualToString:@"J004"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentView setRounded:self.contentView.bounds corners:UIRectCornerAllCorners radius:8.0];
            [self.customView setRounded:self.customView.bounds corners:UIRectCornerAllCorners radius:8.0];
        });
    }
    
    if([self.orderType isEqualToString:@"J006"] || [self.orderType isEqualToString:@"J005"] || [self.orderType isEqualToString:@"AirConditioner"] || [self.orderType isEqualToString:@"J008"]){//隐藏质保
        self.hideView.hidden = YES;
        self.hideLayout.active = NO;
        self.arrowBtn.hidden = NO;
    }else{
        self.arrowBtn.hidden = YES;
    }
    
}

@end
