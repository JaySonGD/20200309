//
//  YHHelpCheckCell0.m
//  YHCaptureCar
//
//  Created by mwf on 2018/4/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHHelpCheckCell0.h"
#import "YHCommon.h"
#import "YHTools.h"
@implementation YHHelpCheckCell0

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)refreshUIWithModel:(YHHelpCheckModel0 *)model
{
    //1.检测点
    self.orgNameL.text = model.orgName;
    
    //2.车型车系
    self.carDescL.text = model.carDesc;
    
    //3.预约时间
    self.bookDateL.text = model.bookDate;
    
    //4.检测状态
    //(1)0-待检测
    if ([model.orderStatus isEqualToString:@"0"]){
        self.isCheckedI.hidden = NO;
        [self.isCheckedI setImage:[UIImage imageNamed:@"icon_UnChecked"]];
    //(2)1-检测完成
    } else if ([model.orderStatus isEqualToString:@"1"]){
        self.isCheckedI.hidden = NO;
        [self.isCheckedI setImage:[UIImage imageNamed:@"icon_Checked"]];
    //(3)其它情况下隐藏
    } else {
        self.isCheckedI.hidden = YES;
    }
    
    //5.款项状态
    //-1 申请退款
    //(1)-1 待接单
    if ([model.orderStatus isEqualToString:@"-1"]) {
        //待支付
        if ([model.payStatus isEqualToString:@"0"]) {
            self.applyRefundB.tag = 1;
            self.applyRefundB.hidden = NO;
            self.applyRefundB.userInteractionEnabled = YES;
            [self.applyRefundB setBackgroundImage:[UIImage imageNamed:@"icon_WaitPay"] forState:UIControlStateNormal];
        //1 支付完成:申请退款
        } else if ([model.payStatus isEqualToString:@"1"]) {
            //(2)当前日期 >= 预约日期+1天的日期 、(3)当前时间 >= 09:00:00
            if (([self compareTimeWithBookTime:model.bookDate WithNowTimeDate:[NSDate date]] == YES)) {
                self.applyRefundB.tag = 2;
                self.applyRefundB.hidden = NO;
                self.applyRefundB.userInteractionEnabled = YES;
                [self.applyRefundB setBackgroundImage:[UIImage imageNamed:@"icon_ApplyRefund"] forState:UIControlStateNormal];
            } else {
                self.applyRefundB.hidden = YES;
            }
        //2 支付失败
        } else {
            self.applyRefundB.hidden = YES;
        }
    //3-退款中
    } else if ([model.orderStatus isEqualToString:@"3"]){
        self.applyRefundB.hidden = NO;
        self.applyRefundB.userInteractionEnabled = NO;
        [self.applyRefundB setBackgroundImage:[UIImage imageNamed:@"icon_Refunding"] forState:UIControlStateNormal];
    //4-已退款
    } else if ([model.orderStatus isEqualToString:@"4"]){
        self.applyRefundB.hidden = NO;
        self.applyRefundB.userInteractionEnabled = NO;
        [self.applyRefundB setBackgroundImage:[UIImage imageNamed:@"icon_Refunded"] forState:UIControlStateNormal];
    //5-已过期
    } else if ([model.orderStatus isEqualToString:@"5"]){
        self.applyRefundB.hidden = NO;
        self.applyRefundB.userInteractionEnabled = NO;
        [self.applyRefundB setBackgroundImage:[UIImage imageNamed:@"icon_Expired"] forState:UIControlStateNormal];
    //6-历史车况
    }else if ([model.orderStatus isEqualToString:@"6"]){
        self.applyRefundB.hidden = NO;
        self.applyRefundB.userInteractionEnabled = NO;
        [self.applyRefundB setBackgroundImage:[UIImage imageNamed:@"historyCarStatus"] forState:UIControlStateNormal];
    } else {
        self.applyRefundB.hidden = YES;
        //self.applyRefundB.userInteractionEnabled = NO;
    }
}

- (BOOL)compareTimeWithBookTime:(NSString *)bookTime WithNowTimeDate:(NSDate *)nowDate
{
    //1.首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //2.然后创建日期对象
    NSDate *bookDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",bookTime]];
    
    //3.计算某个日期一定天数后的新日期
    NSDate *newBookDate = [bookDate dateByAddingTimeInterval:60*60*24*1];

    //4.比较时间
    //预约日期+1天的日期 compare 当前日期
    NSComparisonResult result1 = [[YHTools stringFromDate:newBookDate byFormatter:@"yyyy-MM-dd"] compare:[YHTools stringFromDate:nowDate byFormatter:@"yyyy-MM-dd"]];
    
    //09:00:00 compare 当前时间
    NSComparisonResult result2 = [@"09:00:00" compare: [[YHTools stringFromDate:nowDate byFormatter:@"yyyy-MM-dd HH:mm:ss"]substringWithRange:NSMakeRange(11, 8)]];
    
    //1.升序或相等：当前日期 >= 预约日期+1天的日期
    if (result1 != NSOrderedDescending) {
        //(1)当前时间 >= 09:00
        if (result2 != NSOrderedDescending) {
            return YES;
        //(2)当前时间 < 09:00
        } else {
            return NO;
        }
    //1.降序：预约日期+1天的日期 < 当前日期
    } else {
        return NO;
    }
    
    //    NSLog(@"1====---预约日期：%@---====",bookTime);
    //    NSLog(@"2====---预约日期：%@---====",[YHTools stringFromDate:bookDate byFormatter:@"yyyy-MM-dd"]);
    //    NSLog(@"3====---预约日期+1天的日期：%@---====",[YHTools stringFromDate:newBookDate byFormatter:@"yyyy-MM-dd"]);
    //    NSLog(@"4====---当前日期：%@---====",[YHTools stringFromDate:nowDate byFormatter:@"yyyy-MM-dd"]);
    //    NSString *str = [[YHTools stringFromDate:nowDate byFormatter:@"yyyy-MM-dd HH:mm:ss"]substringWithRange:NSMakeRange(11, 8)];
    //    NSLog(@"5====---当前时间：%@==%ld---====",str,str.length);
    //    NSLog(@"6====---result1：%ld==result2：%ld---====",result1,result2);
    //    NSLog(@"=========================================================================");
}

- (IBAction)ClickBtn:(UIButton *)sender
{
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
}

@end
