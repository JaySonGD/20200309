//
//  YHCaptureCarCell0.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCaptureCarCell0.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <UIImageView+WebCache.h>
#import "UIColor+ColorChange.h"
#import "NSDate+BRAdd.h"


@implementation YHCaptureCarCell0

- (void)refreshUIWithModel:(YHCaptureCarModel0 *)model WithTag:(NSInteger)tag WithRow:(NSInteger)row WithCode:(NSInteger)code
{
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"carPicture"]];
    self.describeLabel.text = model.name;
    self.useTimeLabel.text = model.useTime;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.mileage];
    
    //竞价中
    if (tag == 1) {
        //是否有效（我是否是最高价） 0 无效（不是最高价） 1 有效（是最高价）
        if ([model.status isEqualToString:@"1"]) {
            self.priceRemindingLabel.text = @"我的价格";
            self.priceLabel.textColor = [UIColor redColor];
        } else if ([model.status isEqualToString:@"0"]){
            self.priceRemindingLabel.text = @"当前价格";
            self.priceLabel.textColor = YHNaviColor;
        }
        if (IsEmptyStr(model.topPrice)) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.bottomPrice floatValue]];
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.topPrice floatValue]];
        }
    //即将开拍、竞价记录
    } else {
        self.priceLabel.textColor = YHNaviColor;
        self.priceRemindingLabel.text = @"当前价格";
        if (IsEmptyStr(model.topPrice)) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.bottomPrice floatValue]];
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.02f万",[model.topPrice floatValue]];
        }
    }
    
    //倒计时
    [self getTimeIntervalWithStartTime:model.startTime WithEndTime:model.endTime];
    
    //记录倒计时为0的index
    self.countDownRow = row;
    
    self.countDownCode = code;
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
    
    NSLog(@"1=======startTime:%@===startDate:%@=======",startTime,self.startDate);
    NSLog(@"2=======endTime:%@=====endDate:%@=======",endTime,self.endDate);
    NSLog(@"3=======nowDate系统当前时间:%@=======",self.currentDate);

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
        
        //发出通知
        if (self.countDownCode == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"竞价现场倒计时结束刷新" object:nil userInfo:@{@"countDownRow":@(self.countDownRow)}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"我的竞价倒计时结束刷新" object:nil userInfo:@{@"countDownRow":@(self.countDownRow)}];
        }
        
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

//===================================================================================================================
-(void)setModel:(YHDetectionRecordModel *)model
{
    _model = model;
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"icon_car"]];
    self.describeLabel.text = model.desc;
    
    if (!IsEmptyStr(model.prodDate)) {
        NSDateComponents *cmps = [self pleaseInsertStarTime:model.prodDate andInsertEndTime:[NSDate currentDateString]];
        NSString *useTime = @"";
        if (cmps.month ==0) {
            useTime = [NSString stringWithFormat:@"%ld年",cmps.year];
        }else{
            useTime = [NSString stringWithFormat:@"%ld年%ld个月",cmps.year, cmps.month];
        }
        self.useTimeLabel.text = useTime;
    }else{
        self.useTimeLabel.text = @"年限未设置";
    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.0f km",model.km];
    
    self.timeIcon.hidden = YES;
    self.priceRemindingLabel.hidden = YES;
    self.priceLabel.hidden = YES;
    
//    if (model.price >0) {
//        self.priceLabel.textColor = [UIColor colorWithHexString:@"00ADFF"];
//        self.priceLabel.text = [NSString stringWithFormat:@"%.2f万",model.price];
//        self.priceLabel.font = [UIFont systemFontOfSize:17];
//        self.priceLabel.textAlignment = NSTextAlignmentLeft;
//        self.priceLabel.layer.borderColor = [UIColor clearColor].CGColor;
//        self.priceLabel.layer.cornerRadius = 0.;//边框圆角大小
//        self.priceLabel.layer.borderWidth = 0;//边框宽度
//        self.priceLabel.layer.masksToBounds = YES;
//        self.priceWeight.constant = 100;
//    }else{
//        self.priceRemindingLabel.hidden = YES;
//        self.priceLabel.hidden = YES;
//        self.priceLabel.text = @"未设置";
//        [self.priceLabel sizeToFit];
//        self.priceLabel.font = [UIFont systemFontOfSize:12];
//        self.priceLabel.textColor = [UIColor colorWithHexString:@"DD4F2D"];
//        self.priceLabel.layer.borderColor = [UIColor colorWithHexString:@"DD4F2D"].CGColor;
//        self.priceLabel.textAlignment = NSTextAlignmentCenter;
//        self.priceLabel.layer.cornerRadius = 5.;//边框圆角大小
//        self.priceLabel.layer.masksToBounds = YES;
//        self.priceLabel.layer.borderWidth = 1;//边框宽度
//        self.priceWeight.constant = 50;
//    }
    //将倒计时图标进行隐藏
    self.timeIcon.image = nil;
    self.timeHeight.constant = 0;
}

/**
 计算时间差
 */
- (NSDateComponents *)pleaseInsertStarTime:(NSString *)time1 andInsertEndTime:(NSString *)time2
{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    return cmps;
}

@end

