//
//  YHCustomDatePicker.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/15.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCustomDatePicker.h"

@interface YHCustomDatePicker ()

@property (nonatomic, weak) UIDatePicker *datePicker;

@end

@implementation YHCustomDatePicker

- (instancetype)init{
    if (self = [super init]) {
        [self initCustomDataPickerView];
    }
    return self;
}
- (void)setDatePickerMinDate:(NSDate *)minDate{
    
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = nil;
}
- (void)setDatePickerMaxDate:(NSDate *)maxDate{
    self.datePicker.maximumDate = maxDate;
    self.datePicker.minimumDate = nil;
}

- (void)initCustomDataPickerView{

    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@34);
    }];
    
    UIView *seprateLine = [[UIView alloc] init];
    seprateLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:203.0/255.0 blue:209.0/255.0 alpha:1.0];
    [toolBar addSubview:seprateLine];
    [seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    UILabel *premptL = [[UILabel alloc] init];
    premptL.textColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    premptL.font = [UIFont systemFontOfSize:14.0];
    [toolBar addSubview:premptL];
    premptL.text = @"请选择日期";
    [premptL sizeToFit];
    [premptL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(premptL.superview);
    }];
    
    UIButton *completeBtn = [[UIButton alloc] init];
    [completeBtn addTarget:self action:@selector(compelteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor colorWithRed:64.0/255.0 green:141.0/255.0 blue:252.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [toolBar addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.centerY.equalTo(completeBtn.superview);
    }];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    [datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:203.0/255.0 blue:209.0/255.0 alpha:1.0];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(datePicker.superview);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(toolBar.mas_bottom);
    }];
}
- (void)valueChange:(UIDatePicker *)picker{
    
    if (_datePickerValueChange) {
        _datePickerValueChange(_datePicker);
    }
}
- (void)compelteBtnClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
@end
