//
//  YHExtendedView.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/9/3.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHExtendedView.h"
#import <UIImageView+WebCache.h>

@implementation YHExtendedView

-(void)setBaseInfo:(YTBaseInfo *)baseInfo{
    
    self.licensed.text = [NSString stringWithFormat:@"%@%@%@",baseInfo.plateNumberP,baseInfo.plateNumberC,baseInfo.plateNumber];
    self.VINLb.text = baseInfo.vin;
    self.kmNumber.text = baseInfo.tripDistance;
    if(baseInfo.tripDistance.floatValue > 9999.99){
        self.kmNumber.text = [NSString stringWithFormat:@"%.2f万",baseInfo.tripDistance.floatValue / 10000.0];
    }
    self.fuelLb.text = [NSString stringWithFormat:@"%@%%",baseInfo.fuelMeter];
    self.detailTitleLb.text = baseInfo.carModelFullName;
    self.userInfoLb.text = [NSString stringWithFormat:@"%@ %@",baseInfo.userName,baseInfo.phone];
    NSString *url = [NSString stringWithFormat:@"https://www.wanguoqiche.com/files/logo/%@.jpg", baseInfo.carBrandLogo];
    [ self.carIconImv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"carModelDefault"]];
    
}

@end
