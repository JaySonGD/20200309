//
//  YHProfitSearchView.h
//  YHCaptureCar
//
//  Created by liusong on 2018/9/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YHProfitSearchViewSelectTimeNone,
    YHProfitSearchViewSelectTimeStart, // 点击开始时间
    YHProfitSearchViewSelectTimeEnd, // 点击结束时间
} YHProfitSearchViewSelectTime;

@interface YHProfitSearchView : UIView

@property (nonatomic, readonly, assign) YHProfitSearchViewSelectTime selectTimeType;

@property (nonatomic, copy) void(^clickStartTimeBlock)(void);

@property (nonatomic, copy) void(^clickEndTimeBlock)(void);

@property (nonatomic, copy) void(^clickQueryBtnBlock)(void);

- (void)setStartTimeLabelText:(NSString *)text;
- (void)setEndTimeLableText:(NSString *)text;

- (NSString *)getStartTimeText;
- (NSString *)getEndTimeText;

- (NSDate *)getStartDate;
- (NSDate *)getEndDate;

@end
