//
//  YHCaptureCarCell0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/10.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCaptureCarModel0.h"
#import "YHDetectionRecordModel.h"//检测列表

@interface YHCaptureCarCell0 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRemindingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWeight;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (nonatomic, strong) NSTimer *timer;                     //定时器
@property (nonatomic, assign) NSTimeInterval timeInterval;        //时间间隔
@property (nonatomic, strong) NSDateFormatter *dateFormatter;     //日期格式化对象
@property (nonatomic, strong) NSDate *startDate;                  //竞拍开始时间
@property (nonatomic, strong) NSDate *endDate;                    //竞拍结束时间
@property (nonatomic, strong) NSDate *currentDate;                //当前时间
@property (nonatomic, assign) NSInteger countDownRow;             //倒计时为0的index
@property (nonatomic, assign) NSInteger countDownCode;
@property (nonatomic, strong) YHDetectionRecordModel *model;

- (void)refreshUIWithModel:(YHCaptureCarModel0 *)model WithTag:(NSInteger)tag WithRow:(NSInteger)row WithCode:(NSInteger)code;

@end
