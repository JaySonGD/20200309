//
//  YHDiagnosisBaseTC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDiagnosisBaseTC.h"
//#import "BRPickerView.h"
#import "NSDate+BRAdd.h"
#import "QFDatePickerView.h"
#import "UIColor+ColorChange.h"
#import "LYPlateKeyBoardView.h"
#import "YHBrandChooseTC.h"
#import "YHCarSeriesTC.h"
#import "YHMapLocationController.h"
#import "YHCarBaseModel.h"
#import "BlockButton.h"
#import "YHCommon.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import <BRPickerView/BRPickerView.h>

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

//排放标准

@property(nonatomic,assign)CGRect locationFrame;

@property (strong, nonatomic) IBOutlet UIView *pickerView;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) UIView *pickerViewBox;

//排放标准数组
@property(nonatomic,strong)NSMutableArray *dischargeArray;

//所选排放标准
@property (strong, nonatomic)NSString *selectedDischarge;

@end

@implementation YHDiagnosisBaseTC

- (void)initUI
{
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dischargeArray = [[NSMutableArray alloc]initWithObjects:@"国V",@"国IV",@"国III",@"国II",@"国I",@"欧V",@"欧IV",@"欧III",@"欧II",@"欧I", nil];

    [self initUI];
    
    //设置占位符
    [self setPlaceHolder];
    
    //设置TextView 车辆描述占位符
    [self setUpTextView];
    
    //设置时间选择器
    [self setUpCarKeyBoard];
    
    //设置时间选择器
    [self setUpTextFieldSelect];
    
    //设置时间选择器
    [self setAddressProperty];
    
    //按钮内间距偏移
    self.carModelsL.textInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    
    self.odometerTF.delegate = self;
    self.contactNumberTF.delegate = self;
    self.carNumberTF.delegate = self;
    self.odometerTF.keyboardType = UIKeyboardTypeNumberPad;
    self.contactNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self setUpUISegmentedControl];    //设置分段样式;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReceiveBrandName:) name:@"brandName" object:nil];
    

    //加载基本数据信息
    [self loadBaseInfo];
}

#pragma mark - 加载基本数据信息
-(void)loadBaseInfo
{
    [self.dischargeButton setTitle:self.dischargeArray[0] forState:UIControlStateNormal];

    if (!_model ) {
        return;
    }
    
    //1.车架号
    //_FrameNumberL.text = _model.vin;

    //2.车型车系
    if ([self.model.carLineName containsString:self.model.carBrandName]) { //如果车型 包含有品牌,那么只显示车系
        _carModelsL.text = [NSString stringWithFormat:@"%@", _model.carLineName];
    }else{
        _carModelsL.text = [NSString stringWithFormat:@"%@%@", _model.carBrandName, _model.carLineName];
    }
    
    //3.年款
    _yearTF.text = _model.nianKuan;

    //4.动力参数
    _powerL.text = _model.carCc;
    
    //5.型号
    _modelTF.text = _model.cheXing;
    
    
    //车牌号
    //_carNumberTF.text = [NSString stringWithFormat:@"%@%@%@", _model.plateNumberP, _model.plateNumberC, _model.plateNumber];
    
    //排放标准
//    NSNumber *index = @{@"国V" : @1,
//                        @"国IV" : @2,
//                        @"国III" : @3,
//                        @"国II" : @4,
//                        @"国I" : @5}[_model.emissionsStandards];
//    _emissionStandardsS.selectedSegmentIndex = index.integerValue;

    
    //里程表
    //_odometerTF.text = _model.tripDistance;

    
    //出厂日期
    //_dateOfManufactureTF.text = _model.produceYear;

    
    //注册日期
    //_registerDateTF.text = _model.registrationDate;
    

    //发证日期
    //_certificationDateTF.text = _model.issueDate;
    

    //车辆性质
    //_carPropertiesS.selectedSegmentIndex = (([_model.carNature isEqualToString:@"运营"]) ? (0) : (1));

    
     //车辆所有者性质
    //_ownerProS.selectedSegmentIndex = (([_model.userNature isEqualToString:@"私户"]) ? (0) : (1));

    
    //年检到期日
    //_InspectionDate.text = _model.endAnnualSurveyDate;


    //交强险到期日
    //_trafficMandatoryInsuranceDate.text = _model.trafficInsuranceDate;

    
    //商业保险到期日
    //_businessInsuranceTF.text = _model.businessInsuranceDate;


    //看车地址
    //_carAddress.text = _model.carAddress;

    
    //联系人
    //_Contact.text = _model.userName;

    
    //联系号码
    //_contactNumberTF.text = _model.phone;

    
    //车辆描述
    //_carDesTV.text = _model.car;
}

#pragma mark - 设置看车地址属性
-(void)setAddressProperty
{
    self.carAddress = [[CMInputView alloc]init];
    [self.cellView addSubview:self.carAddress];
    
    self.carAddress.frame = CGRectMake(CGRectGetMaxX(self.lookCarL.frame)+20,self.cellView.center.y -25, screenWidth -self.lookCarL.frame.size.width - self.locationImg.frame.size.width - 30,30);
    self.carAddress.centerY = self.cellView.centerY;
    
    self.carAddress.delegate = self;
    self.carAddress.placeholder = @"请选择或输入地址";
    self.carAddress.font = [UIFont systemFontOfSize:14];
    self.carAddress.placeholderColor = [UIColor colorWithHexString:@"#e2e2e5"];
    self.carAddress.placeholderFont = [UIFont systemFontOfSize:15];
    self.carAddress.layer.borderWidth = 0;
    
    // 设置文本框最大行数
    [self.carAddress textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = self.carAddress.frame;
        frame.size.height = textHeight;
        self.carAddress.frame = frame;
    }];
    self.carAddress.maxNumberOfLines = 3;
}


-(void)setUpUISegmentedControl
{
    //排放标准
//    [self.emissionStandardsS setEnabled:NO forSegmentAtIndex:0];
//    [self setUpWithUISegmentedControl:self.emissionStandardsS];
//    [self.emissionStandardsS setBackgroundColor:[UIColor colorWithHexString:@"#e2e2e5"]];
    
    //车辆性质
    [self setUpWithUISegmentedControl:self.carPropertiesS];
    
    //车辆所有者性质
    [self setUpWithUISegmentedControl:self.ownerProS];
}

#pragma mark - 设置排放标准分段选择器
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
        self.model = [[YHCarVersionModel alloc] init];
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
-(void)setUpCarKeyBoard
{
    self.carNumberTF.delegate = self;
    self.carNumberTF.tapAcitonBlock = ^{
        self.keyboardView = [[LYPlateKeyBoardView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.keyboardView.delegate = self;
        
        //        [self.view addSubview:self.keyboardView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.keyboardView];
    };
}

- (void)clickWithString:(NSString *)string
{
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

//设置TextView
-(void)setUpTextView
{
    self.carDesTV.delegate = self;
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    self.lb.text = @"请输入车辆描述";
    self.lb.font = [UIFont systemFontOfSize:14];
    self.lb.enabled = NO;
    [self.carDesTV addSubview:self.lb];
}

#pragma mark - 设置占位符
-(void)setPlaceHolder
{
    return;
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
    [self.carAddress setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.Contact setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.contactNumberTF setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
}

/**
 设置下拉选择
 */
-(void)setUpTextFieldSelect
{
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
    [self initDayPicker:_businessInsuranceTF];
}

/**
 地图定位
 */
- (IBAction)mapLocationClick:(UIButton *)sender
{
    YHMapLocationController *mapVC = [[YHMapLocationController alloc]init];
    mapVC.addressBlock = ^(NSString *address) {
        self.carAddress.text = address;
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - ============================tableView列表代理方法==================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isNeedHide = indexPath.row == 17 && _isHelp;
    if (indexPath.row == 5 || isNeedHide ) {
        return 0;
    }
    if (indexPath.row == 17) {
        return 70;
    }
    return 56;
}

#pragma mark - ================================textField代理方法====================================
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.odometerTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.odometerTF.text.length >= 7) {
            self.odometerTF.text = [textField.text substringToIndex:7];
            return NO;
        }
    }
    if (textField == self.contactNumberTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.contactNumberTF.text.length >= 11) {
            self.contactNumberTF.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    //    return [self validateNumber:string];
    return YES;
}

//#pragma mark - 禁用系统键盘弹出
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.yearTF]//年款
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

#pragma mark - ================================textView代理方法=======================================
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

//开始编辑时
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.lb.alpha = 0;
    return YES;
}

//将要停止编辑(不是第一响应者时)
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.lb.alpha = 1;
    }
    return YES;
}

//textView状态改变的时候
-(void)textViewDidChange:(UITextView *)textView
{
    self.carAddress.centerY = self.cellView.centerY;
}

#pragma mark - ===================================功能模块代码========================================
//验证数字号码
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

//日期选择器
- (void)initPicker:(BRTextField *)text
{
    text.delegate = self;
    text.rightViewMode = UITextFieldViewModeAlways;
    
    __weak typeof(self) weakSelf = self;
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



#pragma mark - ===========================选择排放标准(梅文峰)============================
- (IBAction)selectDischarge:(UIButton *)sender
{
    self.selectedDischarge = self.dischargeArray[0];
    [self.view endEditing:YES];
    [self initCityPicker];
}

-(void)initCityPicker
{
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

#pragma mark - 选择器代理方法
//一共多少咧
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

//返回每一列的行数
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dischargeArray.count;
}

//返回每一行显示的文本
- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dischargeArray[row];
}

//选中某一行后回调 联动的关键
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedDischarge = self.dischargeArray[row];
}

#pragma mark - 选择器“取消”
- (IBAction)pickerCancelAction:(UIButton *)sender
{
    [_pickerViewBox removeFromSuperview];
    _pickerViewBox = nil;
}

#pragma mark - 选择器“确定”
- (IBAction)PickerComfireAction:(UIButton *)sender
{
    [self.dischargeButton setTitle:self.selectedDischarge forState:UIControlStateNormal];
    [_pickerViewBox removeFromSuperview];
    _pickerViewBox = nil;
}

#pragma mark - 懒加载
//- (NSMutableArray *)dischargeArray
//{
//    if (!_dischargeArray) {
//        _dischargeArray = [[NSMutableArray alloc]initWithObjects:@"国V",@"国IV",@"国III",@"国II",@"国I",@"欧V",@"欧IV",@"欧III",@"欧II",@"欧I", nil];
//    }
//    return _dischargeArray;
//}

#pragma mark - 移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:nil object:self];
}

@end
