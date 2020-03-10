//
//  YHCustomDatePicker.h
//  YHCaptureCar
//
//  Created by liusong on 2018/9/15.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCustomDatePicker : UIView

@property (nonatomic, copy) void(^datePickerValueChange)(UIDatePicker *picker);

- (void)setDatePickerMinDate:(NSDate *)minDate;
- (void)setDatePickerMaxDate:(NSDate *)maxDate;

@end
