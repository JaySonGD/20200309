//
//  YHAppointmentOrderController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/10/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAppointmentOrderController.h"
#import "YHUserAppointmentDetailView.h"
#import "YHAppointmentArriveTimeView.h"
#import "NewBillViewController.h"

@interface YHAppointmentOrderController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) YHUserAppointmentDetailView *userAppointmentDetailView;

@property (nonatomic, weak) YHAppointmentArriveTimeView *arriveShopView;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIButton *bottomBtn;

@property (nonatomic, copy) NSDictionary *data;
/** 显示日期时间数据 */
@property (nonatomic, strong) NSMutableArray *titleArr;

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

@property (nonatomic, assign) BOOL isSelectedTime;

@property (nonatomic, assign) NSInteger selectRow;
/** 当天的日期*/
@property (nonatomic, copy) NSString *currentResultStr;

@end

@implementation YHAppointmentOrderController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
    
    [self initAppointmentUI];
    
    [self requestData];
    
}
- (void)initBase{
    self.title = @"工单详情";
    self.isSelectedTime = NO;
    self.selectRow = 0;
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
    
    // isVerifier = YES 没有工单关闭权限  NO 有关闭工单权限
    BOOL isVerifier = NO;
    if (!isVerifier) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭工单" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }else{
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)clickRightItem{
    
    [self endBill:nil];
    
}
- (void)initAppointmentUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.hidden = YES;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView.superview);
        make.width.equalTo(contentView.superview);
    }];
    
    YHUserAppointmentDetailView *userAppointmentDetailView = [[NSBundle mainBundle] loadNibNamed:@"YHUserAppointmentDetailView" owner:nil options:nil].firstObject;
    self.userAppointmentDetailView = userAppointmentDetailView;
    userAppointmentDetailView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:userAppointmentDetailView];
    [userAppointmentDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
    }];
    
    YHAppointmentArriveTimeView *arriveShopView = [[NSBundle mainBundle] loadNibNamed:@"YHAppointmentArriveTimeView" owner:nil options:nil].firstObject;
    self.arriveShopView = arriveShopView;
    arriveShopView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:arriveShopView];
    [arriveShopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userAppointmentDetailView.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@127);
    }];
    
    CGFloat bottomMargin = iPhoneX ? 34 : 10;
    CGFloat resultBottom = bottomMargin + 60;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(arriveShopView.mas_bottom).offset(resultBottom);
    }];
    
    UIButton *bottomBtn = [[UIButton alloc] init];
    self.bottomBtn = bottomBtn;
    bottomBtn.hidden = YES;
    [self.view addSubview:bottomBtn];
    bottomBtn.backgroundColor = YHNaviColor;
    bottomBtn.layer.cornerRadius = 5.0;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn setTitle:@"推送车主" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat bottomMarginBtn = iPhoneX ? -34 : -10;
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(bottomBtn.superview).offset(-10);
        make.bottom.equalTo(bottomBtn.superview).offset(bottomMarginBtn);
        make.height.equalTo(@40);
    }];
    
    __weak typeof(self)weakSelf = self;
    arriveShopView.selectArriveTime = ^{
        
        [weakSelf selectArriveShopTime];
    };
}
#pragma mark - 选择时间 ----
- (void)selectArriveShopTime{
 
    self.isSelectedTime = YES;
    
    [self setUpRequireData];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:203.0/255.0 blue:209.0/255.0 alpha:1.0];
    self.pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@150);
    }];
    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
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
    
    // 默认选择
    [pickerView selectRow:0 inComponent:1 animated:YES];
    self.selectCalenderStr = self.calenderStr;
    self.selectTimeStr = self.timeStr;
    
    [pickerView reloadAllComponents];
}
- (void)completeBtnClick{
    
    [self.topView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    
    self.topView = nil;
    self.pickerView = nil;
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
    self.currentResultStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    
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
        NSString *dateTitle = [NSString stringWithFormat:@"%ld-%ld-%ld",tempYear,tempMonth,tempDay];
        [dateArr addObject:dateTitle];
        tempDay = tempDay + 1;
    }
    
    NSMutableArray *timeArr = @[
                                @"9:00~10:00",
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
        self.calenderStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        self.timeStr = [NSString stringWithFormat:@"9:00~10:00"];
    }else{
        self.calenderStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        self.timeStr = [NSString stringWithFormat:@"%ld:00~%ld:00",hour,hour + 1];
    }
    self.arriveShopView.arriveShopTimeL.text = [NSString stringWithFormat:@"%@ %@",self.calenderStr,self.timeStr];
    
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
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld",year,month];
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
         self.selectTimeStr = [self.currentResultStr isEqualToString:self.selectCalenderStr] ? self.timeStr:@"9:00~10:00";
    }
    
    if (component == 1){
    
        if ([self.currentResultStr isEqualToString:self.selectCalenderStr]){
            row = row + self.selectRow;
        }
        self.selectTimeStr = self.titleArr[component][row];
    }
}

-(void)setSelectCalenderStr:(NSString *)selectCalenderStr{
    _selectCalenderStr = selectCalenderStr;
    
    NSString *myTimeStr = IsEmptyStr(self.selectTimeStr) ? self.timeStr : self.selectTimeStr;
    self.arriveShopView.arriveShopTimeL.text = [NSString stringWithFormat:@"%@ %@",selectCalenderStr,myTimeStr];
}
- (void)setSelectTimeStr:(NSString *)selectTimeStr{
    _selectTimeStr = selectTimeStr;
   
    NSString *myCalender = IsEmptyStr(self.selectCalenderStr) ? self.calenderStr : self.selectCalenderStr;
    self.arriveShopView.arriveShopTimeL.text = [NSString stringWithFormat:@"%@ %@",myCalender,selectTimeStr];
}
- (void)requestData{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getAppointmentOrderDetailInfo:[YHTools getAccessToken] billId:[self.orderId intValue] onComplete:^(NSDictionary *info) {
        NSLog(@"%@",info);
        [MBProgressHUD hideHUDForView:self.view];
        NSString *codeStr = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([codeStr isEqualToString:@"20000"]) {
          NSDictionary *data = info[@"data"];
            self.data = data;
            self.userAppointmentDetailView.needData = data;
            NSString *needResult = [NSString stringWithFormat:@"%@",data[@"arrival_time"]];
            self.arriveShopView.arriveShopTimeL.text = needResult;
            if (!IsEmptyStr(data[@"arrival_time"])) {//车主预约已经选择时间,技师预约不需要重新选择时间
                NSString *arrival_time = data[@"arrival_time"];
                NSArray *timeArr = [arrival_time componentsSeparatedByString:@" "];
                if (timeArr.count == 2) {
                    self.isSelectedTime = YES;
                    self.timeStr = timeArr[1];
                    self.calenderStr = timeArr[0];
                }
            }
            self.scrollView.hidden = NO;
           
            if ([[NSString stringWithFormat:@"%@",data[@"status"]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",data[@"is_push"]] isEqualToString:@"1"]) {
                [self.bottomBtn setTitle:@"推送车主" forState: UIControlStateNormal];
                self.bottomBtn.hidden = NO;
                self.arriveShopView.hidden = NO;
            }
            if ([[NSString stringWithFormat:@"%@",data[@"status"]] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",data[@"is_receipt"]] isEqualToString:@"1"]) {
                [self.bottomBtn setTitle:@"接车" forState:UIControlStateNormal];
                 self.bottomBtn.hidden = NO;
                self.arriveShopView.hidden = YES;
            }
            
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - 底部按钮点击 ----
- (void)bottomClickEvent:(UIButton *)btn{
    
    NSString *resultStr =  [btn.currentTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([resultStr isEqualToString:@"推送车主"]) {
        
        if (!self.isSelectedTime) {
            [MBProgressHUD showError:@"请选择到店时间"];
            return;
        }
        [self appointmentOrderPush];
    }
   
    if ([resultStr isEqualToString:@"接车"]) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
        NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
        controller.billId = self.orderId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark - 小虎安检预约单推送 -----
- (void)appointmentOrderPush{

    NSString *myNeedTimeStr = IsEmptyStr(self.selectTimeStr) ? self.timeStr : self.selectTimeStr;
    NSString *myNeedCalenderStr = IsEmptyStr(self.selectCalenderStr) ? self.calenderStr : self.selectCalenderStr;
    
    NSArray *timeArr = [myNeedTimeStr componentsSeparatedByString:@"~"];
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ %@",myNeedCalenderStr,timeArr.firstObject];
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ %@",myNeedCalenderStr,timeArr.lastObject];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] appointmentOrderPush:[YHTools getAccessToken] billId:[self.orderId intValue] arrivalTimeStart:startTimeStr arrivalTimeEnd:endTimeStr onComplete:^(NSDictionary *info) {
    
         [MBProgressHUD hideHUDForView:self.view];
        NSString *codeStr = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([codeStr isEqualToString:@"20000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:info[@"msg"]];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

@end
