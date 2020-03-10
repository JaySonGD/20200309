//
//  YHReservationNewVC.m
//  YHCaptureCar
//
//  Created by Liangtao Yu on 2019/5/25.
//  Copyright © 2019 YH. All rights reserved.
//

#import "YHReservationNewVC.h"
#import <BRDatePickerView.h>
#import "NSDate+BRAdd.h"
#import "UIColor+ColorChange.h"
#import "MBProgressHUD+MJ.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "UITextView+Placeholder.h"
#import "YHDetectionCenterVC.h"

/*
 判断字符串是否为空
 */
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@" "] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

@interface YHReservationNewVC ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *makePersonPhTf;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSelSc;
@property (weak, nonatomic) IBOutlet UITextField *makePersonTf;
@property (weak, nonatomic) IBOutlet UILabel *makeSiteLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTv;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;

/** 显示日期时间数据 */
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, weak) UIPickerView *pickerView;
/** 默认选择日期 */
@property (nonatomic, copy) NSString *calenderStr;
/** 默认选择时间 */
@property (nonatomic, copy) NSString *timeStr;
/** 用户选择的日期 */
@property (nonatomic, copy) NSString *selectCalenderStr;
/** 用户选择的时间 */
@property (nonatomic, copy) NSString *selectTimeStr;

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, weak) UIButton *allBtn;//蒙版

@property (nonatomic, assign) BOOL isSelectedTime;

@property (nonatomic, assign) NSInteger selectRow;
/** 当天的日期*/
@property (nonatomic, copy) NSString *currentResultStr;

@end

@implementation YHReservationNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增预约";
    self.makeSiteLab.text = self.isFirst ? self.reservationM.stationName :self.reservationM.name ;
    self.view.frame = CGRectMake(0,0,10, 20);
    
    self.makePersonPhTf.text = [YHTools getName].length < 11 ? @"" : [YHTools getName];
    
    [self.makePersonPhTf addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.makePersonTf addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.sexSelSc.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName:[UIColor colorWithHexString:@"373737"]};
    [self.sexSelSc setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor colorWithHexString:@"cccccc"]};
    [self.sexSelSc setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];

    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.scrollView.frame.size.height > self.scrollView.contentSize.height){
            self.scrollView.contentSize = CGSizeMake(0,self.scrollView.frame.size.height + 20);
            [self.view addSubview:self.confirmBtn];
            [self.confirmBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.right.offset(-20);
                make.height.offset(54);
                make.bottom.offset(-28);
            }];
        }
    });

}


-(void)textViewDidChange:(UITextView *)textView{
  
    if (self.makePersonPhTf.text.length > 11){
        //超出限制字数时所要做的事
        self.makePersonPhTf.text = [self.makePersonPhTf.text substringToIndex: 11];
        [MBProgressHUD showError:@"手机号不能超过11位"];
    }
    
    if(self.makePersonTf.text.length > 15){
        //超出限制字数时所要做的事
        self.makePersonTf.text = [self.makePersonTf.text substringToIndex: 15];
        [MBProgressHUD showError:@"输入名称限制15字以内1!"];
    }
    
    if(self.remarkTv.text.length > 255){
        //超出限制字数时所要做的事
        self.remarkTv.text = [self.remarkTv.text substringToIndex: 255];
        [MBProgressHUD showError:@"备注说明限制255字以内!"];
    }
    
}


- (IBAction)selDayTouchDown:(UITapGestureRecognizer *)sender {
    
    [self selectArriveShopTime];
}

#pragma mark - 选择时间 ----
- (void)selectArriveShopTime{
    
    self.isSelectedTime = YES;
    
    [self setUpRequireData];
    
    if(!self.pickerView){
        
    UIButton *allBtn = [[UIButton alloc] init];
    self.allBtn = allBtn;
    allBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
    [self.view addSubview:allBtn];
    [allBtn addTarget:self action:@selector(canleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
        
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [allBtn addSubview:pickerView];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@150);
    }];
    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    [allBtn addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickerView);
        make.right.equalTo(pickerView);
        make.bottom.equalTo(pickerView.mas_top);
        make.height.equalTo(@30);
    }];
    
    UIView *seprateLine = [[UIView alloc] init];
    seprateLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:203.0/255.0 blue:209.0/255.0 alpha:1.0];
    [topView addSubview:seprateLine];
    [seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    UIView *seprateLine1 = [[UIView alloc] init];
    seprateLine1.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:203.0/255.0 blue:209.0/255.0 alpha:1.0];
    [topView addSubview:seprateLine1];
    [seprateLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
        
    
    UIButton *completeBtn = [[UIButton alloc] init];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor colorWithRed:64.0/255.0 green:141.0/255.0 blue:252.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [topView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(completeBtn.superview);
        make.right.equalTo(@(-10));
        make.height.equalTo(completeBtn.superview);
        make.width.equalTo(@40);
    }];
        
    }
    
    // 默认选择
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    self.selectCalenderStr = self.calenderStr;
    self.selectTimeStr = self.timeStr;
    
    [self.pickerView reloadAllComponents];
        
}
- (void)completeBtnClick{
    
    [self canleBtnClick];
    
    self.dayLab.text = [NSString stringWithFormat:@"%@ %@",_selectCalenderStr,_selectTimeStr];
}

- (void)canleBtnClick{
    
    [self.allBtn removeFromSuperview];
    
}

#pragma mark - 初始化日期数据 ----
- (void)setUpRequireData{
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateComponents *components = [[NSCalendar currentCalendar] componentsInTimeZone:timeZone fromDate:[NSDate date]];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger hour = components.hour;
    // 当天日期
    self.currentResultStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,day];
    
    NSInteger daysInMonth = [self getDayNumbersForMonth:year month:month];
    NSInteger tempDay = day;
    NSInteger tempMonth = month;
    NSInteger tempYear = year;
    
    if (hour >= 16) {
        tempDay += 1;
    }
    
    NSMutableArray *dateArr = @[].mutableCopy;
    for (int i = 0; i<30; i++) {
        
        if (tempDay > daysInMonth) {
            tempDay = tempDay - daysInMonth;
            tempMonth = month + 1;
            
            if (tempMonth > 12) {
                tempYear = year + 1;
            }
        }
        NSString *dateTitle = [NSString stringWithFormat:@"%ld-%02ld-%02ld",tempYear,tempMonth,tempDay];
        [dateArr addObject:dateTitle];
        tempDay = tempDay + 1;
    }
    
    NSMutableArray *timeArr = @[
                                @"09:00~10:00",
                                @"10:00~11:00",
                                @"11:00~12:00",
                                @"12:00~13:00",
                                @"13:00~14:00",
                                @"14:00~15:00",
                                @"15:00~16:00"].mutableCopy;
    
    self.titleArr = [NSMutableArray arrayWithObjects:dateArr,timeArr, nil];
    
    // 设置初值
    if (hour >= 16) {
        day++;
        if (day > daysInMonth) {
            month++;
        }
        if (month > 12) {
            year++;
        }
        self.calenderStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,day];
        self.timeStr = [NSString stringWithFormat:@"09:00~10:00"];
    }else{
        self.calenderStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,day];
        self.timeStr = [NSString stringWithFormat:@"%02ld:00~%02ld:00",hour,hour + 1];
    }
   
    if (hour >= 9 && hour < 10) {
        self.selectRow = 0;
    }else if (hour >= 10 && hour < 11) {
        self.selectRow = 1;
        
    }else if (hour >= 11 && hour < 12) {
        
        self.selectRow = 2;
        
    }else if (hour >= 12 && hour < 13) {
        self.selectRow = 3;
        
    }else if (hour >= 13 && hour < 14) {
        
        self.selectRow = 4;
    }else if (hour >= 14 && hour < 15) {
        
        self.selectRow = 5;
    }else if(hour >= 15 && hour < 16) {
        
        self.selectRow = 6;
    }else{
        self.selectRow = 0;
    }
    
}
#pragma mark - 获取每个月天数 --
- (NSInteger)getDayNumbersForMonth:(NSInteger)year month:(NSInteger)month{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%02ld",year,month];
    NSDate * date = [formatter dateFromString:dateStr];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}
#pragma mark - UIPickerViewDataSource ----
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return 30;
    }
    
    if ([self.currentResultStr isEqualToString:self.selectCalenderStr]) {
        return 7 - self.selectRow;
    }
    return 7;
    
}
#pragma mark - UIPickerViewDelegate --
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.titleArr[component][row];
    }
    
    if ([self.currentResultStr isEqualToString:self.selectCalenderStr]){
        row = row + self.selectRow;
    }
    
    return self.titleArr[component][row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        self.selectCalenderStr = self.titleArr[component][row];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        self.selectTimeStr = [self.currentResultStr isEqualToString:self.selectCalenderStr] ? self.timeStr:@"09:00~10:00";
    }
    
    if (component == 1){
        
        if ([self.currentResultStr isEqualToString:self.selectCalenderStr]){
            row = row + self.selectRow;
        }
        self.selectTimeStr = self.titleArr[component][row];
    }
}


//提交预约申请
- (IBAction)SubmitAppointment:(UIButton *)sender {
    
    
    if (NULLString(self.makePersonTf.text)) {
        [MBProgressHUD showError:@"预约人不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (NULLString(self.makePersonPhTf.text)) {
        [MBProgressHUD showError:@"手机号不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (![self validatePhone:self.makePersonPhTf.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (!self.dayLab.text.length) {
        [MBProgressHUD showError:@"请选择预约时间" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    
    NSString * stationId = [NSString stringWithFormat:@"%@",self.isFirst ? self.reservationM.stationId : self.reservationM.ID];
    if (NULLString(stationId)) {
        [MBProgressHUD showError:@"传入站点ID不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
     NSString * stationName = [NSString stringWithFormat:@"%@",self.isFirst ? self.reservationM.stationName : self.reservationM.name];
    if (NULLString(stationName)) {
        [MBProgressHUD showError:@"站点名称不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    NSString *person = [NSString stringWithFormat:@"%@%@",self.makePersonTf.text,self.sexSelSc.selectedSegmentIndex ? @"女士" : @"先生" ];
    
    NSRange rang = [self.selectTimeStr rangeOfString:@"~"];
    NSString *stratTime = [NSString stringWithFormat:@"%@ %@:00",self.selectCalenderStr,[self.selectTimeStr substringToIndex:rang.location]];
    NSString *endTime = [NSString stringWithFormat:@"%@ %@:00",self.selectCalenderStr,[self.selectTimeStr substringFromIndex:rang.location + rang.length]];
    
    
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkManager sharedYHNetworkManager]appointmentInspectionWithToken:[YHTools getAccessToken] orgId:stationId userPhone:self.makePersonPhTf.text orgName:stationName userName:person arrivalStartTime:stratTime
                                                              arrivalEndTime:endTime desc:self.remarkTv.text onComplete:^(NSDictionary *info) {
        
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"预约成功" toView:self.navigationController.view];
            //发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:PopToBeDetectionVCNotification object:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[YHDetectionCenterVC class]]) {
                    [weakSelf.navigationController popToViewController:vc  animated:YES];
                }
            }
        }else{
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        
    }];
}


//隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self completeBtnClick];
}

//判断是否为手机号
- (BOOL)validatePhone:(NSString *)phone{
    NSString *phoneRegex = @"1[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

//判断是否为数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}



@end
