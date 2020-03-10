//
//  PCSexTextField.m
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCSexTextField.h"

@interface PCSexTextField ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation PCSexTextField

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
    self.datas = @[@{@"title":@"男",@"sex":@(0)},@{@"title":@"女",@"sex":@(1)}];
    self.inputView = self.pickerView;
    [self addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)textChange{
    self.text = self.datas.firstObject[@"title"];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.datas.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.datas[row][@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.text = self.datas[row][@"title"];
}


- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

@end
