//
//  YHAuctionCell.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/31.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAuctionCell.h"
#import <UIImageView+WebCache.h>

#import "TTZCarModel.h"
#import "YHCommon.h"


@interface YHAuctionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagIV;
@property (weak, nonatomic) IBOutlet UIImageView *carPictureIV;
@property (weak, nonatomic) IBOutlet UILabel *carNameLB;
@property (weak, nonatomic) IBOutlet UILabel *useTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *mileageBtn;
@property (weak, nonatomic) IBOutlet UILabel *winTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLB;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *winTimeHeight;

@property (weak, nonatomic) IBOutlet UIImageView *timeIconIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *timeContentView;


@property (nonatomic, weak) NSTimer *timer;

/** <##>倒计时*/
@property (nonatomic, assign) NSTimeInterval totalTime;

@end


@implementation YHAuctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(TTZCarModel *)model
{
    _model = model;
    
    
    [self.carPictureIV sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"carPicture"]];
    
    self.carNameLB.text = model.carName;
    
    self.priceLB.text = model.price;//model.price.length ? [NSString stringWithFormat:@"%@万",[self formatFloat:[model.price floatValue]]] : @"面议";
    
    self.mileageBtn.text = [NSString stringWithFormat:@"%@万 km",[self formatFloat:[model.mileage floatValue]/10000]];
    
    if (model.useTime.length) {
        self.useTimeBtn.text = [NSString stringWithFormat:@"%@",model.useTime];
    }else{
        self.useTimeBtn.text = @"年限未设置";
    }
    
    self.winTimeLB.text = model.winTime;
    self.winTimeHeight.constant = model.winTime.length ? 20 : 0;
    
    //正在竞拍： 0 待安排  1待开拍2 拍卖中(red)
    //竞拍记录： 0 流拍 1 服务费待支付(red) 2交易完成

    if (self.isInAuction) {
        self.priceLB.textColor = (model.carStatus == 2)? YHColor0X(0xD4502C, 1.0) : YHNaviColor;
        NSString *imageName = model.carStatus? ((model.carStatus>1)? @"拍卖中":@"待开拍"): @"待安排";
        self.flagIV.image = [UIImage imageNamed:imageName];
    
        self.priceTitleLB.text = @"价格";
        
        if (model.carStatus == 0) {
            //self.timeIconIV.hidden = YES;
            //self.timeLB.hidden = YES;
            self.timeContentView.hidden = YES;
        }else{
            //self.timeIconIV.hidden = NO;
            //self.timeLB.hidden = NO;
            self.timeContentView.hidden = NO;

            NSDateFormatter *fmt = [NSDateFormatter new];
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";

            
            NSTimeInterval nowTime  = [[NSDate date] timeIntervalSince1970] + self.time;
            NSTimeInterval startTime  = [[fmt dateFromString:model.startTime] timeIntervalSince1970];
            NSTimeInterval endTime  = [[fmt dateFromString:model.endTime] timeIntervalSince1970];

            if (model.carStatus == 1) {
                // now < start < end
                self.totalTime = startTime - nowTime;
            }else{
                // start < now < end
                self.totalTime = endTime - nowTime;
            }
            
        }
        
    }else{
        
        UIColor *textColor = model.carStatus? ((model.carStatus>1)? YHNaviColor:YHColor0X(0xD4502C, 1.0)): YHColor0X(0x999999, 1.0);
        self.priceLB.textColor = textColor;

        NSString *imageName = model.carStatus? ((model.carStatus>1)? @"jiao-yi":@"待支付"): @"liu pai";
        self.flagIV.image = [UIImage imageNamed:imageName];
        
        NSString *statusTitle = (model.carStatus == 0)? @"价格" : @"成交价";
        self.priceTitleLB.text = statusTitle;
        
        //self.timeIconIV.hidden = YES;
        //self.timeLB.hidden = YES;
        self.timeContentView.hidden = YES;


    }

}

- (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}


- (void)setTotalTime:(NSTimeInterval)totalTime{
    _totalTime = totalTime;
    [self timer];
}

- (NSTimer *)timer{
    if (!_timer) {
         __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(timeChange:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.totalTime = 0;
    }
}

- (void)timeChange:(NSTimer *)sender{
    NSLog(@"%s", __func__);
    if(self.totalTime > 0){
        self.totalTime --;
        int days = ((int)self.totalTime)/(3600*24);
        int hours = ((int)self.totalTime)%(3600*24)/3600;
        int minutes = ((int)self.totalTime)%(3600*24)%3600/60;
        int seconds = ((int)self.totalTime)%(3600*24)%3600%60;
        self.timeLB.text = [[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds];
        //NSLog(@"曹志剩下:%@",[[NSString alloc] initWithFormat:@"%i天%i时%i分%i秒",days,hours,minutes,seconds]);
    }else{
        [self.timer invalidate];
        self.timer = nil;
        !(_getNewData)? : _getNewData();
    }
}


@end
