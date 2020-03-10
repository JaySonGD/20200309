//
//  UIViewController+OrderDetail.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 19/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "UIViewController+OrderDetail.h"
#import "YHDepthController.h"
#import "YHVehicleController.h"
#import "YHWebFuncViewController.h"
#import "YHDiagnosisProjectVC.h"
#import "YHInitialInspectionController.h"
#import "YHCarPhotoService.h"
#import <MJExtension.h>
#import "YHTools.h"

#import "YHNetworkPHPManager.h"

#import "YHOrderDetailNewController.h"

#import "YHAppointmentOrderController.h"

#import "YHOrderListController.h"

#import "YHShowImageController.h"

#import "YHStoreTool.h"
#import "YHHUPhotoBrowser.h"

#import "YTRepairViewController.h"
#import "YTOrderDetailNewController.h"
#import "TTZSurveyModel.h"
#import "TTZCheckViewController.h"
#import "YTDepthController.h"
#import "YTCounterController.h"
#import "YHOrderDetailNewOneController.h"

extern NSString *const notificationOrderListChange;
@implementation UIViewController (OrderDetail)


- (void)showImageByCode:(NSString*)code
             hasNeedBuy:(BOOL)needBuy with:(BOOL)isHome{
    if ([code isEqualToString:@"menu_bill"]) {
        [self pushImageByCode:code hasNeedBuy:needBuy with:YES];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHShowImageController *controller = [board instantiateViewControllerWithIdentifier:@"YHShowImageController"];
    controller.isHome = isHome;
    controller.needBuy = needBuy;
    controller.imageUrl = [NSString stringWithFormat:@"https://images.mhace.cn/cloudImg/intro/%@.png", code];
    [self showDetailViewController:controller sender:nil];
    
}

- (void)pushImageByCode:(NSString*)code
             hasNeedBuy:(BOOL)needBuy with:(BOOL)isHome{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHShowImageController *controller = [board instantiateViewControllerWithIdentifier:@"YHShowImageController"];
    controller.isHome = isHome;
    controller.needBuy = needBuy;
    controller.imageUrl = [NSString stringWithFormat:@"https://images.mhace.cn/cloudImg/intro/%@.png", code];
    
    
    controller.navigationItem.title = @"详细功能介绍";
    [self.navigationController pushViewController:controller animated:YES];
    
    //
    YHWebFuncViewController *webVC = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    webVC.urlStr = [NSString stringWithFormat:@"%@%@/functionPage.html?token=%@&status=ios&code=%@&nav=1", SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken],code];
    [controller.view insertSubview:webVC.view atIndex:2];
    [controller addChildViewController:webVC];
    
}


- (void)showImageByCode:(NSString*)code{
    //    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    //    YHShowImageController *controller = [board instantiateViewControllerWithIdentifier:@"YHShowImageController"];
    //    controller.imageUrl = [NSString stringWithFormat:@"https://images.mhace.cn/cloudImg/intro/%@.png", code];
    //    [self showDetailViewController:controller sender:nil];
    [self showImageByCode:code hasNeedBuy:NO with:NO];
}

- (void)orderDetailNavi:(NSDictionary*)orderInfo code:(YHFunctionId)functionKey
{\
    NSString *billType = orderInfo[@"billType"];
    NSString *nextStatusCode = orderInfo[@"nextStatusCode"];
    //    [MBProgressHUD showSuccess:billType];
    if ([orderInfo[@"type"] isEqualToString:@"policy_case"] ) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@#/policy/policyDetail?policy_case_id=%@&status=ios", SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken], orderInfo[@"id"]];
        //http://www.mhace.cn/jnsTest/index.html?token=876bde32cc2b06735867f17e86a293f7&status=ios#/policy/policyDetail?policy_case_id=9
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"checkCar"] ) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHVehicleController *controller = [board instantiateViewControllerWithIdentifier:@"YHVehicleController"];
        controller.orderInfo= orderInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }else if([orderInfo[@"type"] isEqualToString:@"xhjc_booking_cancel"]) {
        
        BOOL isExist = NO;
        // 预约单取消
        for (int i = 0; i<self.navigationController.viewControllers.count; i++) {
            UIViewController *vc = self.navigationController.viewControllers[i];
            if ([vc isKindOfClass:[YHOrderListController class]]) {
                
                ((YHOrderListController*)vc).functionKey = functionKey;
                ((YHOrderListController*)vc).isLevelTwo = YES;
                [[NSNotificationCenter
                  defaultCenter] postNotificationName:notificationOrderListChange
                 object:Nil
                 userInfo:nil];
                [MBProgressHUD showError:@"该订单已取消"];
                [self.navigationController popToViewController:vc animated:YES];
                
                isExist = YES;
                break;
            }
        }
        
        if (!isExist) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"]; controller.functionKey = functionKey;
            controller.isLevelTwo = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else if (
              (functionKey == YHFunctionIdHistoryWorkOrder && ( [billType isEqualToString:@"V"] || [billType isEqualToString:@"J"] || [billType isEqualToString:@"E"]))//三大报告
              || (([billType isEqualToString:@"J"] || [billType isEqualToString:@"E"]) &&([orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"] || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]))
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushAssessCarReport"]//估车车报告
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushCheckReport"]//检测报告 特殊流程(全部正常，无维修方式)
              //              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]//全车检测
              //              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storePushUsedCarCheckReport"]//二手车报告
              || ([orderInfo[@"nextStatusCode"] isEqualToString:@"storePushUsedCarCheckReport"] && ![billType isEqualToString:@"E002"] && ![billType isEqualToString:@"E003"])//二手车报告 推送报告 特殊流程(全部正常，无维修方式)
              
              || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeCheckReportQuote"]//检测报告 修改报价
              || ([orderInfo[@"nextStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"] && ![billType isEqualToString:@"E002"] && ![billType isEqualToString:@"E003"] )//二手车报告 修改报价
              || [orderInfo[@"nowStatusCode"] isEqualToString:@"storeCheckReportQuote"]) {//检测报告
        
        [self historyNavi:orderInfo code:functionKey];
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
        
        //if([orderInfo[@"channelCode"] isEqualToString:@"YHJC10000"] && [orderInfo[@"nextStatusCode"] isEqualToString:@"consulting"])
        if(([orderInfo[@"partnerType"] isEqualToString:@"xhjc_booking"] || [orderInfo[@"partnerType"] isEqualToString:@"buche_user_booking"]) && [orderInfo[@"nextStatusCode"] isEqualToString:@"consulting"])
        {
            
            YHAppointmentOrderController *appointmentOrderVc = [[YHAppointmentOrderController alloc] init];
            appointmentOrderVc.orderId = orderInfo[@"id"];
            appointmentOrderVc.orderInfo = orderInfo;
            [self.navigationController pushViewController:appointmentOrderVc animated:YES];
            
        }else{
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&billId=%@&status=ios", SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken], orderInfo[@"id"]];
            controller.title = @"工单";
            controller.barHidden = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        //5、捕车首保；6、JNS(小虎)安全诊断 (问询状态)
    }else if (([orderInfo[@"nextStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]) && ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"] || [billType isEqualToString:@"A"])){
#pragma mark - A Y Y001
        
        [MBProgressHUD showMessage:nil toView:self.view];
        //[MBProgressHUD showMessage:@"" toView:self.view];
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                                billId:orderInfo[@"id"]
                                                             isHistory:(functionKey == YHFunctionIdHistoryWorkOrder)
                                                            onComplete:^(NSDictionary *info)
         {
             //[MBProgressHUD hideHUDForView:self.view];
             [MBProgressHUD hideHUDForView:weakSelf.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 
                 BOOL detectionPay = [info[@"data"][@"detectionPay"] boolValue];
                 //"detectionPay": "0", // 检测服务费支付装：0-未付款 1-已付款
                 if (!detectionPay) { // 去支付
                     
                     YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                     vc.billId = orderInfo[@"id"];
                     vc.billType = billType;
                     vc.buy_type = 3;
                     
                     [self.navigationController pushViewController:vc animated:YES];
                     [self.navigationController setNavigationBarHidden:NO animated:NO];
                     return;
                 }

                 
                 NSDictionary *data = info[@"data"];
                 NSString *handleType = data[@"handleType"];
                if (![handleType isEqualToString:@"detail"] && handleType) {
                    
                    if([billType isEqualToString:@"A"] || [billType isEqualToString:@"Y002"]){//问询
                        YHOrderDetailNewOneController *orderDetailVc = [[YHOrderDetailNewOneController alloc] init];
                        orderDetailVc.orderDetailInfo = orderInfo;
                        orderDetailVc.isCheckComplete = NO;
                        orderDetailVc.functionKey = functionKey;
                        NSString *billStatus = orderInfo[@"billStatus"];
                        orderDetailVc.functionCode = YHFunctionIdConsulting;
                        
                        if ([billStatus isEqualToString:@"complete"]) {
                             orderDetailVc.functionCode = YHFunctionIdEndBill;//"nowStatusCode" : "endBill",
                        }
                        
                        if([billStatus isEqualToString:@"close"]){
                             orderDetailVc.functionCode = YHFunctionIdClose;//"nowStatusCode" : "endBill",
                        }
                        
                        [self.navigationController pushViewController:orderDetailVc animated:YES];
                        return;
                    }
                     
                     YHOrderDetailNewController *orderDetailVc = [[YHOrderDetailNewController alloc] init];
                     orderDetailVc.orderDetailInfo = orderInfo;
                     orderDetailVc.isCheckComplete = NO;
                     orderDetailVc.functionKey = functionKey;
                     NSString *billStatus = orderInfo[@"billStatus"];
                     if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
                         orderDetailVc.functionKey = YHFunctionIdHistoryWorkOrder;
                     }
                     [self.navigationController pushViewController:orderDetailVc animated:YES];
                     ///////////////////
                     return;
                     UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                     YHInitialInspectionController *controller = [board instantiateViewControllerWithIdentifier:@"YHInitialInspectionController"];
                     controller.sysData = data;
                     controller.orderInfo = orderInfo;
                     [weakSelf.navigationController pushViewController:controller animated:YES];
                 }else{
                     [weakSelf interView:orderInfo isDetail:YES code:functionKey];
                 }
             }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
                 [weakSelf interView:orderInfo isDetail:NO code:functionKey];
             }
         } onError:^(NSError *error) {
             //[MBProgressHUD hideHUDForView:self.view];
             [MBProgressHUD hideHUDForView:weakSelf.view];
         }];
    }else if ([orderInfo[@"nextStatusCode"] isEqualToString:@"storePushExtWarrantyReport"] && ([billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"] || [billType isEqualToString:@"A"])){//初检
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        if ([billType isEqualToString:@"Y002"]) {
            
//            controller.urlStr = [NSString stringWithFormat:@"%@%@/newExtendedWarranty.html?token=%@&status=ios&billId=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"]];

                [MBProgressHUD showMessage:@"" toView:self.view];
                [[YHCarPhotoService new] newWorkOrderDetailForBillId:orderInfo[@"id"]
                                                             success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *info) {

                                                                 [MBProgressHUD hideHUDForView:self.view];
                                                                 YTDepthController *vc =[YTDepthController new];
                                                                 vc.orderType = billType;
                                                                 vc.order_id = orderInfo[@"id"];
                                                                 vc.reportModel = [YHReportModel mj_objectWithKeyValues:[info valueForKey:@"data"]];
                                                                 [self.navigationController pushViewController:vc animated:YES];
                                                              
                                                             }
                                                             failure:^(NSError *error) {
                                                                 
                                                                 [MBProgressHUD hideHUDForView:self.view];
                                                             }];
              return;
            
        }else{
            controller.urlStr = [NSString stringWithFormat:@"%@%@/insurance.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"]];
        }
        
        if([billType isEqualToString:@"A"]){//捕车首保跳转到工单详情页,不在跳转h5,初检状态
            
                YHOrderDetailNewOneController *orderDetailVc = [[YHOrderDetailNewOneController alloc] init];
                orderDetailVc.orderDetailInfo = orderInfo;
                orderDetailVc.isCheckComplete = NO;
                orderDetailVc.functionKey = functionKey;
                orderDetailVc.functionCode = YHFunctionIdInitialSurvey;//"nowStatusCode" : "extWarrantyInitialSurvey"初检
                NSString *billStatus = orderInfo[@"billStatus"];
                if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
                    orderDetailVc.functionKey = YHFunctionIdHistoryWorkOrder;
                }
                [self.navigationController pushViewController:orderDetailVc animated:YES];
                return;
            }
        
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
        //解决方案
    }else if ([billType isEqualToString:@"W001"]
              && (
                  (![nextStatusCode isEqualToString:@"initialSurvey"]
                   //              && ![nextStatusCode isEqualToString:@"initialSurveyCompletion"]
                   && ![nextStatusCode isEqualToString:@"consulting"])
                  || ([orderInfo[@"isSolution"] boolValue] == NO)
                  )
              
              ){
        
        YTRepairViewController *vc = [YTRepairViewController new];
        vc.orderDetailInfo = orderInfo;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [self interView:orderInfo isDetail:YES code:functionKey];
    }
}

- (void)historyNavi:(NSDictionary*)orderInfo  code:(YHFunctionId)functionKey
{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken]
                                                            billId:orderInfo[@"id"]
                                                         isHistory:(functionKey == YHFunctionIdHistoryWorkOrder)
                                                        onComplete:^(NSDictionary *info) {
                                                            [MBProgressHUD hideHUDForView:self.view];
                                                            if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                                                                NSDictionary *data = info[@"data"];
                                                                NSDictionary *reportData = data[@"reportData"];
                                                                [weakSelf interView:orderInfo isDetail:((reportData == nil) || !(reportData.count > 0)/*报告已出和已购买 */ || (([orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyUsedCarCheckReport"] || [orderInfo[@"nextStatusCode"] isEqualToString:@"storeBuyCheckReport"]) /* 等待生产报告和等待购买报告情况*/)) code:functionKey];
                                                            }else if (((NSNumber*)info[@"code"]).integerValue == 30100) {
                                                                [weakSelf interView:orderInfo isDetail:NO code:functionKey];
                                                            }
                                                        } onError:^(NSError *error) {
                                                            [MBProgressHUD hideHUDForView:self.view];
                                                        }];
}

- (void)interView:(NSDictionary*)orderInfo isDetail:(BOOL)isDetail code:(YHFunctionId)functionKey
{
    //1、JNS(小虎)安检  2、JNS(小虎)全车检测   3、小虎事故车检测  4、汽车检测 5.E002(二手车) 6.J006(汽车安检)
    if (isDetail) {
        
        if ([orderInfo[@"billType"] isEqualToString:@"J009"]) {
            
            if ([orderInfo[@"nextStatusCode"] isEqualToString:@"newWholeCarInitialSurvey"]) {
                [[YHCarPhotoService new] getJ005ItemBillId:orderInfo[@"id"] success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *baseInfo) {
                    
                    models.firstObject.className = @"空调检测";
                    models.firstObject.list.firstObject.projectName = @"空调检测";
                    [MBProgressHUD hideHUDForView:self.view];
                    TTZCheckViewController *vc = [TTZCheckViewController new];
                    vc.sysModels = models;
                    vc.billType = orderInfo[@"billType"];
                    vc.billId = orderInfo[@"id"];
                    vc.title = orderInfo[@"billTypeName"];
                    vc.carBrand = [baseInfo valueForKey:@"car_brand_name"];
                    [self.navigationController setNavigationBarHidden:NO animated:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view];
                }];
                return;
            }
            if ([orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]) {
                
                
                YTOrderDetailNewController *vc = [YTOrderDetailNewController new];
                vc.billType = orderInfo[@"billType"];
                vc.billId = orderInfo[@"id"];
                vc.title = orderInfo[@"billTypeName"];
                [self.navigationController pushViewController:vc animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                return;
            }
            
        }
        
        if ([orderInfo[@"billType"] isEqualToString:@"J001"] || [orderInfo[@"billType"] isEqualToString:@"J002"] || [orderInfo[@"billType"] isEqualToString:@"J003"] || [orderInfo[@"billType"] isEqualToString:@"J004"] ||
            [orderInfo[@"billType"] isEqualToString:@"E002"] || [orderInfo[@"billType"] isEqualToString:@"J006"] || [orderInfo[@"billType"] isEqualToString:@"E003"] || [orderInfo[@"billType"] isEqualToString:@"J008"] || [orderInfo[@"billType"] isEqualToString:@"A"]) {
            
            if([orderInfo[@"billType"] isEqualToString:@"A"]){//首保复检 / 已完成 / 作废单
                YHOrderDetailNewOneController *orderDetailVc = [[YHOrderDetailNewOneController alloc] init];
                orderDetailVc.orderDetailInfo = orderInfo;
                orderDetailVc.isCheckComplete = NO;
                orderDetailVc.functionKey = functionKey;
                
                
                if([orderInfo[@"nextStatusCode"] isEqualToString:@"extendReview"]){
                    orderDetailVc.functionCode = YHFunctionIdReCheck;//"nowStatusCode" : "pendingPackage",//待购买套餐
                }
                
                NSString *billStatus = orderInfo[@"billStatus"];
                if ([billStatus isEqualToString:@"complete"]) {
                     orderDetailVc.functionCode = YHFunctionIdEndBill;//"nowStatusCode" : "endBill",
                }
                
                if([billStatus isEqualToString:@"close"]){
                     orderDetailVc.functionCode = YHFunctionIdClose;//"nowStatusCode" : "endBill",
                }
                
                
                [self.navigationController pushViewController:orderDetailVc animated:YES];
                return;
                
            }
            
            YHOrderDetailNewController *orderDetailVc = [[YHOrderDetailNewController alloc] init];
            orderDetailVc.orderDetailInfo = orderInfo;
            orderDetailVc.isCheckComplete = NO;
            orderDetailVc.functionKey = functionKey;
            NSString *billStatus = orderInfo[@"billStatus"];
            if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
                orderDetailVc.functionKey = YHFunctionIdHistoryWorkOrder;
            }
            [self.navigationController pushViewController:orderDetailVc animated:YES];
            return;
        }
        
        if (([orderInfo[@"billType"] isEqualToString:@"E001"] || [orderInfo[@"billType"] isEqualToString:@"J009"])&& ([orderInfo[@"nextStatusCode"] isEqualToString:@"storePushNewWholeCarReport"]
                                                                 || [orderInfo[@"nextStatusCode"] isEqualToString:@"endBill"]
                                                                 || [orderInfo[@"nowStatusCode"] isEqualToString:@"endBill"])) {
            // 二手车检测报告
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.urlStr = [NSString stringWithFormat:@"%@%@/maintenance_report.html?token=%@&&status=ios&billId=%@",SERVER_PHP_URL_Statements_H5, SERVER_PHP_H5_Trunk,[YHTools getAccessToken],orderInfo[@"id"]];
            
            if([orderInfo[@"billType"] isEqualToString:@"J009"]){
                controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=%@_report&status=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],orderInfo[@"id"],orderInfo[@"billType"]];
 //http://www.mhace.cn/jnsDev/index.html?token=20b9bd9c45b8e63adf42667cd71ebdd4&bill_id=21147&jnsAppStep=J009_report_h5&bill_type=J009&status=ios&#/appToH5
            }
            
            controller.title = @"工单";
            controller.barHidden = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{//延长保修(已完成/废弃单)会走这里
            //&&[orderInfo[@"nextStatusCode"] isEqualToString:@"extendReview"]
            if([orderInfo[@"billType"] isEqualToString:@"Y002"]){//延长保修复检单/已完成/废弃单
                YHOrderDetailNewOneController *orderDetailVc = [[YHOrderDetailNewOneController alloc] init];
                orderDetailVc.orderDetailInfo = orderInfo;
                orderDetailVc.isCheckComplete = NO;
                orderDetailVc.functionKey = functionKey;
                orderDetailVc.functionCode =   YHFunctionIdReCheck;
//                
//                if([orderInfo[@"nextStatusCode"] isEqualToString:@"extendReview"]){
//                    orderDetailVc.functionCode =   YHFunctionIdReCheck;
//                }
                
                if([orderInfo[@"billStatus"] isEqualToString:@"close"]){
                    orderDetailVc.functionCode =   YHFunctionIdClose;
                }
                
                if([orderInfo[@"billStatus"] isEqualToString:@"complete"]){
                     orderDetailVc.functionCode =  YHFunctionIdEndBill;
                }
                
                [self.navigationController pushViewController:orderDetailVc animated:YES];
                return;
            }
            
            YHOrderDetailController *controller = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
            controller.functionKey = functionKey;
            NSString *billStatus = orderInfo[@"billStatus"];
            if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
                controller.functionKey = YHFunctionIdHistoryWorkOrder;
            }
            controller.orderInfo = orderInfo;
            [[YHStoreTool ShareStoreTool] setNewOrderInfo:orderInfo];
            controller.isPop2Root = NO;
            
            //G表示父工单
            if ([orderInfo[@"billType"] isEqualToString:@"G"]) {
                controller.isFatherWorkList = YES;
                //                @property (nonatomic, assign) BOOL showCarReport;
                
                controller.showCarReport = [[self valueForKey:@"showCarReport"] boolValue];
            }
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.barHidden = YES;
        if ([orderInfo[@"billType"] isEqualToString:@"V"]) {
            controller.urlStr = [NSString stringWithFormat:@"%@%@/look_assess.html?token=%@&order_id=%@&status=ios%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"],  ((functionKey == YHFunctionIdHistoryWorkOrder)? (@"") : (@"&push=1"))];
        }else{
            
            if ([orderInfo[@"nextStatusCode"] isEqualToString:@"storeUsedCarCheckReportQuote"]) {
                // 新二手车
                controller.urlStr = [NSString stringWithFormat:@"%@%@/maintenance_report.html?token=%@&&status=ios&billId=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken],orderInfo[@"id"]];
                
            }else{
                controller.urlStr = [NSString stringWithFormat:@"%@%@/look_report.html?token=%@&billId=%@&status=ios&order_status=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], orderInfo[@"id"],(((functionKey == YHFunctionIdHistoryWorkOrder)/* 历史工单传 billType*/ )? (orderInfo[@"billType"]) : (orderInfo[@"nextStatusCode"]))];
            }
            
        }
        controller.title = @"工单";
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
