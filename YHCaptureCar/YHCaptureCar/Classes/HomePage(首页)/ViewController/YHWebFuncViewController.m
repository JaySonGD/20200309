//
//  YHWebFuncViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/7.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHWebFuncViewController.h"
#import "YHCommon.h"
#import "YHLoginViewController.h"
#import "SmartOCRCameraViewController.h"

#import "YHTools.h"
#import "YHNetworkManager.h"

#import "YHReportDetailModel.h"
#import <MJExtension.h>
#import "YHPayServiceFeeView.h"

#import "WXPay.h"
#import "YHHelpSellService.h"

NSString *const notificationOrderListChange = @"YHNotificationOrderListChange";
@interface YHWebFuncViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testBackB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarHeight;

//付费视图
@property (weak, nonatomic) IBOutlet UIView *payView;

//查看报告视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewHeight;


@property (nonatomic, strong) UIView *functionView;

@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;

@end

@implementation YHWebFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#ifndef YHProduction
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _testBackB.hidden = NO;
#else
    _testBackB.hidden = YES;
#endif
    self.statusBarHeight.constant = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    [self initUI];
}

#pragma mark - -------------------------------------初始化UI------------------------------------------
- (void)initUI{
    //报告列表
    if (self.isPushByReportList == YES) {
        //0-待支付
        if ([self.rdModel.payStatus isEqualToString:@"0"])
        {
            self.payViewHeight.constant = 70;
            self.payView.hidden = NO;
        }
        //1-支付完成
        else if ([self.rdModel.payStatus isEqualToString:@"1"])
        {
            self.payViewHeight.constant = 0;
            self.payView.hidden = YES;
        }
    //非报告列表
    }else{
        self.payViewHeight.constant = 0;
        self.payView.hidden = YES;
    }
}

#pragma mark - ------------------------------------点击事件--------------------------------------------
#pragma mark - 1.vin码
- (IBAction)showVinAction:(id)sender {
    [self pushVin:@"34587678932456723895"];
}

#pragma mark - 2.付费查看完整报告
- (IBAction)pay:(UIButton *)sender {
    [self showPayFreeView];
}

- (void)showPayFreeView{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.payServiceFeeView) {
        self.payServiceFeeView = [[NSBundle mainBundle]loadNibNamed:@"YHPayServiceFeeView" owner:self options:nil][0];
        self.payServiceFeeView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.payServiceFeeView.payRemindLabel.text = @"报告费";
        self.payServiceFeeView.moneyLabel.text = [NSString stringWithFormat:@"%@元",self.rdModel.payAmt];
        [self.functionView addSubview:self.payServiceFeeView];
    }
    
    self.payServiceFeeView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://微信支付
                [weakSelf WxPay];
                break;
            case 3://支付宝支付
                [MBProgressHUD showError:@"后期开通,敬请期待"];
                break;
            default:
                break;
        }
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([YHTools isReportJump]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
#pragma mark - 支付报告费
- (void)WxPay{
    WeakSelf;
    [MBProgressHUD showMessage:nil toView:self.view];
    
    //1.支付报告费
    [[YHNetworkManager sharedYHNetworkManager]payReportFeeWithToken:[YHTools getAccessToken]
                                                         reportCode:self.rlModel.reportCode
                                                           billType:self.rlModel.billType
                                                         billNumber:self.rlModel.billNumber
                                                       creationTime:self.rlModel.creationTime
                                                         onComplete:^(NSDictionary *info)
     {
         //NSLog(@"<<<<----------->>>>1.支付报告费：%@<<<<--->>>>%@<<<<-->>>%@<<<----------->>>>",info,info[@"retMsg"],info[@"result"][@"orderId"]);
         
         if ([info[@"retCode"] isEqualToString:@"0"]) {
             
             //2.发起微信支付
             [[WXPay sharedWXPay] payWithDict:info success:^{
                 
                 //3.支付结果回调
                 [[YHNetworkManager sharedYHNetworkManager]payCallBackWithToken:[YHTools getAccessToken]
                                                                        orderId:info[@"result"][@"orderId"]
                                                                     onComplete:^(NSDictionary *info)
                  {
                      NSLog(@"<<<<----------->>>>3.支付结果回调：%@<<<<--->>>>%@<<<<----------->>>>",info,info[@"retMsg"]);
                      
                      if ([info[@"result"][@"payStatus"] isEqualToString:@"1"]) {
                          [MBProgressHUD showSuccess:@"支付成功"];
                          
                          //1.隐藏底部支付视图
                          weakSelf.payViewHeight.constant = 0;
                          weakSelf.payView.hidden = YES;
                          
                          //2.重新加载报告
                          [weakSelf popReportListWithPayStatus:info[@"result"][@"payStatus"] signUrl:info[@"result"][@"url"]];
                      }else{
                          [MBProgressHUD showError:@"支付失败"];
                      }
                      [weakSelf.functionView removeFromSuperview];
                      [MBProgressHUD hideHUDForView:weakSelf.view];
                  } onError:^(NSError *error) {
                      [MBProgressHUD hideHUDForView:weakSelf.view];
                      [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
                  }];
                 
             } failure:^{
                 [MBProgressHUD hideHUDForView:weakSelf.view];
             }];
         }else{
             
         }
     } onError:^(NSError *error) {
         
     }];
}

- (void)popReportListWithPayStatus:(NSString *)payStatus signUrl:(NSString *)url{
    //二手车
    if ([self.rlModel.billType isEqualToString:@"S"]) {
        //0-待支付、2支付失败
        if ([payStatus isEqualToString:@"0"] || [payStatus isEqualToString:@"2"]) {
            self.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/secondCar.html?code=%@", self.rlModel.reportCode];
            NSLog(@"------------------------5.报告链接:%@------------------------",self.urlStr);
        //1-支付完成
        } else if ([payStatus isEqualToString:@"1"]) {
            self.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/secondCar.html?code=%@&%@", self.rlModel.reportCode,url];
            NSLog(@"------------------------6.报告链接:%@------------------------",self.urlStr);
        }
    //安检
    }else if ([self.rlModel.billType isEqualToString:@"J002"]){
        //0-待支付、2支付失败
        if ([payStatus isEqualToString:@"0"] || [payStatus isEqualToString:@"2"]) {
            self.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/carReport.html?code=%@", self.rlModel.reportCode];
            NSLog(@"------------------------7.报告链接:%@------------------------",self.urlStr);
        //1-支付完成
        } else if ([payStatus isEqualToString:@"1"]) {
            self.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/carReport.html?code=%@&%@", self.rlModel.reportCode,url];
            NSLog(@"------------------------8.报告链接:%@------------------------",self.urlStr);
        }
    }
    
    NSMutableArray *vcArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if ([vcArray.lastObject isKindOfClass:[YHWebFuncViewController class]]) {
        [vcArray removeObject:vcArray.lastObject ];
    }

    YHWebFuncViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    VC.barHidden = NO;
    VC.title = self.rlModel.billTypeName;
    VC.urlStr = self.urlStr;
    [vcArray addObject:VC];
    [self.navigationController setViewControllers:vcArray animated:NO];
    
    //[self loadWebPageWithString:self.urlStr];
}

// Objective-C语言
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc"])
            {
                
                /*调用本地函数1*/
                NSLog(@"doFunc");
                
            }
        }
        else if(2 <= [arrFucnameAndParameter count])
        {
            //h5ToApp
            if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"h5ToApp"]) {
                
                //
                NSString *json = (arrFucnameAndParameter.count>2)? [arrFucnameAndParameter objectAtIndex:2] : @"";
                
                [self h5ToApp:json];
            }

            //有参数的
            if([funcStr isEqualToString:@"doFunc"] &&
               [arrFucnameAndParameter objectAtIndex:1])
            {
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"back"]) {
                    [[NSNotificationCenter
                      defaultCenter]postNotificationName:notificationOrderListChange
                     object:Nil
                     userInfo:nil];
                    [self popViewController:nil];
                }
                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"relogin"]) {
                    
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YHLoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"home"]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                /*调用本地函数1*///
                // H5控制是否显示或者隐藏导航 @"0"显示导航 @"1"不显示导航  @"" 未知，以代码控制
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"showNavi"]) {//显示导航和 title
                    if (arrFucnameAndParameter.count >= 3) {
                        NSString *showNaviBarState = arrFucnameAndParameter[2];
                        if (![showNaviBarState isEqualToString:@""]){
                            self.barHidden = showNaviBarState.boolValue;
                            [self.navigationController setNavigationBarHidden:showNaviBarState.boolValue animated:NO];
                            if (arrFucnameAndParameter.count >= 4) {
                                self.title = arrFucnameAndParameter[3];
                            }
                        }
                    }
                }
                
                /*拨打电话*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"callphone"]) {
                    NSString *phone = [arrFucnameAndParameter objectAtIndex:2];
                    NSString *allString = [NSString stringWithFormat:@"tel:%@", phone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                }
                
                /*调用本地函数1*///
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"vin"]) {
                    
                    SmartOCRCameraViewController *controller = [[SmartOCRCameraViewController alloc] init];
                    // 设置竖屏扫描
                    controller.recogOrientation = RecogInVerticalScreen;
                    
                    //                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    //                    YHVinScanningController *controller = [board instantiateViewControllerWithIdentifier:@"YHVinScanningController"];
                    controller.webController = self;
                    controller.isLocation = NO;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
            }
        }
        return NO;
    }
    return YES;
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
    
//    {
//        "jnsAppStatus": "android",
//        "jnsAppStep": "payReport",
//        "bill_id": "9527",
//    }
    
    if ([jnsAppStep isEqualToString:@"payReport"]) {
        
        NSString *workOrderId = [obj valueForKey:@"bill_id"];
        [MBProgressHUD showMessage:nil toView:self.view];
        [YHHelpSellService toHelpBuyCarPayWithId:workOrderId payType:2 onComplete:^(NSDictionary *h5Par, NSDictionary *wxPar) {
            
            [MBProgressHUD hideHUDForView:self.view];

            if (wxPar) {
                [[WXPay sharedWXPay] payWithDict:wxPar success:^{
                    //支付结果回调
                    [self.webView reload];
                    [MBProgressHUD showError:@"支付成功！"];
                } failure:^{
                }];
                return ;
            }
            
            [MBProgressHUD showError:@"该报告已支付"];
            
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
        }];
    }
    
}

- (NSString *)decoderUrlEncodeStr: (NSString *)input{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}


@end
