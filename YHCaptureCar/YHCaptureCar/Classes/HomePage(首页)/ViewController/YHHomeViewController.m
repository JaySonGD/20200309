//
//  YHHomeViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/1.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
// 首页

#import "YHHomeViewController.h"
#import "YHHomeFunctionCell.h"
#import "YHHomeHeaderCell.h"
#import "YHMapViewController.h"
#import "YHWebFuncViewController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "SVProgressHUD.h"
#import "SmartOCRCameraViewController.h"
//#import "YHMapViewController.h"
#import "YHDetectionCenterVC.h"
#import "YHHelpSellController.h"
#import "YHDiagnosisBaseVC.h"
#import "YHCarSourceController.h"
#import "YHHelpCheckViewController.h"

#import "UIViewController+RESideMenu.h"

#import "YHCommonTool.h"

#import "YHHelpBuyController.h"

#import "YHHelpSellService.h"

#import "YHRichesController.h"
#import "YHScanViewController.h"

NSString *const notificationFunction = @"YHNotificationFunction";
@interface YHHomeViewController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic)NSDictionary *serviceInfo;
@property(weak, nonatomic)YHHomeHeaderCell *headerCell;
@end

@implementation YHHomeViewController

- (void)viewDidLoad {
    self.isHideLeftButton = YES;
    self.title = EnvTitle;
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(functionAction:) name:notificationFunction object:nil];
//    if ( [YHTools getFunctions] == nil) {
        [YHTools setFunctions:@[[NSNumber numberWithInt:YHFunctionIdCheck],
                                [NSNumber numberWithInt:YHFunctionIdCaptureCar],
                                [NSNumber numberWithInt:YHFunctionIdSell],
                                [NSNumber numberWithInt:YHFunctionIdCustomerService],
                                [NSNumber numberWithInt:YHFunctionIdFinance],
                                [NSNumber numberWithInt:YHFunctionIdERP],
                                [NSNumber numberWithInt:YHFunctionIdHelper],
                                [NSNumber numberWithInt:YHFunctionIdTrain],
                                [NSNumber numberWithInt:YHFunctionIdWealth]]];
//    }
    [self reupdataDatasource];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 检测网络状态并默认弹框
    [YHCommonTool ShareCommonToolDefaultCurrentController:self];
    
}

- (IBAction)CarTureCar:(UIButton *)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil];
    [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"YHCaptureCarTabBarViewController"] animated:YES];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}



- (void)reupdataDatasource{
    __weak __typeof__(self) weakSelf = self;
    //    [SVProgressHUD showYH];
    //    [[YHNetworkPHPManager sharedYHNetworkPHPManager] myShopDetail:[YHTools getServiceCode] onComplete:^(NSDictionary *info) {
    //        //                [[YHNetworkPHPManager sharedYHNetworkPHPManager] getServiceDetail:@"a9b82def52a44bf35a0313fd823017f8" onComplete:^(NSDictionary *info) {
    //        weakSelf.serviceInfo = info[@"data"];
    //
    //        [_headerCell loadDatasource:_serviceInfo];
    //    } onError:^(NSError *error) {
    //        YHLog(@"getServiceDetail eroror");
    //    }];
    
    
    [YHHelpSellService advListOnComplete:^(NSDictionary *obj) {
        weakSelf.serviceInfo = obj;
        [weakSelf.headerCell loadDatasource:obj];
    } onError:^(NSError *error) {
        
    }];
    
}

- (void)functionAction:(NSNotification*)obj{
    
//    YHMapViewController *VC = [[YHMapViewController alloc]init];
//    VC.isNavi = YES;
//    [self.navigationController pushViewController:VC animated:YES];
//    SmartOCRCameraViewController *controller = [[SmartOCRCameraViewController alloc] init];
//    controller.isLocation = NO;
//    [self.navigationController pushViewController:controller animated:YES];
//    return;
    
    //    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkboardListController"];
    //    [self.navigationController pushViewController:controller animated:YES];
//        return;
    NSNumber *functionK = obj.object;
    if(functionK.integerValue == YHFunctionIdCaptureCar){ // 点击拍车
        
        [self.navigationController pushViewController:[YHHelpBuyController new] animated:YES];
        return;
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHCaptureCarTabBarViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    } else  if(functionK.integerValue == YHFunctionIdCustomerService ){ // 点击售后
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/index.html?token=%@&status=ios", [YHTools getAccessToken]];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(functionK.integerValue == YHFunctionIdTrain ){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/px/training.html?token=%@&status=ios", [YHTools getAccessToken]];
        controller.title = @"培训";
        controller.barHidden = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (functionK.integerValue == YHFunctionIdCheck){ // 点击帮检
        //跳转至检测模块
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"AMap" bundle:nil];
//        YHDetectionCenterVC *controller = [board instantiateViewControllerWithIdentifier:@"YHDetectionCenterVC"];
//        [self.navigationController pushViewController:controller animated:YES];
        
        YHHelpCheckViewController *controller = [[UIStoryboard storyboardWithName:@"YHHelpCheck" bundle:nil] instantiateViewControllerWithIdentifier:@"YHHelpCheckViewController"];
        [self.navigationController pushViewController:controller animated:YES];

    }else if (functionK.integerValue == YHFunctionIdSell){
        //跳转至帮卖模块
        YHHelpSellController *controller = [YHHelpSellController new];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (functionK.integerValue == YHFunctionIdERP){
        //跳转至车源管理模块
        YHCarSourceController *controller = [YHCarSourceController new];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(functionK.integerValue == YHFunctionIdFinance ){
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
//        controller.urlStr = @"https://d.wps.cn/v/8qvFK";
//        controller.title = @"金融";
//        controller.barHidden = NO;
//        [self.navigationController pushViewController:controller animated:YES];
        
        // 财富
        YHRichesController *richesVc = [[YHRichesController alloc] init];
        [self.navigationController pushViewController:richesVc animated:YES];
        
    }else if(functionK.integerValue == YHFunctionIdHelper ){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = @"https://d.wps.cn/v/8qvFm";
        controller.title = @"帮手";
        controller.barHidden = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(functionK.integerValue == YHFunctionIdWealth ){ // 财富
        YHScanViewController *controller = [[UIStoryboard storyboardWithName:@"YHScan" bundle:nil] instantiateViewControllerWithIdentifier:@"YHScanViewController"];
        controller.title = @"扫一扫";
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self notImplementedViewController:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSArray *functions = [YHTools getFunctions];
    NSUInteger acount = functions.count;
    return acount / 3 + ((acount % 3)? (1) : (0)) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YHHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellHeader" forIndexPath:indexPath];
        self.headerCell = cell;
        [cell loadDatasource:_serviceInfo];
        return cell;
    }else if(indexPath.row >= 1){
        YHHomeFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMenu" forIndexPath:indexPath];
        NSArray *functions = [YHTools getFunctions];
        NSUInteger acount = functions.count;
        NSMutableArray *cellAr = [@[]mutableCopy];
        if ((acount / 3)  >= indexPath.row) {
            [cellAr addObject:functions[(indexPath.row - 1) * 3 +0 ]];
            [cellAr addObject:functions[(indexPath.row - 1) * 3 +1 ]];
            [cellAr addObject:functions[(indexPath.row - 1) * 3 +2 ]];
        }else{
            for (int i = 0 ; i < acount % 3; i++) {
                [cellAr addObject:functions[(indexPath.row - 1) * 3 +i ]];
            }
        }
        [cell loadDatasource:cellAr];
        return cell;
    }
    return nil;
}
//test

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        float h = screenWidth * 425 / 750;
        return h;
    }
    return screenWidth / 3 + 1;
}

@end
