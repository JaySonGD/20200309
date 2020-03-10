//
//  YHCaptureCarCell1.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCaptureCarModel0.h"

@interface YHCaptureCarCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *validImageView;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fareNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRemindingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *highestImageView;
@property (weak, nonatomic) IBOutlet UILabel *calculationLabel;


@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, assign) NSTimeInterval timeInterval;//时间间隔
@property (nonatomic, strong) NSDateFormatter *dateFormatter;//日期格式化对象
@property (nonatomic, strong) NSDate *startDate;//竞拍开始时间
@property (nonatomic, strong) NSDate *endDate;//竞拍结束时间
@property (nonatomic, strong) NSDate *currentDate;//当前时间
@property (nonatomic, assign) NSInteger countDownRow;//倒计时为0的index

- (void)refreshUIWithModel:(YHCaptureCarModel0 *)model WithTag:(NSInteger)tag;

@end
