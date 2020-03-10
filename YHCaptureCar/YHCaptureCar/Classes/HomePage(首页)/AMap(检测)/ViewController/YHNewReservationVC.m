//
//  YHNewReservationVC.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHNewReservationVC.h"
#import <BRDatePickerView.h>
#import "NSDate+BRAdd.h"
#import "UIColor+ColorChange.h"
#import "MBProgressHUD+MJ.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "UITextView+Placeholder.h"
#import "YHDetectionCenterVC.h"
#import <Masonry.h>

/*
判断字符串是否为空
*/
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@" "] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

@interface YHNewReservationVC ()
//检测数量
@property (weak, nonatomic) IBOutlet UITextField *amountTF;

//联系电话
@property (weak, nonatomic) IBOutlet UITextField *telTF;
//预约时间
@property (weak, nonatomic) IBOutlet UIButton *bookDateBtn;

//预约地址
@property (weak, nonatomic)UITextView *addrTF;

//选择预约日期
@property (nonatomic, copy) NSString *selectValue;

@property(nonatomic,assign)UIDatePickerMode datePickerMode;

@end

@implementation YHNewReservationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增预约";
    [self.bookDateBtn setTitle:@"请选择预约时间:" forState:UIControlStateNormal];

    UITextView *addrTF = [[UITextView alloc] init];
    self.addrTF = addrTF;
    [self.view addSubview:addrTF];
    [addrTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountTF.mas_bottom).mas_offset(@20);
        make.left.right.equalTo(self.amountTF);
        make.height.equalTo(@88);
    }];
    addrTF.layer.borderWidth = 0.6f;
    addrTF.layer.cornerRadius = 6.0f;
    addrTF.textColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1];
    addrTF.font = [UIFont systemFontOfSize:15];
    addrTF.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    addrTF.placeholder = @"请输入您的地址";
    addrTF.placeholderAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1]};
    self.addrTF.maxInputLength = 50;
    
    //通过KVO 修改textField 的占位符颜色
    [self.amountTF setValue:[UIColor colorWithHexString:@"9B9B9B"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.addrTF setValue:[UIColor colorWithHexString:@"9B9B9B"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.telTF setValue:[UIColor colorWithHexString:@"9B9B9B"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.telTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.reservationM.stationId) {
        self.selectValue = self.reservationM.bookDate;
        //确认回调
        NSString *title = [NSString stringWithFormat:@"请选择预约时间: %@",self.reservationM.bookDate];
        [self.bookDateBtn setTitle:title forState:UIControlStateNormal];
        
        self.addrTF.text = self.reservationM.addr;
        self.amountTF.text = @"1";
        self.telTF.text = self.reservationM.tel;
        self.reservationM.ID = self.reservationM.stationId;
        self.reservationM.name = self.reservationM.stationName;

    }
}

- (void)textFieldDidChange:(id)sender{
    
    if (self.telTF.text.length > 11){
        //超出限制字数时所要做的事
        self.telTF.text = [self.telTF.text substringToIndex: 11];
//        [self.telTF.text substringToIndex: 11];
    }
}


#pragma mark - 返回 指定时间加指定天数 结果日期字符串
/*
+ (NSString *)date:(NSString *)dateString formatter:(NSString *)formatterStr addDays:(NSInteger)days {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatterStr; //yyyy-MM-dd
    NSDate *myDate = [dateFormatter dateFromString:dateString];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    //NSDate *newDate = [NSDate dateWithTimeInterval:60 * 60 * 24 * days sinceDate:myDate];
    NSString *newDateString = [dateFormatter stringFromDate:newDate];
    NSLog(@"%@", newDateString);
    return newDateString;
}
 */

//预约时间选择器
- (IBAction)bookDateSelect:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    NSString *minTStr = [NSDate date:[NSDate currentDateString] formatter:@"yyyy-MM-dd HH:mm:ss" addDays:0];
    [BRDatePickerView showDatePickerWithTitle:@"预约检测时间" dateType:UIDatePickerModeDate defaultSelValue:[minTStr substringToIndex:10] minDateStr:minTStr maxDateStr:nil isAutoSelect:YES themeColor:YHNaviColor resultBlock:^(NSString *selectValue) {
        YHLog(@"点击后 预约时间   ---%@  ---当前时间%@",selectValue,[NSDate currentDateString]);
        self.selectValue = selectValue;
        //确认回调
        NSString *title = [NSString stringWithFormat:@"请选择预约时间: %@",selectValue];
        [weakSelf.bookDateBtn setTitle:title forState:UIControlStateNormal];
        
    } cancelBlock:^{
    
    }];
}

//提交预约申请
- (IBAction)SubmitAppointment:(UIButton *)sender {

    //数据校验
    if (NULLString(self.amountTF.text)) {
        [MBProgressHUD showError:@"检测数量不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (![self isPureNumandCharacters:self.amountTF.text]) {
        [MBProgressHUD showError:@"检测数量请输入数字" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (NULLString(self.addrTF.text)) {
        [MBProgressHUD showError:@"我的地址不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (NULLString(self.telTF.text)) {
        [MBProgressHUD showError:@"联系方式不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (![self validatePhone:self.telTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    NSString *bookDateStr = [self.bookDateBtn.titleLabel.text substringFromIndex:8];
    if (NULLString(bookDateStr)) {
        [MBProgressHUD showError:@"日期不能不空,请选择预约日期" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
//        // 不设置默认日期，就默认选中今天的日期
//       self.bookDateBtn.titleLabel.text = [self toStringWithDate:[NSDate date]];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    NSDate *bookDateTime = [dateFormatter dateFromString:self.bookDateBtn.titleLabel.text];
//    //比较时间的大小
//    int timeCompare = [self compareOneDay:[self getCurrentTime] withAnotherDay:bookDateTime];
//    if (timeCompare <= 0) {//小于当前时间
//        [MBProgressHUD showError:@"请选择预约日期" toView:[UIApplication sharedApplication].keyWindow];
//    }else{
//        [self.bookDateBtn setTitle:self.bookDateBtn.titleLabel.text forState:UIControlStateNormal];
//    }
    
    NSString * stationId = [NSString stringWithFormat:@"%@",self.reservationM.ID];
    if (NULLString(stationId)) {
        [MBProgressHUD showError:@"传入站点ID不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (NULLString(self.reservationM.name)) {
        [MBProgressHUD showError:@"站点名称不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    YHLog(@"请求参数校验: ====>>>>    token = %@ -- 检测数量:%@ --检测地址:%@ --联系方式:%@ ---预约时间:%@---站点ID:%@ ---站点名称:%@",[YHTools getAccessToken],self.amountTF.text,self.addrTF.text,self.telTF.text,self.bookDateBtn.titleLabel.text,[NSString stringWithFormat:@"%@",self.reservationM.ID],self.reservationM.name);
    
    __weak __typeof__(self) weakSelf = self;
    NSString *bookStr = [self.bookDateBtn.titleLabel.text substringFromIndex:9];
    [[YHNetworkManager sharedYHNetworkManager]appointmentInspectionWithToken:[YHTools getAccessToken] amount:self.amountTF.text addr:self.addrTF.text tel:self.telTF.text bookDate:bookStr stationId:[NSString stringWithFormat:@"%@",self.reservationM.ID] stationName:self.reservationM.name onComplete:^(NSDictionary *info) {
        
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

#pragma mark - 获得当前时间
-(NSDate*)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

#pragma mark - 进行时间比较
//将现在的时间与指定时间比较，如果没达到指定日期，返回-1，刚好是这一时间，返回0，否则返回1
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {//大于指定日期
        return 1;
    }else if (result == NSOrderedAscending){//小于指定日期
        return -1;
    }
    return 0;  //等于指定日期
}

#pragma mark - 格式转换：NSDate --> NSString
- (NSString *)toStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//判断是否为手机号
- (BOOL)validatePhone:(NSString *)phone{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
