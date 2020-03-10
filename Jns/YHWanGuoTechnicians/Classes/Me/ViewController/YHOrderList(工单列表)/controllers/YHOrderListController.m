

//
//  YHOrderListController.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderListController.h"
#import "YHFunctionsEditerController.h"
#import "YHOrderCell.h"
#import "YHOrderDetailViewController.h"
#import "YHWebFuncViewController.h"
#import "YHNetworkPHPManager.h"
#import "UIAlertView+Block.h"
//#import "MBProgressHUD+MJ.h"
#import "YHCommon.h"
#import "YHTools.h"

#import "MJRefresh.h"
#import "YHOrderDetailController.h"
#import "YHVehicleController.h"
#import "YHAssignTechnicianController.h"
#import "YHInquiriesController.h"
#import "AppDelegate.h"
#import "YHDepthController.h"
#import "YHCommon.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YHHUPhotoBrowser.h"
#import "YHInitialInspectionController.h"
#import "YHDiagnosisProjectVC.h"
#import "YHBillStatusModel.h"

#import "UIViewController+OrderDetail.h"
#import "YJProgressHUD.H"

#import "YHRepairCaseDetailController.h"

extern NSString *const notificationOrderListChange;
@interface YHOrderListController ()
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightButtonAction:(id)sender;
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)NSMutableArray *dataSourceAll;
@property (weak, nonatomic) IBOutlet UITextField *searchFT;
- (IBAction)searchAction:(id)sender;
@property (nonatomic)NSUInteger page;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation YHOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationOrderListChange:) name:notificationOrderListChange object:nil];
    self.dataSource = [@[]mutableCopy];
    self.page = 1;
    //    _rightButton.hidden = !(_functionKey.integerValue == YHFunctionIdOrder) || _isHistory;
    self.title = @[@"新建工单",@"未处理工单",@"历史工单",@"未完成工单",@"财务统计",@"电路图的使用",@"其他收支",@"未处理订单",@"历史订单",@"全部功能"][_functionKey];
    
    _searchFT.text = self.keyWord;
    _searchFT.placeholder = ((_functionKey == YHFunctionIdUnprocessedOrder
                              || _functionKey == YHFunctionIdHistoryOrder)? (@"输入手机号／车牌号") : (@"输入手机号／车主名／车牌号"));
    
    if (_functionKey == YHFunctionIdCircuitDiagram) {
        _searchFT.placeholder = @"输入电路图名称";
        [self getCircuitDiagram];
    }else{
        __weak __typeof__(self) weakSelf = self;
        if (_functionKey == YHFunctionIdHistoryWorkOrder
            || _functionKey == YHFunctionIdUnprocessedOrder
            || _functionKey == YHFunctionIdHistoryOrder) {
            
            //添加一个上拉刷新
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf reupdataDatasource];
                //结束刷新
                [weakSelf.tableView.mj_footer endRefreshing];
            }];
            
            [self.tableView.mj_footer beginRefreshing];
        }else{
//            self.isLoading = YES;
            [self reupdataDatasource];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_functionKey != YHFunctionIdCircuitDiagram &&             self.isLoading == YES){
        self.page = 1;
//        self.isLoading = NO;
        [self reupdataDatasource];
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notificationOrderListChange:(NSNotification*)notice{
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer.hidden = NO;
    
    if (self.keyWord.length > 0) {
        _searchFT.text = self.keyWord;
    }
    
    if (_functionKey == YHFunctionIdCircuitDiagram) {
        self.dataSource = [@[]mutableCopy];
        for (NSDictionary *item in _dataSourceAll) {
            if ([item[@"title"] rangeOfString:_searchFT.text
                                      options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [_dataSource addObject:item];
            }
        }
        [self.tableView reloadData];
    }else{
        self.page = 1;
        if (_functionKey == YHFunctionIdHistoryWorkOrder
            || _functionKey == YHFunctionIdUnprocessedOrder
            || _functionKey == YHFunctionIdHistoryOrder) {
            [_dataSource removeAllObjects];
        }
        [self reupdataDatasource];
        //    [self.tableView.mj_footer beginRefreshing];
    }
}

- (IBAction)popViewController:(id)sender{

    if (_functionKey == YHFunctionIdCircuitDiagram  || _functionKey == YHFunctionIdUnfinishedWorkOrder  || _isLevelTwo || _keyWord) {
        [super popViewController:sender];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)getCircuitDiagram{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]getCircuitryList:[YHTools getAccessToken]
                                                              billId:self.orderInfo[@"id"]
                                                          onComplete:^(NSDictionary *info)
    {
         [MBProgressHUD hideHUDForView:weakSelf.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSDictionary *data = info[@"data"];
             weakSelf.dataSource = data[@"list"];
             weakSelf.dataSourceAll = data[@"list"];
             [weakSelf.tableView reloadData];
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

- (void)reupdataDatasource{
    [YJProgressHUD showProgress:@"" inView:self.view];
    __weak __typeof__(self) weakSelf = self;
    if ((_functionKey == YHFunctionIdHistoryWorkOrder)
        || (_functionKey == YHFunctionIdUnfinishedWorkOrder)
        || (_functionKey == YHFunctionIdNewWorkOrder)) {
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         getWorkOrderList:[YHTools getAccessToken]
         searchKey:_searchFT.text
         page:[NSString stringWithFormat:@"%lu", (unsigned long)_page]
         pagesize:((_functionKey == YHFunctionIdUnfinishedWorkOrder)? @"9999999" : CarInterval)
         isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
         isPending:(_functionKey == YHFunctionIdNewWorkOrder)
         onComplete:^(NSDictionary *info) {
             self.isLoading = YES;
             [YJProgressHUD hide];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSArray *data = info[@"data"];
                 
                 if (_functionKey != YHFunctionIdHistoryWorkOrder || weakSelf.page == 1) {
                     [weakSelf.dataSource removeAllObjects];
                 }
                 weakSelf.page += 1;

                 [weakSelf.dataSource addObjectsFromArray:data];
                 if (data.count < CarInterval.integerValue) {
                     if (weakSelf.dataSource.count == 0) {
                         if ([weakSelf.navigationController.viewControllers lastObject] == weakSelf) {
                           if(weakSelf == weakSelf.navigationController.topViewController)   [MBProgressHUD showError:@"暂未找到相应工单！"];
                         }
                     }else{
                         // 隐藏当前的上拉刷新控件
                         weakSelf.tableView.mj_header.hidden = YES;
                         weakSelf.tableView.mj_footer.hidden = YES;
                     }
                 }
                 [weakSelf.tableView reloadData];
             }else if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                 if(self.page == 1) [weakSelf.dataSource removeAllObjects];
                 weakSelf.tableView.mj_header.hidden = YES;
                 weakSelf.tableView.mj_footer.hidden = YES;
                 [weakSelf.tableView reloadData];
                 if(weakSelf == weakSelf.navigationController.topViewController) [MBProgressHUD showError:@"暂未找到相应工单！"];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [YJProgressHUD hide];
             self.isLoading = YES;
         }];
    }else{
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         getOrderList:[YHTools getAccessToken]
         keyword:_searchFT.text
         page:[NSString stringWithFormat:@"%lu", (unsigned long)_page]
         pagesize:CarInterval
         isHistory:(_functionKey == YHFunctionIdHistoryOrder)
         onComplete:^(NSDictionary *info) {
             [YJProgressHUD hide];
             self.isLoading = YES;
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSDictionary *data = info[@"data"];
                 NSArray *list = data[@"list"];
                 weakSelf.page += 1;
                 [weakSelf.dataSource addObjectsFromArray:list];
                 if (list.count < CarInterval.integerValue) {
                     if (weakSelf.dataSource.count == 0) {
                         if ([weakSelf.navigationController.viewControllers lastObject] == weakSelf) {
                            if(weakSelf == weakSelf.navigationController.topViewController)  [MBProgressHUD showError:@"暂未找到相应订单！"];
                         }
                     }else{
                         // 隐藏当前的上拉刷新控件
                         weakSelf.tableView.mj_header.hidden = YES;
                         weakSelf.tableView.mj_footer.hidden = YES;
                     }
                 }
                 [weakSelf.tableView reloadData];
             }else if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                 if(self.page == 1) [weakSelf.dataSource removeAllObjects];
                 weakSelf.tableView.mj_header.hidden = YES;
                 weakSelf.tableView.mj_footer.hidden = YES;
                 [weakSelf.tableView reloadData];
                 if(weakSelf == weakSelf.navigationController.topViewController) [MBProgressHUD showError:@"暂未找到相应订单！"];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [YJProgressHUD hide];
             self.isLoading = YES;
         }];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_functionKey == YHFunctionIdCircuitDiagram) {
        YHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circuitry" forIndexPath:indexPath];
        NSDictionary *info = _dataSource[indexPath.row];
        [cell loadName:info[@"title"]];
        return cell;
    }else{
        if (_functionKey == YHFunctionIdUnprocessedOrder
            || _functionKey == YHFunctionIdHistoryOrder) {
            YHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOrder" forIndexPath:indexPath];
            [cell loadDatassource:_dataSource[indexPath.row] functionId:_functionKey index:indexPath.row];
            return cell;
        }else{
            YHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            [cell loadDatassource:_dataSource[indexPath.row] functionId:_functionKey index:indexPath.row];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YHRepairCaseDetailController *repairVc = [[YHRepairCaseDetailController alloc] init];
//    [self.navigationController pushViewController:repairVc animated:YES];
//    return;
    
    //电路图
    if (_functionKey == YHFunctionIdCircuitDiagram) {
        [MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        
        NSDictionary *info = _dataSource[indexPath.row];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getCircuitryPic:[YHTools getAccessToken]
                                                                     id:info[@"id"]
                                                             onComplete:^(NSDictionary *info) {
              [MBProgressHUD hideHUDForView:weakSelf.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSDictionary *data = info[@"data"];
                 [YHHUPhotoBrowser showFromImageView:nil withURLStrings:data[@"list"] placeholderImage:[UIImage imageNamed:@"dianlutuB"] atIndex:0 dismiss:nil];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
              [MBProgressHUD hideHUDForView:weakSelf.view];
         }];
    }else{
        
        NSDictionary *orderInfo = _dataSource[indexPath.row];// cloudMakeDepth cloudDepthQuote  cloudPushDepth
        
        //未处理订单、历史订单
        if (_functionKey == YHFunctionIdUnprocessedOrder || _functionKey == YHFunctionIdHistoryOrder) {
            
                YHOrderDetailController *controller = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
                //controller.data = self.data;
                controller.functionKey = _functionKey;
                controller.orderId = orderInfo[@"id"];
                controller.dethPay = YES;
                [self.navigationController pushViewController:controller animated:YES];
        //其它
        }else{
//            [self orderDetailNavi:orderInfo];
#warning [self orderDetailNavi:orderInfo]
            [self orderDetailNavi:orderInfo code:self.functionKey];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"XXXXXXXXXX---%ld",indexPath.row);
    if (_functionKey == YHFunctionIdCircuitDiagram) {
        return 60;
    }else{
        if (_functionKey == YHFunctionIdUnprocessedOrder){
            return 120;
        }else if (_functionKey == YHFunctionIdHistoryOrder) {
            return 150;
        }else{
            float h =[tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(YHOrderCell* cell) {
                [cell loadDatassource:_dataSource[indexPath.row] functionId:_functionKey];
            }];
            return h;
        }
    }
}

- (void)orderDetailNavi:(NSDictionary*)orderInfo{
    
    NSString *billType = orderInfo[@"billType"];
    //[MBProgressHUD showSuccess:billType];
    if ([orderInfo[@"nextStatusCode"] isEqualToString:@"checkCar"] ) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHVehicleController *controller = [board instantiateViewControllerWithIdentifier:@"YHVehicleController"];
        controller.orderInfo= orderInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ((self.functionKey == YHFunctionIdHistoryWorkOrder && ( [billType isEqualToString:@"V"] || [billType isEqualToString:@"J"] || [billType isEqualToString:@"E"]))//三大报告
              || (([billType isEqualToString:@"J"] || [billType isEqualToString:@"E"]) &&([orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"] || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]))
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushAssessCarReport"]//估车车报告
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushCheckReport"]//检测报告 特殊流程(全部正常，无维修方式)
              //              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]//全车检测
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushUsedCarCheckReport"]//二手车报告
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushUsedCarCheckReport"]//二手车报告 推送报告 特殊流程(全部正常，无维修方式)
              
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeCheckReportQuote"]//检测报告 修改报价
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]//二手车报告 修改报价
              || [orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]) {//检测报告
        [self historyNavi:orderInfo];
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"cloudMakeDepth"]
              ||([orderInfo[@"nextStatusCode"] isEqualToString:@"storeDepthQuote"])
              //              ||[orderInfo[@"nextStatusCode"] isEqualToString:@"modeQuote"]//人工费
              ||[orderInfo[@"nowStatusCode"] isEqualToString:@"cloudMakeDepth"]
              || ([orderInfo[@"nextStatusCode"] isEqualToString:@"checkCar"] && [billType isEqualToString:@"B"])){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHDepthController *controller = [board instantiateViewControllerWithIdentifier:@"YHDepthController"];
        controller.orderInfo = orderInfo;
        controller.isRepair = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([orderInfo[@"nowStatusCode"] isEqualToString:@"carAppointment"]
              || ([orderInfo[@"nextStatusCode"] isEqualToString:@"consulting"] && [orderInfo[@"nowStatusCode"] isEqualToString:@"receivedBill"])){// 预约
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"]];
        controller.title = @"工单";
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    //5、捕车首保；6、JNS(小虎)安全诊断
    }else if (([orderInfo[@"nextStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) && ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"] || [billType isEqualToString:@"A"])){
        [MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                                billId:orderInfo[@"id"]
                                                             isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
                                                            onComplete:^(NSDictionary *info)
        {
            [MBProgressHUD hideHUDForView:weakSelf.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSDictionary *data = info[@"data"];
                 NSString *handleType = data[@"handleType"];
                 if (![handleType isEqualToString:@"detail"] && handleType) {
                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                     YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
                     controller.sysData = data;
                     controller.orderInfo = orderInfo;
                     [weakSelf.navigationController pushViewController:controller animated:YES];
                 }else{
                     [weakSelf interView:orderInfo isDetail:YES];
                 }
             }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
                 [weakSelf interView:orderInfo isDetail:NO];
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:weakSelf.view];
         }];
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"storePushExtWarrantyReport"] && ([billType isEqualToString:@"Y"]  || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"] || [billType isEqualToString:@"A"])){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@%@/insurance.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken], orderInfo[@"id"]];
        controller.title = @"工单";
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    //4、二手车检测
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"usedCarInitialSurvey"] && [billType isEqualToString:@"E001"]){
        YHDiagnosisProjectVC *VC = [[YHDiagnosisProjectVC alloc]init];
        YHBillStatusModel *billModel = [[YHBillStatusModel alloc]init];
        billModel.billId = orderInfo[@"id"];
        VC.billModel = billModel;
        VC.isHelp = YES;
        [self.navigationController pushViewController:VC animated:YES];
    //JNS(小虎)安检、维修、小虎事故车检测、JNS(小虎)全车检测
    }else{
        [self interView:orderInfo isDetail:YES];
    }
}

- (void)historyNavi:(NSDictionary*)orderInfo
{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                            billId:orderInfo[@"id"]
                                                         isHistory:(_functionKey == YHFunctionIdHistoryWorkOrder)
                                                        onComplete:^(NSDictionary *info) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             NSDictionary *data = info[@"data"];
             NSDictionary *reportData = data[@"reportData"];
             [weakSelf interView:orderInfo isDetail:((reportData == nil) || !(reportData.count > 0)/*报告已出和已购买 */ || (([orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"] || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]) /* 等待生产报告和等待购买报告情况*/))];
         }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
             [weakSelf interView:orderInfo isDetail:NO];
         }
     } onError:^(NSError *error) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

- (void)interView:(NSDictionary*)orderInfo isDetail:(BOOL)isDetail
{
    //1、JNS(小虎)安检  2、JNS(小虎)全车检测   3、小虎事故车检测
    if (isDetail) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
        controller.functionKey = _functionKey;
        NSString *billStatus = orderInfo[@"billStatus"];
        if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
            controller.functionKey = YHFunctionIdHistoryWorkOrder;
        }
        controller.orderInfo = orderInfo;
        controller.isPop2Root = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.barHidden = YES;
        if ([orderInfo[@"billType"] isEqualToString:@"V"]) {
            controller.urlStr = [NSString stringWithFormat:@"%@%@/look_assess.html?token=%@&order_id=%@&status=ios%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"],  ((self.functionKey == YHFunctionIdHistoryWorkOrder)? (@"") : (@"&push=1"))];
        }else{
            controller.urlStr = [NSString stringWithFormat:@"%@%@/look_report.html?token=%@&billId=%@&status=ios&order_status=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"],(((self.functionKey == YHFunctionIdHistoryWorkOrder)/* 历史工单传 billType*/ )? (orderInfo[@"billType"]) : (orderInfo[@"nextStatusCode"]))];
            
        }
        controller.title = @"工单";
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (IBAction)rightButtonAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
    controller.functionKey = _functionKey;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)searchAction:(id)sender {
    [[self view] endEditing:YES];
    [self notificationOrderListChange:nil];
}

- (IBAction)receiveAction:(UIButton*)button {
    NSUInteger index = button.tag;
    NSDictionary *orderInfo = _dataSource[index];
    if (!([orderInfo[@"nowStatusCode"] isEqualToString:@"carAppointment"] &&  [orderInfo[@"nextStatusCode"] isEqualToString:@"consulting"])) {
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     saveChannelReceiveBill:[YHTools getAccessToken]
     billId:orderInfo[@"id"]
     onComplete:^(NSDictionary *info) {
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [weakSelf notificationOrderListChange:nil];
             [MBProgressHUD showSuccess:@"接单成功！"];
         }else{
              [MBProgressHUD hideHUDForView:weakSelf.view];
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 [weakSelf showErrorInfo:info];
                 YHLogERROR(@"");
             }
         }
         
     } onError:^(NSError *error) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
    
}
@end
