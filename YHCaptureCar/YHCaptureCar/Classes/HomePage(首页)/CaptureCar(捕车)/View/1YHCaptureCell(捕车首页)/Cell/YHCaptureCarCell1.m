//
//  YHCaptureCarCell1.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCaptureCarCell1.h"
#import "YHCommon.h"
#import <UIImageView+WebCache.h>

@implementation YHCaptureCarCell1

- (void)refreshUIWithModel:(YHCaptureCarModel0 *)model WithTag:(NSInteger)tag
{
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"carPicture"]];
    self.describeLabel.text = model.name;
    self.useTimeLabel.text = model.useTime;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.mileage];
    self.bidNumLabel.text = model.bidNum;
    self.fareNumLabel.text = model.raisePrice;
    self.calculationLabel.hidden = YES;

    //正在参与的竞价:topPrice
    if (tag == 1) {
        //是否有效（我是否是最高价: 0 无效（不是最高价） ;1 有效（是最高价）)
        if ([model.status isEqualToString:@"1"]) {
            [self.validImageView setImage:[UIImage imageNamed:@"icon_valid"]];
            self.priceRemindingLabel.text = @"我的价格";
            self.priceLabel.textColor = [UIColor redColor];
            self.highestImageView.hidden = NO;
        } else if ([model.status isEqualToString:@"0"]){
            [self.validImageView setImage:[UIImage imageNamed:@"icon_invalid"]];
            self.priceRemindingLabel.text = @"当前价格";
            self.priceLabel.textColor = YHNaviColor;
            self.highestImageView.hidden = YES;
        }
        
        if (IsEmptyStr(model.topPrice)) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.bottomPrice floatValue]];
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.topPrice floatValue]];
        }
    //竞价记录:topPrice
    } else {
        self.priceRemindingLabel.text = @"当前价格";
        self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.topPrice floatValue]];
    }
    
    //倒计时
    [self getTimeIntervalWithStartTime:model.startTime WithEndTime:model.endTime];
}

//获取时间间隔
- (void)getTimeIntervalWithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    //1.创建日期格式化对象
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //2.创建日期对象
    self.startDate = [self.dateFormatter dateFromString:startTime];
    self.endDate = [self.dateFormatter dateFromString:endTime];
    self.currentDate = [NSDate date];
    
    //3.计算时间间隔（单位是秒）
    self.timeInterval = [self.startDate timeIntervalSinceDate:self.currentDate];
    
    //(1)如果起始时间 > 当前时间,说明未开拍: startTime - now()
    if (self.timeInterval > 0) {
        self.timeInterval = [self.startDate timeIntervalSinceDate:self.currentDate];
    //(2)如果起始时间 < 当前时间,说明已开拍: endTime - now()
    } else {
        self.timeInterval = [self.endDate timeIntervalSinceDate:self.currentDate];
    }
    
    //4.启动倒计时
    if (!self.timer) {
        //创建定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    } else {
        //打开定时器
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)action:(NSTimer *)timer
{
    self.timeInterval -= 1;
    
    if(self.timeInterval <= 0) {
        //关闭定时器
        [self.timer setFireDate:[NSDate distantFuture]];
        //更改UI
        self.calculationLabel.hidden = NO;
        self.priceRemindingLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.highestImageView.hidden = YES;
        return;
    }
    
    //计算天数、时、分、秒
    int days = ((int)self.timeInterval)/(3600*24);
    int hours = ((int)self.timeInterval)%(3600*24)/3600;
    int minutes = ((int)self.timeInterval)%(3600*24)%3600/60;
    int seconds = ((int)self.timeInterval)%(3600*24)%3600%60;
    
    if (days > 0) {
        self.remainingTimeLabel.text = [[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds];
    } else {
        self.remainingTimeLabel.text = [[NSString alloc] initWithFormat:@"%i时%i分%i秒",hours,minutes,seconds];
    }
    //NSLog(@"倒计时:%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minutes,seconds]);
}

@end
