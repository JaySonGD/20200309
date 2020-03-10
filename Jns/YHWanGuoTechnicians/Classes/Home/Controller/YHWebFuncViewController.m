//
//  YHWebFuncViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/7.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <UShareUI/UShareUI.h>  //分享面板
#import "YHWebFuncViewController.h"
//#import "YHLoginViewController.h"
#import "YHNewLoginController.h"
#import "YHOrderListController.h"
#import "YHVinScanningController.h"
#import "SmartOCRCameraViewController.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "UIViewController+OrderDetail.h"
#import "YHScreeningConditionsController.h"
#import "YHExtrendBackListController.h"
#import "YHCheckListViewController.h"
#import "YHExtrendListController.h"
#import "YHCarPhotoService.h"
#import "YHCarVersionModel.h"
#import "YHDiagnosisBaseVC.h"

#import "YHUploadingController.h"

#import "TTZDBModel.h"
#import "NSObject+BGModel.h"
#import "TTZUpLoadService.h"

#import "UIViewController+OrderDetail.h"
#import "YHExtrendDetailController.h"
#import "ALPlayerViewSDKViewController.h"
#import "YHWorkboardDetailController.h"

#import "NewBillViewController.h"
#import "AppDelegate.h"

#import "YHSiteModel.h"

#import "YHCarValuationViewController.h"

#import <MapKit/MapKit.h>

#import "YTRepairViewController.h"
#import "YHSolutionListViewController.h"

#import "YHHelpCheckMapController.h"
#import "TTZCheckViewController.h"

#import "YHIntelligentDiagnoseController.h"
#import "YTRecordConViewtroller.h"

//#import "YTPayInfoController.h"
#import "YTCounterController.h"
#import "YTDepthController.h"

#import "YTDepthController.h"

#import "YHIntelligentCheckModel.h"
#import "YTPlanModel.h"
#import "YTOrderDetailNewController.h"


#import "YHOrderDetailNewController.h"
#import "TTZSurveyModel.h"

extern NSString *const notificationOrderListChange;
@interface YHWebFuncViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *testBackB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

//分享地址,分享title,分享副标题,分享图片地址
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *titles;
@property (nonatomic, copy)NSString *describe;
@property (nonatomic, copy)NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UIView *topStatusBarView;

@property (nonatomic, strong) NSArray <TTZDBModel *>*models;
@property (nonatomic, assign) NSInteger finisnCount;

@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UIWebView *leftWebView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (strong,nonatomic) CLLocationManager* locationManager;


@end

@implementation YHWebFuncViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    _topViewHeight.constant = ((iPhoneX)? (44) : (20));
#ifndef YHProduction
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _testBackB.hidden = NO;
#else
    _testBackB.hidden = YES;
#endif
}

- (void)initNavigation{
    
    //    if ([self.title isEqualToString:@"智慧门店"]) {
    //        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //        // newBack
    //        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [backBtn setImage:[UIImage imageNamed:@"newBack"] forState:UIControlStateNormal];
    //        backBtn.frame = CGRectMake(0, 0, 44, 44);
    //        [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    //        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    //        UIBarButtonItem *backIiem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //        self.navigationItem.leftBarButtonItem = backIiem;
    //         self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    //    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isFeedBackPush == NO) {
        [self initVar];
        
        [self initUI];
        
        [self initData];
    }
    [self toH5:@{@"jnsAppStep":@"refresh"}];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
}

- (void)popViewController:(id)sender{
    [super popViewController:sender];
    
}

- (void)initVar
{
    _finisnCount = 0;
    _models =  [TTZDBModel findWhere:[NSString stringWithFormat:@"where isUpLoad = %d",YES]];
}

#pragma mark - intVar
- (void)initUI
{
    NSString *text = [NSString stringWithFormat:@"(0/%ld)",_models.count];
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} context:nil].size.width;
    _barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width + 31, 30)];
    CGFloat marginX = 10.0;
    //左边
    _leftWebView = [[UIWebView alloc] initWithFrame:CGRectMake(marginX, 5, 30, 20)];
    _leftWebView.opaque = NO;
    _leftWebView.scalesPageToFit = YES;
    _leftWebView.backgroundColor = [UIColor clearColor];
    [_leftWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"uploading" ofType:@"gif"]]]];
    [_barView addSubview:_leftWebView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(marginX, 5, 30, 20);
    [_leftButton setImage:[UIImage imageNamed:@"upload_pic"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(clickBar) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_leftButton];
    
    if (_models.count != 0) {
        _leftWebView.hidden = NO;
        _leftButton.hidden = YES;
    } else {
        _leftWebView.hidden = YES;
        _leftButton.hidden = NO;
    }
    
    //右边
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(30 + marginX, 0, width, 30);
    [_rightButton setTitle:text forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_rightButton addTarget:self action:@selector(clickBar) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_rightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_barView];
    
}

#pragma mark - initData
- (void)initData
{
    _finisnCount = 0;
    
    _models =  [TTZDBModel findWhere:[NSString stringWithFormat:@"where isUpLoad = %d",YES]];
    
    [TTZUpLoadService sharedTTZUpLoadService].complete = ^(NSString *fileId) {
        
        _finisnCount += 1;
        
        if (_finisnCount < _models.count) {
            _leftWebView.hidden = NO;
            _leftButton.hidden = YES;
            [_rightButton setTitle:[NSString stringWithFormat:@"(%ld/%ld)",_finisnCount,_models.count] forState:UIControlStateNormal];
        } else {
            _leftWebView.hidden = YES;
            _leftButton.hidden = NO;
            [_rightButton setTitle:[NSString stringWithFormat:@"(0/0)"] forState:UIControlStateNormal];
        }
    };
}

- (void)clickBar
{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"YHUploading" bundle:nil] instantiateViewControllerWithIdentifier:@"YHUploadingController"] animated:YES];
}

- (void)popViewController1:(id)sender
{
    //    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    //    YHLoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
    //    [self.navigationController pushViewController:controller animated:YES];
    YHNewLoginController *newLoginVc = [[YHNewLoginController alloc] init];
    [self.navigationController pushViewController:newLoginVc animated:YES];
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (void)popTopWebController{
    
    if (self.navigationController.topViewController == self) {
        [self popViewController:nil];
        return ;
    }
    
    __block UIViewController *vc = nil;
    NSMutableArray *childViewControllers = [[self.navigationController.childViewControllers reverseObjectEnumerator] allObjects].mutableCopy;
    [childViewControllers enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
            vc = obj;
            *stop = YES;
        }
    }];
    
    if (vc) {
        [childViewControllers removeObject:vc];
        [self.navigationController setViewControllers:[[childViewControllers reverseObjectEnumerator] allObjects]];
        return;
    }
    
    [self popViewController:nil];
}

// Objective-C语言
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"-----===1：%@===------",urlString);
    
#ifdef LearnVersion
    
    // 上传UUId
    if ([urlString containsString:@"getAppUUId"]) {
        // 设备UUID
        NSLog(@"%@",[YHTools getUniqueDeviceIdentifierAsString]);
        NSString *sciptStr = [NSString stringWithFormat:@"getUUId(\"%@\")",[YHTools getUniqueDeviceIdentifierAsString]];
        [webView stringByEvaluatingJavaScriptFromString:sciptStr];
    }
    // 登录成功回调
    if ([urlString containsString:@"loginCallBack"]) {
        
        NSString *paramStr = request.URL.query;
        NSArray *paramArr = [paramStr componentsSeparatedByString:@"&"];
        for (int i = 0; i<paramArr.count; i++) {
            NSString *unitParam = paramArr[i];
            NSArray *unitArr = [unitParam componentsSeparatedByString:@"="];
            if ([unitParam containsString:@"username"]) {
                [YHTools setName:unitArr.lastObject];
            }
            if ([unitParam containsString:@"password"]) {
                [YHTools setPassword:unitArr.lastObject];
            }
            if ([unitParam containsString:@"token"]) {
                [YHTools setAccessToken:unitArr.lastObject];
            }
        }
    }
    
    // 安全诊断
    if ([urlString containsString:@"safetyDiagnosis"]) {
        
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.title = @"安全检测";
        controller.urlStr = [NSString stringWithFormat:@"%@/billimenu.html?menuId=1&token=%@&status=ios", SERVER_PHP_URL_Statements_H5, [YHTools getAccessToken]];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    // 工单管理
    if ([urlString containsString:@"manageWork"]) {
        
        NSString *urlTruckStr = @"menu";
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.title = @"工单管理";
        controller.urlStr = [NSString stringWithFormat:@"%@/%@.html?token=%@&status=ios%@&education=1", SERVER_PHP_URL_Statements_H5, urlTruckStr, [YHTools getAccessToken], @""];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    // 智能诊断
    if ([urlString containsString:@"intelligentDiagnosis"]) {
        
        NSString *urlTruckStr = @"technicalAssistant/index";
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.title = @"工单管理";
        controller.urlStr = [NSString stringWithFormat:@"%@/%@.html?token=%@&status=ios&%@%@", SERVER_PHP_URL_Statements_H5, urlTruckStr, [YHTools getAccessToken], @"",@"education=1"];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    // 解决方案
    if ([urlString containsString:@"SpecialDiagnosis"]) {
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.title = @"专项检测";
        controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&dedicatedType=J003&status=ios", SERVER_PHP_URL_Statements_H5, [YHTools getAccessToken]];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    // 专项诊断
    if ([urlString containsString:@"ResolveProgram"]) {
        
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@/resolveSolution/?token=%@&status=ios#/vin", SERVER_PHP_URL_Statements_H5, [YHTools getAccessToken]];
        //http://static.demo.com/app/resolveSolution/?token=ca6408299b8703a31ca65991e607e668&status=ios#/vin
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
#else
#endif
    
    if ([urlString containsString:@"carValuation"]) {
        // 车辆估值
        NSArray *carValuationArr = [request.URL.path  componentsSeparatedByString:@"/"];
        NSString *billId = carValuationArr.lastObject;
        
        
        YHCarValuationViewController *VC = [[UIStoryboard storyboardWithName:@"YHCarValuation" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCarValuationViewController"];
        VC.billId = [NSString stringWithFormat:@"%@",billId];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
        
        NSLog(@"----------=======2: %@=======------------",arrFucnameAndParameter);
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        NSLog(@"----------=======3%@===%@===%@===------------",arrFucnameAndParameter[0],arrFucnameAndParameter[1],arrFucnameAndParameter);
        
        for (id Obj in arrFucnameAndParameter) {
            NSLog(@"----------=======4: %@=======------------",Obj);
        }
        
        if ([arrFucnameAndParameter count] == 1)
        {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc"])
            {
                /*调用本地函数1*/
                NSLog(@"doFunc");
            }
        }
        else if([arrFucnameAndParameter count] >= 2)
        {
            //有参数的
            if([funcStr isEqualToString:@"doFunc"] && [arrFucnameAndParameter objectAtIndex:1])
            {
                
                //h5ToApp
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"h5ToApp"]) {
                    
                    //
                    NSString *json = (arrFucnameAndParameter.count>2)? [arrFucnameAndParameter objectAtIndex:2] : @"";
                    
                    [self h5ToApp:json];
                }
                
                
                //stuToSport
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"stuToSport"]) {
                    
                    //
                    NSString *par = (arrFucnameAndParameter.count>2)? [arrFucnameAndParameter objectAtIndex:2] : @"";
                    
                    [self stuToSport:par];
                }
                //stuSportInfo
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"stuSportInfo"]) {
                    
                    //
                    NSString *par = (arrFucnameAndParameter.count>2)? [arrFucnameAndParameter objectAtIndex:2] : @"";
                    
                    [self stuSportInfo:par];
                }
                
                
                //location
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"getLocationInformation"]) {
                    
                    [self getLocationInformation];
                }
                
                //airCondition
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"airCondition"]) {
                    NSString *carBrand = (arrFucnameAndParameter.count>2)? [arrFucnameAndParameter objectAtIndex:2] : @"";
                    [self getAirCondition:carBrand];
                }
                //airConditionAi
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"airConditionAi"]) {
                    NSString *carBrand = (arrFucnameAndParameter.count>2)? [arrFucnameAndParameter objectAtIndex:2] : @"";
                    [self ai:carBrand];
                }
                // 展示图片
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"showImg"]) {
                    //#warning 功能做好了要改掉
                    //                    [self getAirCondition];
                    //                    [self.navigationController pushViewController:[YTRepairViewController new] animated:YES];
                    [self showImageByCode:[arrFucnameAndParameter objectAtIndex:2]];
                }
                
                //(MWF)
                /*1.保单详情*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"warrantyDetail"]) {
                    
                    //objc://doFunc/warrantyDetail／保单数据（JSON格式化的字符串）
                    if (arrFucnameAndParameter.count >= 3) {
                        NSString *json = [self URLDecodedString:arrFucnameAndParameter[2]];
                        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:NULL];
                        
                        NSString *status = [dic valueForKey:@"status"];
                        //                        NSDictionary *extrendDict = @{@"-1":@(0),@"0":@(1),@"2":@(2),@"1":@(3),@"9":@(4),@"4":@(4)};
                        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                        YHExtrendDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHExtrendDetailController"];
                        controller.extrendOrderInfo = dic;
                        controller.status = status;
                        [self.navigationController pushViewController:controller animated:YES];
                        NSLog(@"%s", __func__);
                    }
                }
                
                //(MWF)
                /*2.工单详情*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"workOrderDetail"]) {
                    //objc://doFunc/workOrderDetail/工单类型（如：未处理 0，未完成 1，历史(已完成) 2）／工单数据（JSON格式化的字符串）
                    if (arrFucnameAndParameter.count >= 4) {
                        
                        NSInteger type = [arrFucnameAndParameter[2] integerValue];
                        NSString *json = [self URLDecodedString:arrFucnameAndParameter[3]];
                        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:NULL];
                        
                        
                        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                            NSString *homeToCheck = [dic valueForKey:@"homeToCheck"];
                            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            app.h5Source = homeToCheck;
                        }
                        
                        if(([dic[@"billType"] isEqualToString:@"J002"] || [dic[@"billType"] isEqualToString:@"J003"]) && [dic[@"nowStatusCode"] isEqualToString:@"consulting"]){
                            NSDictionary *parm = @{
                                @"jnsAppStatus": @"ios",
                                @"jnsAppStep": @"usedCarInitialSurvey",
                                @"bill_id": dic[@"id"],
                                @"bill_type": dic[@"billType"],
                            };
                            [self h5ToApp:[parm mj_JSONString]];
                            
                        }else {
                            
                            YHFunctionId functionKey = type?((type>1)? YHFunctionIdHistoryWorkOrder:YHFunctionIdUnfinishedWorkOrder):YHFunctionIdUnfinishedWorkOrder;
                            [self orderDetailNavi:dic code:functionKey];
                            NSLog(@"%s", __func__);
                        }
                    }
                }
                
                //(MWF)
                /*3.工单列表*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"workOrderList"]) {
                    //objc://doFunc/workOrderDetail/工单类型（如：未处理 0，未完成 1，历史 2）／工单数据（JSON格式化的字符串）
                    if (arrFucnameAndParameter.count >= 4) {
                        NSInteger type = [arrFucnameAndParameter[2] integerValue];//工单类型（如：未处理 0，未完成 1，历史 2）
                        NSString *vin = arrFucnameAndParameter[3];//vin
                        
                        __weak __typeof__(self) weakSelf = self;
                        __block BOOL isBack = NO;
                        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[YHOrderListController class]]) {
                                YHOrderListController *listVC = (YHOrderListController* )obj;
                                listVC.keyWord = vin;
                                listVC.functionKey = type?((type>1)? YHFunctionIdHistoryWorkOrder:YHFunctionIdUnfinishedWorkOrder):YHFunctionIdUnfinishedWorkOrder;
                                [[NSNotificationCenter
                                  defaultCenter]postNotificationName:notificationOrderListChange
                                 object:Nil
                                 userInfo:nil];
                                [weakSelf.navigationController popToViewController:obj animated:YES];
                                *stop = YES;
                                isBack = YES;
                            }
                        }];
                        if (!isBack) {
                            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                            YHOrderListController *listVC = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
                            listVC.keyWord = vin;
                            listVC.functionKey = type?((type>1)? YHFunctionIdHistoryWorkOrder:YHFunctionIdUnfinishedWorkOrder):YHFunctionIdUnfinishedWorkOrder;
                            [self.navigationController pushViewController:listVC animated:YES];
                        }
                    }
                }
                //(MWF)
                /**
                 开单 billing
                 未处理工单 unprocessedWorkOrder
                 未完成工单 unfinishedWorkOrder
                 历史工单 historicalWorkOrder
                 未处理订单 unprocessedOrder
                 历史订单 historyOrder
                 **/
                if([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"unprocessedWorkOrder"]
                   || [[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"unfinishedWorkOrder"]
                   || [[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"historicalWorkOrder"]
                   || [[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"unprocessedOrder"]
                   || [[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"historyOrder"]){
                    YHFunctionId functionKey = YHFunctionIdUnfinishedWorkOrder;
                    if([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"unprocessedWorkOrder"]){//未处理工单
                        functionKey = YHFunctionIdUnfinishedWorkOrder;
                    }
                    if([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"unfinishedWorkOrder"]){//未完成工单
                        functionKey = YHFunctionIdUnfinishedWorkOrder;
                    }
                    if([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"historicalWorkOrder"]){//历史工单
                        functionKey = YHFunctionIdHistoryWorkOrder;
                    }
                    if([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"unprocessedOrder"]){//未处理订单
                        functionKey = YHFunctionIdUnprocessedOrder;
                    }
                    if([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"historyOrder"]){//历史订单
                        functionKey = YHFunctionIdHistoryOrder;
                    }
                    
                    __weak __typeof__(self) weakSelf = self;
                    __block BOOL isBack = NO;
                    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[YHOrderListController class]]) {
                            ((YHOrderListController*)obj).functionKey = functionKey;
                            ((YHOrderListController*)obj).isLevelTwo = YES;
                            ((YHOrderListController*)obj).showCarReport = (self.functionK == YHFunctionIdTrain) && (functionKey == YHFunctionIdUnfinishedWorkOrder);
                            
                            [[NSNotificationCenter
                              defaultCenter]postNotificationName:notificationOrderListChange
                             object:Nil
                             userInfo:nil];
                            [weakSelf.navigationController popToViewController:obj animated:YES];
                            *stop = YES;
                            isBack = YES;
                        }
                    }];
                    if (!isBack) {
                        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                        YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"]; controller.functionKey = functionKey;
                        controller.isLevelTwo = YES;
                        
                        controller.showCarReport = (self.functionK == YHFunctionIdTrain) && (functionKey == YHFunctionIdUnfinishedWorkOrder);
                        
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    
                }
                
                //(MWF)
                /*返回工单列表*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"orderList"]) {
                    __weak __typeof__(self) weakSelf = self;
                    __block BOOL isBack = NO;
                    if (arrFucnameAndParameter.count > 2 ) {
                        [MBProgressHUD showSuccess:[YHTools decodeString:[arrFucnameAndParameter objectAtIndex:2]] toView:self.navigationController.view];
                    }
                    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[YHOrderListController class]]) {
                            
                            [[NSNotificationCenter
                              defaultCenter]postNotificationName:notificationOrderListChange
                             object:Nil
                             userInfo:nil];
                            [weakSelf.navigationController popToViewController:obj animated:YES];
                            *stop = YES;
                            isBack = YES;
                        }
                    }];
                    if (!isBack) {
                        
                        NSMutableArray *controllers = self.navigationController.childViewControllers.mutableCopy;
                        [controllers enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if([obj isKindOfClass:[NewBillViewController class]]){
                                [controllers removeObject:self];
                                [controllers removeObject:obj];
                            }
                        }];
                        
                        
                        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                        YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
                        controller.functionKey = YHFunctionIdUnfinishedWorkOrder;
                        //[self.navigationController pushViewController:controller animated:YES];
                        [controllers addObject:controller];
                        [self.navigationController setViewControllers:controllers];
                        
                    }
                }
                
                //(MWF)
                /*4.客服养车管理*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"subsidyDetails"]) {
                    YHWorkboardDetailController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWorkboardDetailController"];
                    controller.vin = arrFucnameAndParameter[2];
                    controller.isTubeCarPush = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                //(MWF)
                /*导航栏返回按钮*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"back"]) {
                    [[NSNotificationCenter
                      defaultCenter]postNotificationName:notificationOrderListChange
                     object:Nil
                     userInfo:nil];
                    //[self popViewController:nil];
                    [self popTopWebController];
                }
                
                //(MWF)
                /*重新登录*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"relogin"]) {
#ifdef LearnVersion
#ifdef YHProduction
                    NSString *needLoadUrl = [NSString stringWithFormat:@"https://s.laijingedu.cn/eduWeb/#/?orgId=%@",OrgId];
#else
                    NSString *needLoadUrl = @"http://192.168.1.200/eduWeb";
#endif
                    [self loadWebPageWithString:needLoadUrl];
#else
                    YHNewLoginController *newLoginVc = [[YHNewLoginController alloc] init];
                    [self.navigationController pushViewController:newLoginVc animated:YES];
#endif
                }
                
                //(MWF)
                /*回到首页*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"home"]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                //(MWF)
                /*服务单管理*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"InsuranceOrder"]) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                    YHExtrendListController *controller = [board instantiateViewControllerWithIdentifier:@"YHExtrendListController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                //(MWF)
                /*视频播放*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"alPlayer"]) {
                    ALPlayerViewSDKViewController *controller = [[ALPlayerViewSDKViewController alloc]init];
                    [controller setPlayauth:[YHTools decodeString:[arrFucnameAndParameter objectAtIndex:3]]];
                    [controller setVid:[arrFucnameAndParameter objectAtIndex:2]];
                    [self presentViewController:controller animated:YES completion:^{
                        NSLog(@"ViewController presentViewController");
                    }];
                }
                
                //(MWF)
                //扫描识别VIN码
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"vin"]) {
                    SmartOCRCameraViewController *controller = [[SmartOCRCameraViewController alloc] init];
                    controller.recogOrientation = RecogInVerticalScreen;//竖屏
                    controller.webController = self;
                    controller.isLocation = NO;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                
                if ( [[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"giveVin"] ) {
                    
                    NSString *vin = [arrFucnameAndParameter objectAtIndex:2];
#pragma mark - h5修改vin
                    __block BOOL hasNewBillViewController = NO;
                    NSMutableArray *controllers = self.navigationController.childViewControllers.mutableCopy;
                    [controllers enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if([obj isKindOfClass:[NewBillViewController class]]){
                            ((NewBillViewController *)obj).vin = vin;
                            [self.navigationController popToViewController:obj animated:YES];
                            hasNewBillViewController = YES;
                            *stop = YES;
                        }
                    }];
                    
                    if (!hasNewBillViewController) {
                        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                        NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
                        controller.vin = vin;
                        //[self.navigationController pushViewController:controller animated:YES];
                        [controllers removeObject:self];
                        [controllers addObject:controller];
                        [self.navigationController setViewControllers:controllers];
                    }
                }
                
                //智能诊断 - 深度诊断VIN码
                if ( [[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"scanVin"] ) {
                    
#pragma mark - 新开单
                    //reportType/orderType/type
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                    NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
                    
                    if(arrFucnameAndParameter.count>2){
                        NSString *parameter3 =  [arrFucnameAndParameter objectAtIndex:2];
                        if ([parameter3 isEqualToString:@"intelligent_menu"]) {
                            NSString *encodeTitle = (arrFucnameAndParameter.count>4)?[arrFucnameAndParameter objectAtIndex:4]:[YHTools encodeString:@"深度诊断"];
                            
                            NSString *menucode = [arrFucnameAndParameter objectAtIndex:2];
                            controller.webURLString = [NSString stringWithFormat:@"%@%@/%@.html?token=%@&status=ios&menuCode=%@&menuName=%@", @"technicalAssistant/index",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken],menucode,encodeTitle];
                            
                            controller.type = YYNewBillStyleHelpHelper;
                        }else  if ([parameter3 isEqualToString:@"bill_type_W001"]) {
                            controller.type = YYNewBillStyleSchemaQuery;
                            controller.webController = self;
                        }
                        else  if ([parameter3 isEqualToString:@"order_air"]) {
                            controller.type = YYNewBillStyleOrderAir;
                            controller.webController = self;
                        }else  if ([parameter3 isEqualToString:@"stu_fault_code"] || [parameter3 isEqualToString:@"air_conditioner_special"]) {
                            controller.type = YYNewBillStyleReturnRefresh;
                            controller.webController = self;
                        }else  if ([parameter3 isEqualToString:@"bill_type_J005"]) {
                            controller.type = YYNewBillStyleOrderJ005;
                            controller.webController = self;
                        }
                        else  if ([parameter3 isEqualToString:@"bill_type_J007"]) {
                            controller.type = YYNewBillStyleOrderJ007;
                            controller.webController = self;
                        }
                        else  if ([parameter3 isEqualToString:@"menu_help"]) {
                            controller.type = YYNewBillStyleHelpHelper;
                            controller.webController = self;
                            [controller setControllerTitle:@"智能保养"];
                            NSString *encodeTitle = [YHTools encodeString:@"智能保养"];
                            
                            controller.webURLString = [NSString stringWithFormat:@"%@%@/%@.html?token=%@&status=ios%@&menuCode=%@&menuName=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, @"technicalAssistant/index", [YHTools getAccessToken],@"",parameter3,encodeTitle];
                            
                        }
                    }
                    
                    if(arrFucnameAndParameter.count>3){
                        NSString *menucode = [arrFucnameAndParameter objectAtIndex:2];
                        BOOL isShowImage = [[arrFucnameAndParameter objectAtIndex:3] boolValue];
                        controller.isShowImageBtn = isShowImage;
                        controller.imageByCode = menucode;
                    }
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                //新开单扫描识别VIN码
                if ( [[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"sweepVin"] ) {
                    
#pragma mark - 新开单
                    //reportType/orderType/type
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                    NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
                    NSString *reportType = nil;
                    if(arrFucnameAndParameter.count>2){
                        reportType = [arrFucnameAndParameter objectAtIndex:2];
                    }
                    
                    if(arrFucnameAndParameter.count>3){
                        NSString *orderType = [arrFucnameAndParameter objectAtIndex:3];
                        controller.isShowImageBtn = [orderType isEqualToString:@"J003"];
                        controller.imageByCode = @"specialCheck";
                    }
                    controller.reportType = reportType;
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }
                
                /*二手车检测*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"UsedCarCheck"]) {
                    YHCheckListViewController *VC = [[UIStoryboard storyboardWithName:@"YHCheckList" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCheckListViewController"];
                    VC.type = 2;
                    VC.title = @"二手车帮检单";
                    [self.navigationController pushViewController:VC animated:YES];
                }
                
                //(MWF)
                /*代售检测*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"Booking"]) {
                    YHCheckListViewController *VC = [[UIStoryboard storyboardWithName:@"YHCheckList" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCheckListViewController"];
                    VC.type = 1;
                    VC.title = @"代售检测单";
                    [self.navigationController pushViewController:VC animated:YES];
                }
                
                //(MWF)
                /*调用本地函数1*///
                // H5控制是否显示或者隐藏导航 @"0"显示导航 @"1"不显示导航  @"" 未知，以代码控制
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"showNavi"]) {//显示导航和 title
                    if (arrFucnameAndParameter.count >= 3) {
                        NSString *showNaviBarState = arrFucnameAndParameter[2];
                        if (![showNaviBarState isEqualToString:@""]){
                            self.barHidden = showNaviBarState.boolValue;
                            [self.navigationController setNavigationBarHidden:showNaviBarState.boolValue animated:NO];
                            if (arrFucnameAndParameter.count >= 4) {
                                self.title = [YHTools decodeString:arrFucnameAndParameter[3]];
                                NSLog(@"------====%@====-------",[YHTools decodeString:arrFucnameAndParameter[3]]);
                            }
                        }
                    }
                }
                
                //(MWF)
                /*拨打电话*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"callphone"]) {
                    NSString *phone = [arrFucnameAndParameter objectAtIndex:2];
                    NSString *allString = [NSString stringWithFormat:@"tel:%@", phone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                }
                
                //(MWF)
                /*筛选条件*///
                if ([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"backSearch"]) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YHScreeningConditionsController *controller = [board instantiateViewControllerWithIdentifier:@"YHScreeningConditionsController"];
                    
                    controller.webController = self;
                    NSArray *parameters = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@"&"];
                    if (parameters.count >= 3) {
                        NSMutableDictionary *date = [@{}mutableCopy];
                        for (NSInteger i = 1; parameters.count > i; i++) {
                            NSString *parameter = parameters[i];
                            NSArray *parameterKeyAndValue = [parameter componentsSeparatedByString:@"="];
                            if (parameterKeyAndValue.count >= 2) {
                                [date setObject:parameterKeyAndValue[1] forKey:parameterKeyAndValue[0]];
                            }
                        }
                        controller.fromDate = date[@"startDate"];
                        controller.toDate = date[@"endDate"];
                    }
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                //(MWF)
                /*帮检预约单*///
                if ([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"catcherCar"]) {
                    [self helpOrder:[arrFucnameAndParameter objectAtIndex:2]];
                }
                
                //(MWF)
                /*延长保修返现管理列表*///
                if ([[arrFucnameAndParameter objectAtIndex:1] hasPrefix:@"backList"]) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YHExtrendBackListController *controller = [board instantiateViewControllerWithIdentifier:@"YHExtrendBackListController"];
                    NSArray *parameters = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@"&"];
                    if (parameters.count >= 3) {
                        NSMutableDictionary *date = [@{}mutableCopy];
                        for (NSInteger i = 1; parameters.count > i; i++) {
                            NSString *parameter = parameters[i];
                            NSArray *parameterKeyAndValue = [parameter componentsSeparatedByString:@"="];
                            if (parameterKeyAndValue.count >= 2) {
                                [date setObject:parameterKeyAndValue[1] forKey:parameterKeyAndValue[0]];
                            }
                        }
                        controller.fromDate = date[@"startDate"];
                        controller.toDate = date[@"endDate"];
                    }
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
                //(MWF)
                /*站点技术服务商数据*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"reservationService"]) {
                    //objc://doFunc/reservationService／站点技术服务商数据（JSON格式化的字符串）
                    if (arrFucnameAndParameter.count >= 3) {
                        NSString *json = [self URLDecodedString:arrFucnameAndParameter[2]];
                        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:NULL];
                        NSLog(@"===站点技术服务商数据:%@===",dic);
                        YHHelpCheckMapController *controller = [[YHHelpCheckMapController alloc]init];
                        controller.siteModel = [YHSiteModel mj_objectWithKeyValues:dic];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }
                
                //解决方案、我的订单
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"solution"]) {
                    //objc://doFunc/solution/1
                    if (arrFucnameAndParameter.count >= 3) {
                        YHSolutionListViewController *VC = [[UIStoryboard storyboardWithName:@"YHStoreBooking" bundle:nil] instantiateViewControllerWithIdentifier:@"YHSolutionListViewController"];
                        self.navigationController.navigationBarHidden = NO;
                        //解决方案
                        if ([arrFucnameAndParameter[2] isEqualToString:@"bill_list_W001"]) {
                            VC.isSolution = YES;
                            //我的订单
                        } else if ([arrFucnameAndParameter[2] isEqualToString:@"solution_booking"]) {
                            VC.isSolution = NO;
                        }
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                }
                
                //(MWF)
                //解决方案
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"solutionBillList"]) {
                    //objc://doFunc/solution/1
                    if (arrFucnameAndParameter.count >= 3) {
                        YHSolutionListViewController *VC = [[UIStoryboard storyboardWithName:@"YHStoreBooking" bundle:nil] instantiateViewControllerWithIdentifier:@"YHSolutionListViewController"];
                        self.navigationController.navigationBarHidden = NO;
                        VC.isSolution = YES;
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                }
                
                //(MWF)
                /*分享*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"share"]) {
                    //objc://doFunc/share/https://d.wps.cn/v/8qHkd
                    //objc://doFunc/share/分享地址,分享title,分享副标题,分享图片地址
                    
                    //测试专用
                    //NSString *testStr = @"//objc://doFunc/share/https://d.wps.cn/v/8qHkd,分享title,分享副标题,https://mobile.umeng.com/images/pic/home/social/img-1.png";
                    //NSArray *shareArray0 = [testStr componentsSeparatedByString:@"share/"];
                    
                    NSArray *shareArray0 = [urlString componentsSeparatedByString:@"share/"];
                    if (shareArray0.count >= 2) {
                        NSString *shareString0 = shareArray0[1];
                        NSArray *shareArray1 = [shareString0 componentsSeparatedByString:@","];
                        if (shareArray1.count == 1) {
                            self.address = shareArray1[0];
                            self.titles = @"";
                            self.describe = @"";
                            self.imageUrl = @"";
                        } else if (shareArray1.count == 2) {
                            self.address = shareArray1[0];
                            self.titles = [YHTools decodeString:shareArray1[1]];
                            self.describe = @"";
                            self.imageUrl = @"";
                        } else if (shareArray1.count == 3) {
                            self.address = shareArray1[0];
                            self.titles = [YHTools decodeString:shareArray1[1]];
                            self.describe = [YHTools decodeString:shareArray1[2]];
                            self.imageUrl = @"";
                        } else if (shareArray1.count == 4) {
                            self.address = shareArray1[0];
                            self.titles = [YHTools decodeString:shareArray1[1]];
                            self.describe = [YHTools decodeString:shareArray1[2]];
                            self.imageUrl = shareArray1[3];
                        }
                    }
                    
                    //[UMSocialUIManager addCustomPlatformWithoutFilted:1500 withPlatformIcon:[UIImage imageNamed:@"weixin"] withPlatformName:@"短信"];
                    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        
                        [self shareWebPageToPlatformType:platformType];
                    }];
                }
            }
        }
        return NO;
    }
    return YES;
}

//URLDEcode
-(NSString *)decodeString:(NSString*)encodedString
{
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (NSString *)decoderUrlEncodeStr: (NSString *)input{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}

- (void)helpOrder:(NSString*)vin
{
    
    [[YHCarPhotoService new] checkRestrictForVin:vin
                                         Success:^(NSDictionary *obj) {
        
        YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:[obj valueForKey:@"baseInfo"]];
        
        YHDiagnosisBaseVC *baseVC = [[YHDiagnosisBaseVC alloc] init];
        baseVC.vinController = self;
        baseVC.isHelp = YES;
        if ([model.carModelFullName isEqualToString:@"其它"]) {//判断这个字段是否为其它  或者判断是否为数组最后一个
            baseVC.isOther = 1;
        }else{
            baseVC.checkCustomerModel = model;
        }
        baseVC.carType = 1;   //vin号识别不出来传1
        baseVC.vinStr = vin;
        NSString *amount = [obj valueForKey:@"amount"];
        if (amount) {
            baseVC.amount = amount;
        }
        
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }
                                         failure:^(NSError *error) {
        
    }];
    //    [[YHCarPhotoService new] checkCustomerForVin:vin Success:^(NSDictionary *obj) {
    //        YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:obj];
    //        YHDiagnosisBaseVC *baseVC = [[YHDiagnosisBaseVC alloc]init];
    //        baseVC.isHelp = YES;
    //        if ([model.carModelFullName isEqualToString:@"其它"]) {//判断这个字段是否为其它  或者判断是否为数组最后一个
    //            baseVC.isOther = 1;
    //        }else{
    //            baseVC.checkCustomerModel = model;
    //        }
    //        baseVC.carType = 1;   //vin号识别不出来传1
    //        baseVC.vinStr = vin;
    //        [self.navigationController pushViewController:baseVC animated:YES];
    //    } failure:^(NSError *error) {
    //    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    
    //1.创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //2.创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titles descr:self.describe thumImage:self.imageUrl];
    
    NSLog(@"------%@======",self.address);
    //3.设置网页地址
    shareObject.webpageUrl = self.address;
    
    //4.分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //5.调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD showSuccess:@"分享失败" toView:self.view];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                UMSocialShareResponse *resp = data;
                
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (IBAction)showVinAction:(id)sender {
    [self pushVin:@"34587678932456723895"];
}

//开始定位
-(void)getLocationInformation{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //定位不能用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIAlertController showAlertInViewController:self withTitle:@"打开“定位服务”来允许“JNS”确定你的位置" message:@"JNS需要使用您的位置来为你提供服务" cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@[@"设置"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.cancelButtonIndex) return;
                
                NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                
                if( [[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
        });
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    //self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //定位失败，作相应处理。
    [self pushLocationLongitude:@"" latitude:@"" state:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.firstObject;
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    [manager stopUpdatingLocation];
    
    [self pushLocationLongitude:[NSString stringWithFormat:@"%f",oldCoordinate.longitude] latitude:[NSString stringWithFormat:@"%f",oldCoordinate.latitude] state:YES];
}

- (void)ai:(NSString *)json{
    json = [self decoderUrlEncodeStr:json];
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
    NSInteger step_type = [[obj valueForKey:@"step_type"] integerValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[YHCarPhotoService new] getAirConditionerItemDataOrderId:[obj valueForKey:@"order_id"] success:^(NSMutableArray<TTZSYSModel *> *models ,NSDictionary *baseInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        //1表示 已完成问询 ，2表示已完成初检 3表示已完成推送
        if (step_type == 1) {
            TTZCheckViewController *vc = [TTZCheckViewController new];
            vc.sysModels = models;
            vc.title = @"AI空调检测";
            vc.billType = @"AirConditioner";
            vc.billId = (NSString *)[obj valueForKey:@"order_id"];
            vc.carBrand = [baseInfo valueForKey:@"car_brand_name"];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (step_type == 2){
            [self getIntelligentReport:[obj valueForKey:@"order_id"]];
            return ;
            NSMutableArray *controllers =  self.navigationController.viewControllers.mutableCopy;
#warning 零时调试
            //[controllers addObject:vc];
            YHIntelligentDiagnoseController *inteVc = [YHIntelligentDiagnoseController new];
            inteVc.order_id = [obj valueForKey:@"order_id"];
            
            [controllers addObject:inteVc];
            [self.navigationController setViewControllers:controllers];
            
        }else if (step_type == 3){
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:error.userInfo[@"message"]];
    }];
}

- (void)getReportByBillIdV2:(NSString *)billId{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getReportByBillIdV2:[YHTools getAccessToken] billId:billId onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            
            //            "order_info": {
            //                "pay_price": "58.88", // 支付费用
            //                "pay_status": 1 // 是否支付：1支付，0未支付
            //            },
            NSDictionary *order_info = info[@"data"][@"order_info"];
            BOOL pay_status = YES;//[order_info[@"pay_status"] boolValue];
            if (!pay_status) { // 未支付
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = @"J009";
                vc.billId = billId;
                vc.title = @"AI空调检测";
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                vc.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                [vc.noPayView.immediatelyPayBtn setTitle:@"马上购买" forState:UIControlStateNormal];
                return ;
            }
            //"reportStatus":"1", // 报告生成状态 0：未生成，1：已生成
            BOOL reportStatus =  [info[@"data"][@"report_status"] boolValue];
            //            reportStatus = NO;
            if (!reportStatus) {
                
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = @"J009";
                vc.billId = billId;
                vc.isNo = YES;
                vc.title = @"AI空调检测";
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                return;
            }
            
            YHReportModel *reportModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
            vc.billType = @"J009";
            vc.billId = billId;
            vc.title = @"AI空调检测";
            vc.diagnoseModel = reportModel;
            [self.navigationController pushViewController:vc animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            return;
            
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:error.userInfo[@"message"]];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}


- (void)getIntelligentReport:(NSString *)order_id{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getIntelligentCheckReport:[YHTools getAccessToken] order_id:order_id onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            
            //            "order_info": {
            //                "pay_price": "58.88", // 支付费用
            //                "pay_status": 1 // 是否支付：1支付，0未支付
            //            },
            NSDictionary *order_info = info[@"data"][@"order_info"];
            BOOL pay_status = [order_info[@"pay_status"] boolValue];
            if (!pay_status) { // 未支付
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = @"AirConditioner";
                vc.billId = order_id;
                vc.title = @"AI空调检测";
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                vc.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                [vc.noPayView.immediatelyPayBtn setTitle:@"马上购买" forState:UIControlStateNormal];
                return ;
            }
            //"reportStatus":"1", // 报告生成状态 0：未生成，1：已生成
            BOOL reportStatus =  [info[@"data"][@"reportStatus"] boolValue];
            //reportStatus = YES;
            if (!reportStatus) {
                
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = @"AirConditioner";
                vc.billId = order_id;
                vc.isNo = YES;
                vc.title = @"AI空调检测";
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                return;
            }
            
            YHReportModel *reportModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
            vc.billType = @"AirConditioner";
            vc.billId = order_id;
            vc.title = @"AI空调检测";
            vc.diagnoseModel = reportModel;
            [self.navigationController pushViewController:vc animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            return;
            
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:error.userInfo[@"message"]];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)getAirCondition:(NSString *)carBrand{
    
    carBrand = [self decoderUrlEncodeStr:carBrand];
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[carBrand dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] helperAirConditionSuccess:^(NSMutableArray<TTZSYSModel *> *models) {
        NSLog(@"%s", __func__);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TTZCheckViewController *vc = [TTZCheckViewController new];
        vc.sysModels = models;
        vc.title = @"空调诊断";
        vc.carBrand = obj[@"carBrandName"];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:error.userInfo[@"message"]];
    }];
}


- (void)stuSportInfo:(NSString *)par{
    par = [self decoderUrlEncodeStr:par];
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[par dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
    
    NSString *accessToken = [obj valueForKey:@"accessToken"];
    NSString *Id = [obj valueForKey:@"id"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    YTRecordConViewtroller *vc = [YTRecordConViewtroller new];
    vc.accessToken = accessToken;
    vc.Id = [NSString stringWithFormat:@"%@",Id];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)stuToSport:(NSString *)par{
    par = [self decoderUrlEncodeStr:par];
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[par dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
    
    NSString *accessToken = [obj valueForKey:@"accessToken"];
    
    YTRecordConViewtroller *vc = [YTRecordConViewtroller new];
    vc.accessToken = accessToken;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)gotoMap:(NSString *)address{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        // 高德地图
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&t=0",@"我的位置",address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]){
        // 苹果地图
        NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@",address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }
}


- (void)h5ToApp:(NSString *)json{
    json = [self decoderUrlEncodeStr:json];
    
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
    //    {
    //        "jnsAppStatus": "android/ios",
    //        "jnsAppStep": "payOrder",
    //        "bill_id": "xxxx",
    //        "bill_type": "J004",
    //    }
    NSString *jnsAppStep = [obj valueForKey:@"jnsAppStep"];
    
    if ([jnsAppStep isEqualToString:@"jumpUndisposedList"]) {
        
            __weak __typeof__(self) weakSelf = self;
            __block BOOL isBack = NO;
        
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[YHOrderListController class]]) {
                    
                    [[NSNotificationCenter
                      defaultCenter]postNotificationName:notificationOrderListChange
                     object:Nil
                     userInfo:nil];
                    [weakSelf.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                    isBack = YES;
                }
            }];
            if (!isBack) {
                
                NSMutableArray *controllers = self.navigationController.childViewControllers.mutableCopy;
                [controllers enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj isKindOfClass:[NewBillViewController class]]){
                        [controllers removeObject:self];
                        [controllers removeObject:obj];
                    }
                }];
                
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
                controller.functionKey = YHFunctionIdUnfinishedWorkOrder;
                [controllers addObject:controller];
                [self.navigationController setViewControllers:controllers];
                
            }
        
        return;
    }
    if([jnsAppStep isEqualToString:@"jumpScanVin"]){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
        NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
        controller.bill_type = [[obj valueForKey:@"bill_type"] stringByReplacingOccurrencesOfString:@"bill_type_" withString:@""];
        controller.car_brand_name = [obj valueForKey:@"car_brand_name"];
        //controller.bill_type = @"repair_dismantled";
        //controller.textType = YYNewVinVin;
        controller.vin = [obj valueForKey:@"vin"];
        controller.isOnlyVin = [[obj valueForKey:@"type"] isEqualToString:@"vin"];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    if([jnsAppStep isEqualToString:@"goMap"]){
        [self gotoMap:obj[@"title"]];
        return;
    }
    
    if([jnsAppStep isEqualToString:@"pushBillA"]){
        
        __block BOOL isContains = NO;
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:10];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [viewControllers addObject:obj];
            if([obj isKindOfClass:NSClassFromString(@"YHOrderListController")] ){//有详情页只去掉信息确认页
                [viewControllers addObject:self];
                isContains = YES;
                *stop = YES;
            }
        }];
        
        if (isContains) {
            self.navigationController.viewControllers = viewControllers;
            return ;
        }
        
        viewControllers = [NSMutableArray arrayWithCapacity:10];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [viewControllers addObject:obj];
            if([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")] && obj != self){
                [viewControllers addObject:self];
                *stop = YES;
            }
        }];
        
        
        [self.navigationController setViewControllers:viewControllers];
        return;
    }
    
    
    
    if([jnsAppStep isEqualToString:@"detail"]){
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:NSClassFromString(@"YTCounterController")]){
                *stop = YES;
                return;
            }
            [arr addObject:obj];
        }];
        
        
        [self.navigationController setViewControllers:arr];
        
    }
    
    if([jnsAppStep isEqualToString:@"cancellation"]){
        NSString *bill_type = [obj valueForKey:@"bill_type"];
        if ([bill_type isEqualToString:@"J005"]) {
            return;
        }
        NSDictionary *item = [obj valueForKey:@"item"];
        [self orderDetailNavi:item code:YHFunctionIdHistoryWorkOrder];
        return;
    }
    
    if([jnsAppStep isEqualToString:@"share"]){
        //    shareUrl:'xxxx',
        //    type:'J007',
        //    title:'xxxx',
        //    subtitle:'xxx',
        //    logo:'xx'
        
        NSString *bill_id = [obj valueForKey:@"bill_id"];
        NSString *bill_type = [obj valueForKey:@"bill_type"];
        BOOL sms = [[obj valueForKey:@"sms"] boolValue];
        
        
        self.address = [obj valueForKey:@"shareUrl"];
        self.titles = [obj valueForKey:@"title"];
        self.describe = [obj valueForKey:@"subtitle"];
        self.imageUrl = [obj valueForKey:@"logo"];
        NSString *strArr = [obj valueForKey:@"platforms"];
        NSArray *platformArr = [strArr componentsSeparatedByString:@","];
        
        NSMutableArray *platforms = [NSMutableArray arrayWithCapacity:10];
        
        if(!platformArr || [strArr isKindOfClass:[NSNull class]]){
            
            [platforms addObject:@(UMSocialPlatformType_WechatSession)];
            
            [platforms addObject:@(UMSocialPlatformType_WechatTimeLine)];
            
            [platforms addObject:@(UMSocialPlatformType_QQ)];
            
        }else{
            
            //显示分享平台 Sms 短信、 WechatSession 微信、 WechatTimeLine  微信朋友圈、  QQ QQ聊天、  Qzone  qq空间
            if([platformArr containsObject:@"WechatSession"]){
                [platforms addObject:@(UMSocialPlatformType_WechatSession)];
            }
            
            if([platformArr containsObject:@"WechatTimeLine"]){
                [platforms addObject:@(UMSocialPlatformType_WechatTimeLine)];
            }
            
            if([platformArr containsObject:@"QQ"]){
                [platforms addObject:@(UMSocialPlatformType_QQ)];
            }
            
            if([platformArr containsObject:@"Qzone"]){
                [platforms addObject:@(UMSocialPlatformType_Qzone)];
            }
            
        }
        
        if(sms || [platformArr containsObject:@"Sms"]) {
            [UMSocialUIManager addCustomPlatformWithoutFilted:1500 withPlatformIcon:[UIImage imageNamed:@"message"] withPlatformName:@"短信"];
            [platforms insertObject:@(1500) atIndex:0];
        };
        
        
        
        [UMSocialUIManager setPreDefinePlatforms:platforms];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            if(platformType == 1500){
                //支付页面
                YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                vc.billId = bill_id;//self.billId;
                vc.billType =  [bill_type isEqualToString:@"airConditioner"]? @"AirConditioner":bill_type;//self.billType;
                vc.buy_type = 4;
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                return;
            }
            [self shareWebPageToPlatformType:platformType];
        }];
        
        if(sms || [platformArr containsObject:@"Sms"]) [UMSocialUIManager removeCustomPlatformWithoutFilted:1500];
        
        
        return;
    }
    
    if ([jnsAppStep isEqualToString:@"storePushUsedCarCheckReport"]) {
        NSString *bill_id = [obj valueForKey:@"bill_id"];
        NSString *bill_type = [obj valueForKey:@"bill_type"];
        
        YHOrderDetailNewController *orderDetailVc = [[YHOrderDetailNewController alloc] init];
        orderDetailVc.orderDetailInfo = @{@"billType":bill_type,@"id":bill_id,@"billTypeName":@"二手车检测"};
        orderDetailVc.isCheckComplete = NO;
        //                                                                        orderDetailVc.functionKey = functionKey;
        //                                                                        NSString *billStatus = orderInfo[@"billStatus"];
        //                                                                        if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
        //                                                                            orderDetailVc.functionKey = YHFunctionIdHistoryWorkOrder;
        //                                                                        }
        [self.navigationController pushViewController:orderDetailVc animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        return;
    }
    
    if (
        [jnsAppStep isEqualToString:@"usedCarInitialSurvey"]
        || (([[obj valueForKey:@"bill_type"] isEqualToString:@"J006"] || [obj[@"bill_type"] isEqualToString:@"J008"] || [obj[@"bill_type"] isEqualToString:@"J009"]) && [jnsAppStep isEqualToString:@"newWholeCarInitialSurvey"])
        ) {
        NSString *bill_id = [obj valueForKey:@"bill_id"];
        NSString *bill_type = [obj valueForKey:@"bill_type"];
        
        //        {
        //            "bill_id" = 18164;
        //            "bill_type" = E002;
        //            jnsAppStatus = ios;
        //            jnsAppStep = usedCarInitialSurvey;
        //        }
        if([bill_type isEqualToString:@"E002"] || [bill_type isEqualToString:@"E003"] || [bill_type isEqualToString:@"J006"] || [bill_type isEqualToString:@"J002"] || [bill_type isEqualToString:@"J003"] || [bill_type isEqualToString:@"J008"] || [bill_type isEqualToString:@"J009"]){//
            [MBProgressHUD showMessage:@"" toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                                    billId:bill_id
                                                                 isHistory:NO
                                                                onComplete:^(NSDictionary *info) {
                [MBProgressHUD hideHUDForView:self.view];
                if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                    BOOL detectionPay = [info[@"data"][@"detectionPay"] boolValue];
                    //"detectionPay": "0", // 检测服务费支付装：0-未付款 1-已付款
                    if (!detectionPay) { // 去支付
                        
                        YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                        vc.billId = bill_id;
                        vc.billType = bill_type;
                        vc.buy_type = 3;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        [self.navigationController setNavigationBarHidden:NO animated:NO];
                        return;
                    }
                    
                    if([bill_type isEqualToString:@"J009"]){
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        [[YHCarPhotoService new] getJ005ItemBillId:bill_id success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *baseInfo) {
                            models.firstObject.className = @"空调检测";
                            models.firstObject.list.firstObject.projectName = @"空调检测";
                            [MBProgressHUD hideHUDForView:self.view];
                            TTZCheckViewController *vc = [TTZCheckViewController new];
                            vc.sysModels = models;
                            vc.title = @"AI空调检测";
                            vc.billType = @"J009";
                            vc.billId = bill_id;
                            vc.carBrand = [baseInfo valueForKey:@"car_brand_name"];
                            [self.navigationController setNavigationBarHidden:NO animated:YES];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        } failure:^(NSError *error) {
                            [MBProgressHUD hideHUDForView:self.view];
                        }];
                        return;
                    }
                    
                    NSDictionary *billTypeNameDic = @{
                        @"E003" : @"二手车估值",
                        @"E002" : @"二手车检测",
                        @"J006": @"汽车安检",
                        @"J002": @"小虎安检",
                        @"J003": @"专项检测",
                        @"J008": @"全车安检",
                        @"J009": @"AI空调检测",
                        @"J009": @"AI空调检测"
                    };
                    NSString *billTypeName = billTypeNameDic[bill_type];//[bill_type isEqualToString:@"E003"]? @"二手车估值" : @"二手车检测";
                    
                    YHOrderDetailNewController *orderDetailVc = [[YHOrderDetailNewController alloc] init];
                    orderDetailVc.orderDetailInfo = @{@"billType":bill_type,@"id":bill_id,@"billTypeName":billTypeName};
                    orderDetailVc.isCheckComplete = NO;
                    //                                                                        orderDetailVc.functionKey = functionKey;
                    //                                                                        NSString *billStatus = orderInfo[@"billStatus"];
                    //                                                                        if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
                    //                                                                            orderDetailVc.functionKey = YHFunctionIdHistoryWorkOrder;
                    //                                                                        }
                    [self.navigationController setNavigationBarHidden:NO animated:NO];
                    [self.navigationController pushViewController:orderDetailVc animated:YES];
                    return;
                }
            } onError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
            }];
            return;
        }
        
        
        return;
    }
    
    if ([jnsAppStep isEqualToString:@"payOrder"] ) {//确认信息页面
        
        NSString *bill_id = [obj valueForKey:@"bill_id"];
        NSString *bill_type = [obj valueForKey:@"bill_type"];
        BOOL isReloadH5 = [[obj valueForKey:@"isReloadH5"] boolValue];
        NSString *vin = [obj valueForKey:@"vin"];
        NSString *code = [obj valueForKey:@"code"];

        YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
        vc.billId = bill_id;
        vc.billType = bill_type;
        vc.isReloadH5 = isReloadH5;
        vc.vin = vin;
        vc.code = code;

        //        vc.buy_type = 2;
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //    {
    //        "jnsAppStatus": "android/ios",
    //        "jnsAppStep": "depthDiagnosis",
    //        "bill_id": "xxxxx",
    //        "bill_type": "J005"
    //    }
    if ([jnsAppStep isEqualToString:@"newWholeCarInitialSurvey"] ) {//

        NSDictionary *item = [obj valueForKey:@"item"];
        if (item && [item isKindOfClass:[NSDictionary class]]) {
            NSString *homeToCheck = [item valueForKey:@"homeToCheck"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.h5Source = homeToCheck;
        }
        
        if([obj[@"bill_type"] isEqualToString:@"J006"] || [obj[@"bill_type"] isEqualToString:@"J007"] || [obj[@"bill_type"] isEqualToString:@"J008"]){
            
//<<<<<<< HEAD
//            NSDictionary *item = [obj valueForKey:@"item"];
//            NSString *homeToCheck = [item valueForKey:@"homeToCheck"];
//            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            app.h5Source = homeToCheck;

//=======
//>>>>>>> d92dc1b75a2c10dc502ae7818e3eacb06b512cd0
            YHOrderDetailNewController *orderDetailVc = [[YHOrderDetailNewController alloc] init];
            orderDetailVc.orderDetailInfo = @{@"menuCode" : @"", @"billTypeNew" : @"",  @"billType":[obj valueForKey:@"bill_type"],@"id":[obj valueForKey:@"bill_id"],@"billTypeName":[obj[@"bill_type"] isEqualToString:@"J006"] ? @"汽车安检" : [obj[@"bill_type"] isEqualToString:@"J008"] ? @"全车安检" : @"排气污染物监测"};
            orderDetailVc.isCheckComplete = NO;
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self.navigationController pushViewController:orderDetailVc animated:YES];
            return;
            
        }else{
            
            NSString *bill_id = [obj valueForKey:@"bill_id"];
            NSString *bill_type = [obj valueForKey:@"bill_type"];
            //FIXME:  -  test
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            [[YHCarPhotoService new] getJ005ItemBillId:bill_id success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *baseInfo) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //FIXME:  -  test
                //            TTZSYSModel *s = models.firstObject;
                //            TTZGroundModel *g = s.list.firstObject;
                //            TTZSurveyModel *c = g.list[1];
                //            c.intervalType = @"independent";
                
                
                TTZCheckViewController *vc = [TTZCheckViewController new];
                if ([bill_type isEqualToString:@"J007"]) {
                    models.firstObject.className = @"AI尾气诊断";
                    models.firstObject.list.firstObject.projectName = @"AI尾气诊断";
                }
                
                //vc.is_circuitry = YES;
                vc.sysModels = models;
                vc.title = [bill_type isEqualToString:@"J007"] ?  @"AI尾气诊断" : @"深度诊断";
                vc.billId = bill_id;
                vc.billType = bill_type;
                //vc.currentIndex = 0;
                
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [self.navigationController pushViewController:vc animated:YES];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                
            }];
            return;
        }
    }
    
    if ([jnsAppStep isEqualToString:@"storePushNewWholeCarReport"]) {
        
        NSString *bill_id = [obj valueForKey:@"bill_id"];
        NSString *bill_type = [obj valueForKey:@"bill_type"];
        NSDictionary *item = [obj valueForKey:@"item"];
        NSString *menuCode = [item valueForKey:@"menuCode"];
        NSString *billTypeNew = [item valueForKey:@"billType_check"];
        
        if (item && [item isKindOfClass:[NSDictionary class]]) {
            NSString *homeToCheck = [item valueForKey:@"homeToCheck"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.h5Source = homeToCheck;
        }
        
        if ([bill_type isEqualToString:@"J009"]) {
            [self getReportByBillIdV2:bill_id];
            return;
        }
        
        if([bill_type isEqualToString:@"J006"] || [bill_type isEqualToString:@"J008"]){
            
            YHOrderDetailNewController *orderDetailVc = [[YHOrderDetailNewController alloc] init];
            orderDetailVc.orderDetailInfo = @{@"billType":bill_type,@"id":bill_id,@"billTypeName":[bill_type isEqualToString:@"J006"] ? @"汽车安检" : @"全车安检"};
            orderDetailVc.isCheckComplete = NO;
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self.navigationController pushViewController:orderDetailVc animated:YES];
            return;
            
        }
        
        [self depthDiagnose:bill_id billType:bill_type menuCode:menuCode billTypeNew:billTypeNew with:NO];
        return;
    }
}


- (void)depthDiagnose:(NSString *)bill_id

             billType:(NSString *)billType

             menuCode:(NSString *)menuCode

          billTypeNew:(NSString *)billTypeNew
                 with:(BOOL)isAI{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    bill_id = @"17209";
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getDepthDiagnoseWithToken:[YHTools getAccessToken]
                                                                        billId:bill_id
                                                                    onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            NSDictionary *data = info[@"data"];
            
            //                                                                            BOOL pay_status = [data[@"diagnose_pay"] boolValue];
            //                                                                            if ([billType isEqualToString:@"J005"] && !pay_status) { // 未支付
            //                                                                                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
            //                                                                                vc.billType = @"J005";
            //                                                                                vc.billId = bill_id;
            //                                                                                vc.title = @"深度诊断";
            //                                                                                [self.navigationController pushViewController:vc animated:YES];
            //                                                                                [self.navigationController setNavigationBarHidden:NO animated:NO];
            //                                                                                vc.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
            //                                                                                [vc.noPayView.immediatelyPayBtn setTitle:@"马上购买" forState:UIControlStateNormal];
            //                                                                                return ;
            //                                                                            }
            
            
            //"reportStatus":"1", // 报告生成状态 0：维修方式未生成，1：维修方式已生成
            //"reportEditStatus":"1", // 报告是否可编辑状态 0：不可编辑，1：可编辑
            //reportStatus 先判断这个状态 报告有没有出，没有就跑到你那个中间页，如果出了
            //再判断 reportEditStatus这个状态 如果为0 就跳支付页面
            
            BOOL reportStatus = [[data valueForKey:@"reportStatus"] boolValue];
            BOOL reportEditStatus = [[data valueForKey:@"reportEditStatus"] boolValue];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            
            if (!reportStatus) {
                //中间页
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = billType;
                vc.billId = bill_id;
                vc.isNo = isAI;
                vc.title = [billType isEqualToString:@"J007"] ?  @"AI尾气诊断" : @"深度诊断";
                [self.navigationController pushViewController:vc animated:YES];
                return;
                YTDepthController *depthVc = [[YTDepthController alloc] init];
                depthVc.reportModel = nil;
                [self.navigationController pushViewController:depthVc animated:YES];
                return;
            }
            
            BOOL pay_status = [data[@"diagnose_pay"] boolValue];
            if ([billType isEqualToString:@"J005"] && !pay_status) { // 未支付
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = @"J005";
                vc.billId = bill_id;
                vc.title = @"深度诊断";
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                vc.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                [vc.noPayView.immediatelyPayBtn setTitle:@"马上购买" forState:UIControlStateNormal];
                return ;
            }
            
            if (!reportEditStatus) {
                //支付页面
                YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                vc.billId = bill_id;
                vc.billType = billType;
                
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
            vc.billType = billType;
            vc.billId = bill_id;   vc.menuCode = menuCode;   vc.billIdNew = billTypeNew;
            vc.isNo = isAI;
            vc.title = [billType isEqualToString:@"J007"] ?  @"AI尾气诊断" : @"深度诊断";
            vc.diagnoseModel = [YHReportModel mj_objectWithKeyValues:data];
            [self.navigationController pushViewController:vc animated:YES];
            return;
            
            return;
            //配件耗材列表
            YTDepthController *depthVc = [[YTDepthController alloc] init];
            YHReportModel *reportModel = [YHReportModel mj_objectWithKeyValues:data];
            depthVc.order_id = bill_id;
            depthVc.orderType = billType;
            depthVc.reportModel = reportModel;
            YTBaseInfo *baseInfo = [YTBaseInfo mj_objectWithKeyValues:data[@"baseInfo"]];
            depthVc.baseInfo = baseInfo;
            [self.navigationController pushViewController:depthVc animated:YES];
            return ;
        }
        
    }
                                                                       onError:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
        
    }];
}
@end

