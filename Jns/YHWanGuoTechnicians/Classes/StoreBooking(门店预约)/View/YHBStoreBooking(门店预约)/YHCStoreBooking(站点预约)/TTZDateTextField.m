//
//  TTZDateTextField.m
//  DateKeyboard
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZDateTextField.h"

@interface TTZDateTextField()
@property (nonatomic, strong) UIDatePicker *keyboard;
@end

@implementation TTZDateTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}
//FIXME:  -  事件监听
- (void)textChange{
    NSLog(@"%s", __func__);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *text = [fmt stringFromDate:self.keyboard.date];
    !(_valueChange)? : _valueChange(text);
    self.text = text;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (void)setUI{
//
//    UIDatePicker *picker = [[UIDatePicker alloc] init];
//    picker.datePickerMode = UIDatePickerModeDate;
//    picker.minimumDate = [NSDate date];
//    picker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:15 * 24 * 3600];
    self.inputView = self.keyboard;
    [self addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidBegin];
}


- (void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
    self.keyboard.maximumDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    self.keyboard.minimumDate = minDate;
}

- (UIDatePicker *)keyboard{
    if (!_keyboard) {
        _keyboard = [[UIDatePicker alloc] init];
        _keyboard.datePickerMode = UIDatePickerModeDate;
        _keyboard.minimumDate = [NSDate date];
        _keyboard.maximumDate = [NSDate dateWithTimeIntervalSinceNow:14 * 24 * 3600];
        [_keyboard addTarget:self action:@selector(textChange) forControlEvents:UIControlEventValueChanged];
    }
    return _keyboard;
}

@end
