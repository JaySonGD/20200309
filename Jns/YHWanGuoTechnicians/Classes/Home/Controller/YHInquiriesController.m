//
//  YHInquiriesController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHInquiriesController.h"
#import "YHCommon.h"
#import "YHTools.h"
extern NSString *const notificationBrand;
extern NSString *const notificationCarSel;
@interface YHInquiriesController ()
@property (weak, nonatomic) IBOutlet UITextField *nameFT;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberFT;
@property (weak, nonatomic) IBOutlet UITextField *unitFT;

@property (strong, nonatomic) IBOutlet UIPickerView *provincePV;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *transmissionTF;
@property (strong, nonatomic) IBOutlet UIPickerView *transmissionPC;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)NSMutableDictionary *result;
@property (weak, nonatomic) IBOutlet UITextField *carNumberFT;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UITextField *vinFT;
@property (weak, nonatomic) IBOutlet UITextField *productFT;
@property (weak, nonatomic) IBOutlet UITextField *dateFT;
@property (weak, nonatomic) IBOutlet UITextField *mileFT;
@property (weak, nonatomic) IBOutlet UISlider *unitSL;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UISwitch *on1;
@property (weak, nonatomic) IBOutlet UISwitch *on2;
@property (weak, nonatomic) IBOutlet UISwitch *on3;
@property (strong, nonatomic)IBOutlet UIDatePicker *dateP;
@property (strong, nonatomic)NSMutableDictionary *carResult;
@property (weak, nonatomic) IBOutlet UISlider *oliSL;
@property (nonatomic)NSInteger pickerSel;
@end

@implementation YHInquiriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationBrand:) name:notificationBrand object:nil];
    [center addObserver:self selector:@selector(notificationCarSel:) name:notificationCarSel object:nil];
    // Do any additional setup after loading the view.
    CGRect frame =  _contentView.frame;
    frame.size.width = screenWidth;
    frame.size.height = 890;
    _contentView.frame = frame;
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:CGSizeMake(screenWidth, 890)];
    
    
    self.dateFT.inputView = _dateP;
    self.transmissionTF.inputView = _transmissionPC;
    self.provinceTF.inputView = _provincePV;
    
    // 设置键盘上的ToolBar
    
    UIBarButtonItem *dateHiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(dateHiddenKeyBoard)];
    
    [dateHiddenButtonItem setTintColor:YHNaviColor];
    UIBarButtonItem *dateSpaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *dateAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    dateAccessoryView.barStyle = UIBarStyleDefault;
    
    dateAccessoryView.items = [NSArray arrayWithObjects:dateSpaceButtonItem,dateHiddenButtonItem,nil];
    
    self.dateFT.inputAccessoryView = dateAccessoryView;
    
    // 设置键盘上的ToolBar
    
    UIBarButtonItem *transmissionHiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(transmissionHiddenKeyBoard)];
    
    [transmissionHiddenButtonItem setTintColor:YHNaviColor];
    UIBarButtonItem *transmissionSpaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *transmissionAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    transmissionAccessoryView.barStyle = UIBarStyleDefault;
    
    transmissionAccessoryView.items = [NSArray arrayWithObjects:transmissionSpaceButtonItem,transmissionHiddenButtonItem,nil];
    
    self.transmissionTF.inputAccessoryView = transmissionAccessoryView;
    
    // 设置键盘上的ToolBar
    
    UIBarButtonItem *provinceHiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(provinceHiddenKeyBoard)];
    
    [provinceHiddenButtonItem setTintColor:YHNaviColor];
    UIBarButtonItem *provinceSpaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *provinceAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    provinceAccessoryView.barStyle = UIBarStyleDefault;
    
    provinceAccessoryView.items = [NSArray arrayWithObjects:provinceSpaceButtonItem,provinceHiddenButtonItem,nil];
    
    self.provinceTF.inputAccessoryView = provinceAccessoryView;

}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dateHiddenKeyBoard{
    //滑动收起键盘
    [[self view] endEditing:YES];
    // 获得当前UIPickerDate所在的时间
    NSDate *selected = [_dateP date];
    self.dateFT.text = [YHTools stringFromDate:selected byFormatter:@"yyyy-MM-dd"];
}


- (void)provinceHiddenKeyBoard{
    //滑动收起键盘
    [[self view] endEditing:YES];
    NSDictionary *info = [[self provinceInfo] objectAtIndex:_pickerSel];
    _provinceTF.text = info[@"simple"];
}

- (void)notificationCarSel:(NSNotification*)notice{
    //通过vin填充基本数据
    NSLog(@"%@", notice.userInfo);
    
    NSDictionary *item = notice.userInfo;
    if (_carResult) {
        
        __weak __typeof__(self) weakSelf = self;
        [item.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.carResult setObject:item[key] forKey:key];
        }];
    }else{
        self.carResult = [item mutableCopy];
    }
    // 车信息展示
    
    
    self.result = [@{@"carBrandId" : item[@"carBrandId"],
                    @"carBrandName" : item[@"carBrandName"],
                    @"carLineId" : item[@"carLineId"],
                    @"carLineName" : item[@"carLineName"],
                     @"icoName" : item[@"icoName"],
                     @"carModelId" : item[@"carModelId"],
                     @"carModelName" : item[@"carModelName"],
                    }mutableCopy];
    self.vinFT.text = item[@"vin"];
    self.mileFT.text = item[@"engineEmissions"];
    self.brandName.text = [NSString stringWithFormat:@"%@ %@", _result[@"carBrandName"], _result[@"carLineName"]];
    self.productFT.text = item[@"produceYear"];
    self.unitFT.text = item[@"carCc"];
   _transmissionTF.text = item[@"gearboxType"];
}

- (void)notificationBrand:(NSNotification*)notice{
    //品牌选择成功
    if (_result) {
        __weak __typeof__(self) weakSelf = self;
        [notice.userInfo.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.result setObject:notice.userInfo[key] forKey:key];
        }];
    }else{
        self.result = [notice.userInfo mutableCopy];
    }
    _brandName.text = [NSString stringWithFormat:@"%@ %@", _result[@"carBrandName"], _result[@"carLineName"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"next"]) {
//        YHInquiriesInfoController *controller = segue.destinationViewController;
//       NSArray *billType =   @[((_on1.on)? (@"J") : (@"")),((_on2.on)? (@"B") : (@"")),((_on3.on)? (@"W") : (@""))];
//        NSMutableDictionary *baseInfo = [@{
//          @"carLineId" : _result[@"carLineId"],//    int    Y    车系id
//          @"carLineName" : _result[@"carLineName"],//    string    Y    车系名称
//          @"carBrandId" : _result[@"carBrandId"],//    int    Y    车型id
//          @"carBrandName" : _result[@"carBrandName"],//    string    Y    车型名称
//          @"carCc" : _unitFT.text,//    string    Y    排量
//          @"gearboxType" : _transmissionTF.text,//    string    Y    变速箱类型
//          @"carType" : ((_result)? (@0) : (@1)),//    int    Y    0估车网 1系统和车主填写信息
//          @"vin" : _vinFT.text,//    string    Y    车架号
//          @"plateNumberP" : _provinceTF.text,//    string    Y    车辆区域识别 如：粤
//          @"plateNumberC" : [_carNumberFT.text substringWithRange:NSMakeRange(0, 1)],//    string    Y    车辆区域识别 如：A
//          @"plateNumber" : [_carNumberFT.text substringWithRange:NSMakeRange(1, 5)],//    string    Y    车牌号码
//          @"userName" : _nameFT.text,//    string    N    用户名
//          @"phone" : _phoneNumberFT.text,//    string    Y    联系方式
//          @"tripDistance" : _mileFT.text,//    string    Y    行驶里程，公里数
//          @"carYear" : _productFT.text,//    int    Y    汽车生产年份：年
//          @"startTime" : _dateFT.text,//    string    Y    开始时间
//          @"fuelMeter" : [NSNumber numberWithInteger:(100 * _oliSL.value)],//    int    N    燃油表
//          }mutableCopy];
//        if (_result) {
//            [baseInfo addEntriesFromDictionary:@{@"carModelId" :_result[@"carModelId"],//    int    N    车辆版本id，如果carType 为1不用此字段
//                                                 @"carModelName" : _result[@"carModelName"]//    string    N    车辆版本，如果carType 为1不用此字段
//                                                 }];
//        }
//        controller.billType = [billType componentsJoinedByString:@""];
//        controller.baseInfo = baseInfo;
//    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    /*
   

    */
    if ([identifier isEqualToString:@"next"] ) {
        
        if (!_on1.on && !_on2.on && !_on3.on) {
            [MBProgressHUD showError:@"请输工单类型！"];
            return NO;
        }
        if (self.nameFT.text.length == 0 ) {
            [MBProgressHUD showError:@"请输入名称"];
            return NO;
        }
        if (self.phoneNumberFT.text.length != 11 ) {
            [MBProgressHUD showError:@"请输入正确手机号码"];
            return NO;
        }
        
        if (self.provinceTF.text.length == 0 ) {
            [MBProgressHUD showError:@"请选择车牌属地"];
            return NO;
        }
        
        if (self.carNumberFT.text.length != 6 ) {
            [MBProgressHUD showError:@"请输入正确车牌号"];
            return NO;
        }
        
        if (self.vinFT.text.length != 17 ) {
            [MBProgressHUD showError:@"请输入正确车架号！"];
            return NO;
        }
        
        if (!_result) {
            [MBProgressHUD showError:@"请选择车型 车系"];
            return NO;
        }
        
        if (self.unitFT.text.length == 0 ) {
            [MBProgressHUD showError:@"请输入排量"];
            return NO;
        }
        
        
        if (self.transmissionTF.text.length == 0 ) {
            [MBProgressHUD showError:@"请选择变速箱"];
            return NO;
        }
        
        if (self.productFT.text.length == 0 ) {
            [MBProgressHUD showError:@"请输入生产年份"];
            return NO;
        }
        
        if (self.dateFT.text.length == 0 ) {
            [MBProgressHUD showError:@"请选择开始时间"];
            return NO;
        }
        
        if (self.mileFT.text.length == 0 ) {
            [MBProgressHUD showError:@"请输入里程"];
            return NO;
        }
    }
    return YES;
}


- (void)transmissionHiddenKeyBoard{
    //滑动收起键盘
    [[self view] endEditing:YES];
    _transmissionTF.text = [self transmissions][_pickerSel];
}

- (IBAction)onAction:(id)sender {
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    _pickerSel = row;
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _transmissionPC) {
        return [self transmissions][row];
    }
    NSDictionary *info = [[self provinceInfo] objectAtIndex:row];
    return info[@"simple"];
}
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _transmissionPC) {
        return [self transmissions].count;
    }
    return [self provinceInfo].count;
}

- (NSArray*)transmissions{
    return  @[@"电子无级变速器",
              @"手动变速器",
              @"手自一体变速器",
              @"双离合变速器",
              @"无级变速器",
              @"序列变速器",
              @"自动变速器"];
}


- (NSArray*)provinceInfo{
    return @[
             @{
                 @"name": @"北京市",
                 @"simple": @"京",
                 @"code": @"P1001"
                 },
             @{
                 @"name": @"上海市",
                 @"simple": @"沪",
                 @"code": @"P1002"
                 },
             @{
                 @"name": @"天津市",
                 @"simple": @"津",
                 @"code": @"P1003"
                 },
             @{
                 @"name": @"重庆市",
                 @"simple": @"渝",
                 @"code": @"P1004"
                 },
             @{
                 @"name": @"黑龙江",
                 @"simple": @"黑",
                 @"code": @"P1005"
                 },
             @{
                 @"name": @"吉林省",
                 @"simple": @"吉",
                 @"code": @"P1006"
                 },
             @{
                 @"name": @"辽宁省",
                 @"simple": @"辽",
                 @"code": @"P1007"
                 },
             @{
                 @"name": @"内蒙古",
                 @"simple": @"蒙",
                 @"code": @"P1008"
                 },
             @{
                 @"name": @"河北省",
                 @"simple": @"冀",
                 @"code": @"P1009"
                 },
             @{
                 @"name": @"新疆",
                 @"simple": @"新",
                 @"code": @"P1010"
                 },
             @{
                 @"name": @"甘肃省",
                 @"simple": @"甘",
                 @"code": @"P1011"
                 },
             @{
                 @"name": @"青海省",
                 @"simple": @"青",
                 @"code": @"P1012"
                 },
             @{
                 @"name": @"陕西省",
                 @"simple": @"陕",
                 @"code": @"P1013"
                 },
             @{
                 @"name": @"宁夏",
                 @"simple": @"宁",
                 @"code": @"P1014"
                 },
             @{
                 @"name": @"河南省",
                 @"simple": @"豫",
                 @"code": @"P1015"
                 },
             @{
                 @"name": @"山东省",
                 @"simple": @"鲁",
                 @"code": @"P1016"
                 },
             @{
                 @"name": @"山西省",
                 @"simple": @"晋",
                 @"code": @"P1017"
                 },
             @{
                 @"name": @"安徽省",
                 @"simple": @"皖",
                 @"code": @"P1018"
                 },
             @{
                 @"name": @"湖北省",
                 @"simple": @"鄂",
                 @"code": @"P1019"
                 },
             @{
                 @"name": @"湖南省",
                 @"simple": @"湘",
                 @"code": @"P1020"
                 },
             @{
                 @"name": @"江苏省",
                 @"simple": @"苏",
                 @"code": @"P1021"
                 },
             @{
                 @"name": @"四川省",
                 @"simple": @"川",
                 @"code": @"P1022"
                 },
             @{
                 @"name": @"贵州省",
                 @"simple": @"黔",
                 @"code": @"P1023"
                 },
             @{
                 @"name": @"云南省",
                 @"simple": @"滇",
                 @"code": @"P1024"
                 },
             @{
                 @"name": @"广西省",
                 @"simple": @"桂",
                 @"code": @"P1025"
                 },
             @{
                 @"name": @"西藏",
                 @"simple": @"藏",
                 @"code": @"P1026"
                 },
             @{
                 @"name": @"浙江省",
                 @"simple": @"浙",
                 @"code": @"P1027"
                 },
             @{
                 @"name": @"江西省",
                 @"simple": @"赣",
                 @"code": @"P1028"
                 },
             @{
                 @"name": @"广东省",
                 @"simple": @"粤",
                 @"code": @"P1029"
                 },
             @{
                 @"name": @"福建省",
                 @"simple": @"闽",
                 @"code": @"P1030"
                 },
             @{
                 @"name": @"台湾省",
                 @"simple": @"台",
                 @"code": @"P1031"
                 },
             @{
                 @"name": @"海南省",
                 @"simple": @"琼",
                 @"code": @"P1032"
                 },
             @{
                 @"name": @"香港",
                 @"simple": @"港",
                 @"code": @"P1033"
                 },
             @{
                 @"name": @"澳门",
                 @"simple": @"澳",
                 @"code": @"P1034"
                 }
             ];
}
@end
