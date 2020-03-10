//
//  YHDiagnosisBaseTC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDiagnosisBaseTC.h"
#import "BRPickerView.h"
#import "NSDate+BRAdd.h"
#import "QFDatePickerView.h"
#import "UIColor+ColorChange.h"
#import "LYPlateKeyBoardView.h"
#import "YHBrandChooseTC.h"
#import "YHCarSeriesTC.h"
//#import "YHMapLocationController.h"
#import "YHCarBaseModel.h"
#import "BlockButton.h"
#import "YHCommon.h"
#import <Masonry.h>
#import "UIView+frame.h"
#import <Masonry.h>
#import "YHNetworkManager.h"
#import "YHTools.h"
#import <MJExtension/MJExtension.h>

@interface YHDiagnosisBaseTC ()<UITextFieldDelegate,UITextViewDelegate,LYPlateKeyBoardViewDelegate>


/**
 TextView占位符
 */
@property(nonatomic,strong)UILabel *lb;

/**
 车牌键盘
 */
@property (nonatomic, strong) LYPlateKeyBoardView *keyboardView;

/**
 车辆描述Cell
 */
@property (weak, nonatomic) IBOutlet UITableViewCell *carDes;

/**
 看车标签 约束用
 */
@property (weak, nonatomic) IBOutlet UILabel *lookCarL;

/**
 内容视图
 */
@property (weak, nonatomic) IBOutlet UIView *cellView;

/**
 位置图标  约束用
 */
@property (weak, nonatomic) IBOutlet UIButton *locationImg;

@property(nonatomic,assign)CGRect locationFrame;
@property (weak, nonatomic) IBOutlet UIButton *provinceBotton;
- (IBAction)provinceAndCityActions:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cityBotton;


@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) UIView *pickerViewBox;

@property (strong, nonatomic) NSDictionary *areaDic;
@property (strong, nonatomic) NSArray *province;
@property (strong, nonatomic) NSArray *city;
@property (strong, nonatomic) NSArray *district;

//是否是点击了排放按钮
@property(nonatomic,assign)BOOL isSelected;

//排放标准数组
@property(nonatomic,strong)NSMutableArray *dischargeArray;

@property (nonatomic,assign)BOOL isHaveDian;

@end

@implementation YHDiagnosisBaseTC

- (void)initUI
{
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self setPlaceHolder];      //设置占位符
    [self setUpTextView];       //设置TextView 车辆描述占位符
    [self setUpCarKeyBoard];    //设置车牌键盘
    [self setUpTextFieldSelect];//设置时间选择器
    
    YHLayerBorder(_provinceBotton, YHLineColor, 1);
    YHLayerBorder(_cityBotton, YHLineColor, 1);
    
    //按钮内间距偏移
    self.carModelsL.textInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    self.carPropertiesS.selectedSegmentIndex = 1;
    self.odometerTF.delegate = self;
    self.contactNumberTF.delegate = self;
    self.carNumberTF.delegate = self;
    self.odometerTF.keyboardType = UIKeyboardTypeNumberPad;
    self.contactNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self setUpUISegmentedControl];    //设置分段样式;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.isSelected = NO;
    
}

- (void)initNC
{
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReceiveBrandName:) name:@"brandName" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self initNC];
    
    //刷新基本信息UI
    [self refreshBaseInfoUI];
}

#pragma mark - =========================刷新基本信息UI(余大侠)============================
- (void)refreshBaseInfoUI
{
    
    NSArray *conArr = [self.model.cannotChangeFields valueForKeyPath:@"field"];
    //1.车架号
    self.vinFT.text = self.vinStr;
    self.vinFT.userInteractionEnabled = ![conArr containsObject:@"vin"];
    
    self.yearTF.text = self.model.carStyle;
    self.yearTF.userInteractionEnabled = ![conArr containsObject:@"carStyle"];
    
    self.carModelsL.text = self.model.carBrandName;
    self.carModelsL.userInteractionEnabled = ![conArr containsObject:@"carBrandName"];
    
    self.powerL.text = self.model.dynamicParameter;
    self.powerL.userInteractionEnabled = ![conArr containsObject:@"dynamicParameter"];
    
    self.modelTF.text = self.model.model;
    self.modelTF.userInteractionEnabled = ![conArr containsObject:@"model"];
    
    self.carNumberTF.text = self.model.plateNo;
    self.carNumberTF.userInteractionEnabled = ![conArr containsObject:@"plateNo"];
    
    [self.dischargeButton setTitle:self.model.emissionsStandards forState:UIControlStateNormal];
    self.dischargeButton.userInteractionEnabled = ![conArr containsObject:@"emissionsStandards"];
    
    self.odometerTF.text = self.model.tripDistance;
    self.odometerTF.userInteractionEnabled = ![conArr containsObject:@"tripDistance"];
    
    self.dateOfManufactureTF.text = [self.model.productionDate stringByReplacingCharactersInRange:NSMakeRange(7, self.model.productionDate.length - 7) withString:@""];
    self.dateOfManufactureTF.userInteractionEnabled = ![conArr containsObject:@"productionDate"];
    
    self.registerDateTF.text = [self.model.registrationDate stringByReplacingCharactersInRange:NSMakeRange(10, self.model.registrationDate.length - 10) withString:@""];
    self.registerDateTF.userInteractionEnabled = ![conArr containsObject:@"registrationDate"];
    
    self.certificationDateTF.text = [self.model.issueDate stringByReplacingCharactersInRange:NSMakeRange(10, self.model.issueDate.length - 10) withString:@""];
    self.certificationDateTF.userInteractionEnabled = ![conArr containsObject:@"issueDate"];
    
    self.carPropertiesS.selectedSegmentIndex = [self.model.carNature isEqualToString:@"0"] ? 0  : 1;//默认选择非运营1
    self.carPropertiesS.userInteractionEnabled = ![conArr containsObject:@"carNature"];
    
    self.ownerProS.selectedSegmentIndex =  self.model.userNature.intValue;
    self.ownerProS.userInteractionEnabled = ![conArr containsObject:@"userNature"];

    self.InspectionDate.text = [self.model.endAnnualSurveyDate stringByReplacingCharactersInRange:NSMakeRange(7, self.model.endAnnualSurveyDate.length - 7) withString:@""];
    self.InspectionDate.userInteractionEnabled = ![conArr containsObject:@"endAnnualSurveyDate"];

    self.trafficMandatoryInsuranceDate.text = [self.model.trafficInsuranceDate stringByReplacingCharactersInRange:NSMakeRange(7, self.model.trafficInsuranceDate.length - 7) withString:@""];;
    self.trafficMandatoryInsuranceDate.userInteractionEnabled = ![conArr containsObject:@"trafficInsuranceDate"];

    self.businessInsuranceTF.text = [self.model.businessInsuranceDate stringByReplacingCharactersInRange:NSMakeRange(7, self.model.businessInsuranceDate.length - 7) withString:@""];
    self.businessInsuranceTF.userInteractionEnabled = ![conArr containsObject:@"businessInsuranceDate"];

    self.evaluateLab.text = [self.model.suggestPrice stringByAppendingString:@"万"];
    self.evaluateLab.userInteractionEnabled = ![conArr containsObject:@"suggestPrice"];

    self.priceFT.text = self.model.offer;
    self.priceFT.userInteractionEnabled = ![conArr containsObject:@"offer"];

    self.Contact.text = self.model.carContact;
    self.Contact.userInteractionEnabled = ![conArr containsObject:@"carContact"];

    self.contactNumberTF.text = self.model.carContactTel;
    self.contactNumberTF.userInteractionEnabled = ![conArr containsObject:@"carContactTel"];

    if (self.carVersionModel) {
    
        //2.车型车系
        //如果车系名称包含品牌名称
        if ([self.carVersionModel.carLineName containsString:self.carVersionModel.carBrandName]) {
            self.carModelsL.text = [NSString stringWithFormat:@"%@",self.carVersionModel.carLineName];
        //如果车系名称不包含品牌名称
        }else{
            self.carModelsL.text = [NSString stringWithFormat:@"%@%@",self.carVersionModel.carBrandName,self.carVersionModel.carLineName];
        }
        
        //3.年款
        self.yearTF.text = [NSString stringWithFormat:@"%@款",self.carVersionModel.produceYear];
        
        //4.动力参数
        self.powerL.text = self.carVersionModel.carCc;
        
        //5.型号
        self.modelTF.text = self.carVersionModel.cheXing;
        
        //6.排放标准
        [self.dischargeButton setTitle:self.dischargeArray[0] forState:UIControlStateNormal];
    } else {
        [self.dischargeButton setTitle:self.dischargeArray[0] forState:UIControlStateNormal];
    }
    
}

-(void)setUpUISegmentedControl
{
    //车辆性质
    [self setUpWithUISegmentedControl:self.carPropertiesS];
    
    //车辆所有者性质
    [self setUpWithUISegmentedControl:self.ownerProS];
}

-(void)setUpWithUISegmentedControl:(UISegmentedControl *)seg
{
    [seg setTintColor:[UIColor colorWithHexString:@"e2e2e5"]];
    
    //选中的文字颜色
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    //未选中的文字颜色
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#383838"]} forState:UIControlStateNormal];
    
    //选择状态的背景图片
    [seg setBackgroundImage:[UIImage imageNamed:@"蓝色"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //选择状态的背景图片
    [seg setBackgroundImage:[UIImage imageNamed:@"白色"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    seg.layer.cornerRadius = 5;
    seg.layer.masksToBounds = YES;
    seg.layer.borderWidth = 1;
    seg.layer.borderColor = [UIColor colorWithHexString:@"bebebe"].CGColor;
}

#pragma mark - 接收通知返回的消息
-(void)ReceiveBrandName:(NSNotification*)notice
{
    NSDictionary *userInfo = notice.userInfo;
    if (self.model == nil) {
        self.model = [[YHCarBaseModel alloc] init];
    }
    
    //    :@"brandName" object:nil userInfo:@{@"brandName":self.brandName, @"brandId" : self.brandId, @"lineName" : model.lineName, @"lineId" : model.lineId}];
    self.model.carBrandName = userInfo[@"brandName"];
    self.model.carBrandId = userInfo[@"brandId"];
    self.model.carLineName = userInfo[@"lineName"];
    self.model.carLineId = userInfo[@"lineId"];
    
    if ([self.model.carLineName containsString:self.model.carBrandName]) { //如果车系名称包含品牌名称
        self.carModelsL.text = [NSString stringWithFormat:@"%@",userInfo[@"lineName"]];
    }else{
        self.carModelsL.text = [NSString stringWithFormat:@"%@%@",userInfo[@"brandName"],userInfo[@"lineName"]];
    }
    //   self.carModelsL.text = [NSString stringWithFormat:@"%@%@", userInfo[@"brandName"], userInfo[@"lineName"]];
}

- (IBAction)chooseBrandAndCarSeries:(UITapGestureRecognizer *)sender
{
    YHBrandChooseTC *brandTC = [[YHBrandChooseTC alloc]init];
    [self.navigationController pushViewController:brandTC animated:YES];
}

#pragma mark - 设置车牌键盘
/**
 设置车牌键盘
 */
-(void)setUpCarKeyBoard{
    self.carNumberTF.delegate = self;
    self.carNumberTF.tapAcitonBlock = ^{
        self.keyboardView = [[LYPlateKeyBoardView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.keyboardView.delegate = self;
        
        //        [self.view addSubview:self.keyboardView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.keyboardView];
    };
}

- (void)clickWithString:(NSString *)string{
    self.carNumberTF.text = [self.carNumberTF.text stringByAppendingString:string];
}

- (void)deleteBtnClick
{
    if (self.carNumberTF.text.length == 0) {
        
    }else if (self.carNumberTF.text.length == 1) {
        [self.keyboardView deleteEnd];
        self.carNumberTF.text = [self.carNumberTF.text substringToIndex:[self.carNumberTF.text length] - 1];
    }else {
        self.carNumberTF.text = [self.carNumberTF.text substringToIndex:[self.carNumberTF.text length] - 1];
    }
}

/**
 设置TextView
 */
-(void)setUpTextView
{
    self.carDesTV.delegate = self;
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    self.lb.text = @"请输入车辆描述";
    self.lb.font = [UIFont systemFontOfSize:14];
    self.lb.enabled = NO;
    [self.carDesTV addSubview:self.lb];
}

#pragma mark - TextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(![text isEqualToString:@""]) {
        [self.lb setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
        [self.lb setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.lb.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.lb.alpha = 1;
    }
    return YES;
}

#pragma mark - 设置占位符
/**
 设置占位符
 */
-(void)setPlaceHolder
{
    [self.yearTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.powerL setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.modelTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.carNumberTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.odometerTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.dateOfManufactureTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.registerDateTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.certificationDateTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.InspectionDate setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.trafficMandatoryInsuranceDate setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.businessInsuranceTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.addrFT setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.Contact setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.contactNumberTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
}


//#pragma mark - 禁用系统键盘弹出
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (
        [textField isEqual:self.yearTF]//年款
        ||[textField isEqual:self.carNumberTF]//车牌号码
        ||[textField isEqual:self.dateOfManufactureTF]//出厂日期
        ||[textField isEqual:self.registerDateTF]//注册日期
        ||[textField isEqual:self.certificationDateTF]//发证日期
        ||[textField isEqual:self.InspectionDate]// 年检到期日
        ||[textField isEqual:self.trafficMandatoryInsuranceDate]// 交强险到期日
        ||[textField isEqual:self.businessInsuranceTF]// 商业保险到期日
        ) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)initPicker:(BRTextField *)text
{
    __weak typeof(self) weakSelf = self;
    text.delegate = self;
    text.rightViewMode = UITextFieldViewModeAlways;
    text.tapAcitonBlock = ^{
        [weakSelf textTFPicker:text];
    };
    
    BlockButton * rightView = [BlockButton buttonWithType:UIButtonTypeCustom];
    rightView.frame = CGRectMake(0, 0, 40, 30);
    
    rightView.block = ^(UIButton * button) {
        [weakSelf textTFPicker:text];
    };
    
    text.rightView = rightView;
}

- (void)textTFPicker:(UITextField *)tf
{
    QFDatePickerView *datePickerView;
    if (self.yearTF == tf) {
        datePickerView = [[QFDatePickerView alloc]initYearPickerViewWithResponse:^(NSString *str) {
            tf.text = [NSString stringWithFormat:@"%@款",str];
        }];
    }else{
        datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
            tf.text = str;
        }];
    }
    [datePickerView show];
}

- (void)initDayPicker:(BRTextField *)text
{
    __weak typeof(self) weakSelf = self;
    text.delegate = self;
    text.rightViewMode = UITextFieldViewModeAlways;
    text.tapAcitonBlock = ^{
        [weakSelf textTFDayPicker:text];
    };
    
    BlockButton * rightView = [BlockButton buttonWithType:UIButtonTypeCustom];
    rightView.frame = CGRectMake(0, 0, 40, 30);
    
    rightView.block = ^(UIButton * button) {
        [weakSelf textTFDayPicker:text];
    };
    
    text.rightView = rightView;
}

- (void)textTFDayPicker:(UITextField *)tf
{
    QFDatePickerView *datePickerView;
    if (self.businessInsuranceTF != tf) {
        [BRDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:tf.text minDateStr:nil maxDateStr:[NSDate currentDateString] isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            tf.text = selectValue;
        } cancelBlock:^{
            NSLog(@"点击了背景或取消按钮");
        }];
    }else{
        [BRDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:tf.text minDateStr:nil maxDateStr:[NSDate date:[NSDate currentDateString] formatter:@"yyyy-MM-dd" addDays:365] isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            tf.text = selectValue;
        } cancelBlock:^{
            NSLog(@"点击了背景或取消按钮");
        }];
    }
    [datePickerView show];
}

/**
 设置下拉选择
 */
-(void)setUpTextFieldSelect
{
    __weak typeof(self) weakSelf = self;
    
    /********年***********/
    //年款
    [self initPicker:_yearTF];
    
    /********年月***********/
    //出厂日期
    [self initPicker:_dateOfManufactureTF];
    
    //年检日期
    [self initPicker:_InspectionDate];
    
    //交强险日期
    [self initPicker:_trafficMandatoryInsuranceDate];
    
    /********年月日***********/
    //注册日期
    [self initDayPicker:_registerDateTF];
    
    //发证日期
    [self initDayPicker:_certificationDateTF];
    
    //商业险到期时间
    [self initPicker:_businessInsuranceTF];
}

#pragma mark - 设置每一行的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  !self.model.carNature && indexPath.row == 8 ? 95 : 56;
}

#pragma mark - 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    
    if (_vinFT == textField) {
        if ([textField.text length]>=17)
            return NO;
        //小写转大写
        char commitChar = [string characterAtIndex:0];
        if (commitChar > 96 && commitChar < 123){
            NSString * uppercaseString = string.uppercaseString;
            NSString * str1 = [textField.text substringToIndex:range.location];
            NSString * str2 = [textField.text substringFromIndex:range.location];
            textField.text = [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
            return NO;
        }
    }
    
    if (_odometerTF == textField) {
        if ([textField.text length] >= 7)
            return NO;
    }
    
    if (_contactNumberTF == textField) {
        if ([textField.text length] >= 11)
            return NO;
    }
        if (textField == _priceFT )  {
            if ([textField.text rangeOfString:@"."].location == NSNotFound) {
                _isHaveDian = NO;
            }
            if ([string length] > 0) {
                
                unichar single = [string characterAtIndex:0];//当前输入的字符
                if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                    
                    //首字母不能为0和小数点
                    if([textField.text length] == 0){
                        if(single == '.') {
                            [MBProgressHUD showError:@"亲，第一个数字不能为小数点"];
                            [textField.text stringByReplacingCharactersInRange:range withString:@""];
                            return NO;
                        }
                        //                    if (single == '0') {
                        //                        [MBProgressHUD showError:@"亲，第一个数字不能为0"];
                        //                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        //                        return NO;
                        //                    }
                    }
                    
                    //输入的字符是否是小数点
                    if (single == '.') {
                        if(!_isHaveDian)//text中还没有小数点
                        {
                            _isHaveDian = YES;
                            return YES;
                            
                        }else{
                            [MBProgressHUD showError:@"亲，您已经输入过小数点了"];
                            [textField.text stringByReplacingCharactersInRange:range withString:@""];
                            return NO;
                        }
                    }else{
                        if (_isHaveDian) {//存在小数点
                            
                            //判断小数点的位数
                            NSRange ran = [textField.text rangeOfString:@"."];
                            if (range.location - ran.location <= 2) {
                                return YES;
                            }else{
                                
                                [MBProgressHUD showError:@"亲，您最多输入两位小数"];
                                return NO;
                            }
                        }else{
                            return YES;
                        }
                    }
                }else{//输入的数据格式不正确
                    [MBProgressHUD showError:@"亲，您输入的格式不正确"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                return YES;
            }
        }
    return YES;
}

/**
 验证数字号码
 */
- (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


#pragma mark - ==============================选择器代码(梅文峰)=================================
#pragma mark - 看车地址按钮点击事件
- (IBAction)provinceAndCityActions:(UIButton *)sender
{
    self.isSelected = NO;
    [self.view endEditing:YES];
    [self initCityPicker];
}

#pragma mark - 排放标准按钮点击事件
- (IBAction)selectDischarge:(UIButton *)sender
{
    self.selectedDischarge = self.dischargeArray[0];
    self.isSelected = YES;
    [self.view endEditing:YES];
    [self initCityPicker];
}

#pragma mark - 初始化城市选择器
- (void)initCityPicker
{
    if (self.isSelected == NO) {
        _areaDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
        
        NSArray *components = [_areaDic allKeys];
        
        NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
            [provinceTmp addObject: [tmp objectAtIndex:0]];
        }
        
        //省
        _province = [[NSArray alloc] initWithArray: provinceTmp];
        
        NSString *index = [sortedArray objectAtIndex:0];
        NSString *selected = [_province objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[_areaDic objectForKey:index]objectForKey:selected]];
        
        //市
        NSArray *cityArray = [dic allKeys];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
        _city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
        
        //区
        NSString *selectedCity = [_city objectAtIndex: 0];
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
        
        
        _pickerViewBox = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        [_pickerViewBox setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
        [_picker selectRow: 0 inComponent: 0 animated: YES];
        [_pickerViewBox addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_pickerViewBox.mas_left).with.offset(0);
            make.right.equalTo(_pickerViewBox.mas_right).with.offset(0);
            make.bottom.equalTo(_pickerViewBox.mas_bottom).with.offset(0);
        }];
        
        [_picker reloadAllComponents];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_pickerViewBox];
    } else {
        _pickerViewBox = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        [_pickerViewBox setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
        [_picker selectRow: 0 inComponent: 0 animated: YES];
        [_pickerViewBox addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_pickerViewBox.mas_left).with.offset(0);
            make.right.equalTo(_pickerViewBox.mas_right).with.offset(0);
            make.bottom.equalTo(_pickerViewBox.mas_bottom).with.offset(0);
        }];
        
        [_picker reloadAllComponents];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_pickerViewBox];
    }
}

//加载第二列显示的数据
-(void)loadData:(UIPickerView*)pickerView
{
    //一定要首先获取用户选择的那一行 然后才可以根据选中行获取省份 获取省份以后再去字典中加载省份对应的城市
    NSInteger selRow = [pickerView selectedRowInComponent:0];
    
    _selectedProvince = [_province objectAtIndex: selRow];
    
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)selRow]]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
    NSArray *cityArray = [dic allKeys];
    NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;//递减
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;//上升
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    
    _city = [[NSArray alloc] initWithArray: array];
}


//一共多少咧
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    //(1)看车地址城市选择器
    if (self.isSelected == NO) {
        return 2;
    //(2)排放标准选择器
    } else {
        return 1;
    }
}

//返回每一列的行数
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //(1)看车地址城市选择器
    if (self.isSelected == NO) {
        if (component == 0) {
            return self.province.count;
        } else {
            [self loadData:pickerView];
            return self.city.count;
        }
    //(2)排放标准选择器
    } else {
        return self.dischargeArray.count;
    }
}

//返回每一行显示的文本
- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //(1)看车地址城市选择器
    if (self.isSelected == NO) {
        if (component == 0) {
            return self.province[row];
        } else {
            [self loadData:pickerView];
            self.selectedCity = self.city[0];
            return self.city[row];
        }
    //(2)排放标准选择器
    } else {
        return self.dischargeArray[row];
    }
}

//选中某一行后回调 联动的关键
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //(1)看车地址城市选择器
    if (self.isSelected == NO) {
        
        //省份
        if (component == 0) {
            
            self.selectedProvince = self.province[row];
            
            //重新加载第二列的数据
            [pickerView reloadComponent:1];
            
            //让第二列归位
            [pickerView selectRow:0 inComponent:1 animated:YES];
        //城市
        } else if (component == 1) {
            self.selectedCity = self.city[row];
        }
    //(2)排放标准选择器
    } else {
        self.selectedDischarge = self.dischargeArray[row];
    }
}

- (IBAction)gotoHelpBuy:(UIButton *)sender {
    
    YHCarBaseModel *model = YHCarBaseModel.new;
    
    if (!NULLString(self.powerL.text)) {
        model.dynamicParameter = self.powerL.text;//动力参数
    }else{
        [MBProgressHUD showError:@"动力参数不能为空"];
        return;
    }
    
    if (!NULLString(self.modelTF.text)) {
        model.model = self.modelTF.text;//型号
    }else{
        [MBProgressHUD showError:@"车辆型号不能为空"];
        return;
    }
    
    if (!NULLString(self.model.carId)){
        model.carId = self.model.carId;
    }else{
        [MBProgressHUD showError:@"车辆id不能为空"];
        return;
    }
    
    if(!NULLString(self.dischargeButton.titleLabel.text)){
        model.emissionsStandards = self.dischargeButton.titleLabel.text;//排放标准
    }else{
        [MBProgressHUD showError:@"排放标准不能为空"];
        return;
    }
    
    if (!NULLString(self.dateOfManufactureTF.text)) {
        model.productionDate = self.dateOfManufactureTF.text;//出厂日期
    }else{
        [MBProgressHUD showError:@"出厂日期不能为空"];
        return;
    }
    
    if (!NULLString(self.registerDateTF.text)) {
        model.registrationDate = self.registerDateTF.text;      //注册日期
    }else{
        [MBProgressHUD showError:@"注册日期不能为空"];
        return;
    }
    
    if (!NULLString(self.certificationDateTF.text)) {
        model.issueDate = self.certificationDateTF.text;      //发证日期
    }else{
        [MBProgressHUD showError:@"发证日期不能为空"];
        return;
    }
    
    if (!NULLString(self.InspectionDate.text)) {
        model.endAnnualSurveyDate = self.InspectionDate.text;//年检到期时间
    }else{
        [MBProgressHUD showError:@"年检到期时间不能为空"];
        return;
    }
    
    if (!NULLString(self.priceFT.text)) {
        model.offer = self.priceFT.text;//售价
    }else{
        [MBProgressHUD showError:@"售价不能为空"];
        return;
    }
    
    if (!NULLString(self.Contact.text)) {
        model.carContact = self.Contact.text;;//联系人
    }else{
        [MBProgressHUD showError:@"联系人不能为空"];
        return;
    }
    
    if (!NULLString(self.contactNumberTF.text)) {
        model.carContactTel = self.contactNumberTF.text;//联系电话
    }else{
        [MBProgressHUD showError:@"联系电话不能为空"];
        return;
    }
    
    model.carNature = self.carPropertiesS.selectedSegmentIndex ? @"1" : @"0";
    model.userNature = self.ownerProS.selectedSegmentIndex ? @"1" : @"0";
    model.trafficInsuranceDate = self.trafficMandatoryInsuranceDate.text;
    model.businessInsuranceDate = self.businessInsuranceTF.text;
    
    
    
    NSDictionary *dic = [model mj_keyValues];
    
    __weak __typeof__(self) weakSelf = self;
    
    [[YHNetworkManager sharedYHNetworkManager] setCarBaseInfoBytoken:[YHTools getAccessToken] dic:dic onComplete:^(NSDictionary *info) {
        
        if([info[@"retCode"] isEqualToString:@"0"]){
        [MBProgressHUD showSuccess:info[@"retMsg"] toView:weakSelf.navigationController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.doAciton(nil);
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        }else{
            [MBProgressHUD showError:info[@"retMsg"]];
        }
        
    } onError:^(NSError *error) {
       
    }];
    
}
#pragma mark - 选择器“取消”
- (IBAction)pickerCancelAction:(id)sender
{
    [_pickerViewBox removeFromSuperview];
    _pickerViewBox = nil;
}

#pragma mark - 选择器“确定”
- (IBAction)PickerComfireAction:(id)sender
{
    //(1)看车地址城市选择器
    if (self.isSelected == NO) {
        
        //省份
        [self.provinceBotton setTitle:self.selectedProvince forState:UIControlStateNormal];
        
        //城市
        [self.cityBotton setTitle:self.selectedCity forState:UIControlStateNormal];
        
    //(2)排放标准选择器
    } else {
        [self.dischargeButton setTitle:self.selectedDischarge forState:UIControlStateNormal];
    }

    [_pickerViewBox removeFromSuperview];
    _pickerViewBox = nil;
}

- (NSMutableArray *)dischargeArray
{
    if (!_dischargeArray) {
        _dischargeArray = [[NSMutableArray alloc]initWithObjects:@"国V",@"国IV",@"国III",@"国II",@"国I",@"欧V",@"欧IV",@"欧III",@"欧II",@"欧I", nil];
    }
    return _dischargeArray;
}

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:nil object:self];
}

@end
