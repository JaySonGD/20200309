//
//  YTBillPackageController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 8/10/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTBillPackageController.h"
#import "YHWebFuncViewController.h"
#import "YTPhoneCell.h"
#import "YHCarPhotoService.h"
#import "YTBillPackageModel.h"
#import "YTBillPackageCell.h"

#import <UIView+Frame.h>

@interface YTBillPackageController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YTPackageModel *model;
@end

@implementation YTBillPackageController
- (IBAction)closeClick:(UIButton *)sender {
    self.tableView.tableHeaderView = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (IBAction)reportClick:(UIButton *)sender {
    
    
    if(self.model.insurance_info.phone.length != 11) {
        [MBProgressHUD showError:@"手机号码有误！"];
        return;
    }

    NSMutableDictionary *package = [NSMutableDictionary dictionary];
    [self.model.list enumerateObjectsUsingBlock:^(YTBillPackageModel * _Nonnull lobj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *larray = [NSMutableArray array];
        [lobj.system_list enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(sobj.is_check) [larray addObject:[NSString stringWithFormat:@"%@",sobj.Id]];
            [sobj.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.is_check) [larray addObject:[NSString stringWithFormat:@"%@",obj.Id]];
            }];
        }];
        if(larray.count) [package setObject:larray forKey:lobj.code];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] saveBillPackage:self.billId phone:self.model.insurance_info.phone is_sync:self.model.insurance_info.check bill_package:package success:^{
        //[MBProgressHUD showError:@"保存成功"];
//        [[YHCarPhotoService new] saveStorePushExtWarrantyReportBill_id:self.billId phone:self.model.insurance_info.phone syncWarrantyPhone:self.model.insurance_info.check success:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            
            //NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=Y002_report&jnsAppStatus=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId];
            NSString *urlString = [NSString stringWithFormat:@"%@/%@/maintenance_plan.html?token=%@&billId=%@&status=ios",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken],self.billId];


            
            controller.urlStr = urlString;
            controller.barHidden = YES;
            
            
//            NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:10];
//            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                [viewControllers addObject:obj];
//                if([obj isKindOfClass:NSClassFromString(@"YHOrderListController")] ){//有详情页只去掉信息确认页
//                    [viewControllers addObject:controller];
//                    *stop = YES;
//                }
//            }];
//
//            if ([viewControllers containsObject:controller]) {
//                self.navigationController.viewControllers = viewControllers;
//                return ;
//            }
//
//            YHWebFuncViewController *webList = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
//
//            webList.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=Y002_list&jnsAppStatus=ios&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId];
//            webList.barHidden = YES;
//
            
//            self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject,webList,controller];
            
            [self.navigationController pushViewController:controller animated:YES];
            return ;
//            
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
//        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView = nil;

    self.navigationItem.title = @"设置首保套餐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveSys)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[YHCarPhotoService new] getBillPackageList:self.billId success:^(YTPackageModel *model) {
    
//                YTPackageModel *m = [YTPackageModel new];
//
//        YTInsuranceInfoModel *inx = [YTInsuranceInfoModel new];
//        inx.phone = @"4444";
//        inx.check = YES;
//        m.insurance_info = inx;
//
//        YTBillPackageModel *l0 = [YTBillPackageModel new];
//        l0.title = @"畅行套餐";
//    l0.sales_price = @"499.00";
//    l0.code =@"4444s";
//        l0.warranty_desc = @"赠3个月或1万公里延长性能保障";
//
//        YTSystemPackageModel *s0 = [YTSystemPackageModel new];
//        s0.name = @"父级系统0";
//    s0.status = 2;
//
//
//        YTSystemPackageModel *c0 = [YTSystemPackageModel new];
//        c0.name = @"子级系统0";
//    c0.is_check = YES;
//    c0.status = 1;
//
//    YTSystemPackageModel *s2 = [YTSystemPackageModel new];
//    s2.name = @"父级系统2";
//    s2.status = 2;
//
//
//    YTSystemPackageModel *c2 = [YTSystemPackageModel new];
//    c2.name = @"子级系统2";
//    c2.status = 1;
//
//        s0.child_system = @[c0].mutableCopy;
//    s2.child_system = @[c2].mutableCopy;
//
//        l0.system_list = @[s0,s2].mutableCopy;
//
//
//        YTBillPackageModel *l1 = [YTBillPackageModel new];
//        l1.title = @"尊享套餐";
//        l1.status = 1;
//        l1.warranty_desc = @"赠1年或2万公里延长性能保障";
//    l1.code =@"44444433s";
//    l1.is_accept = YES;
//    l1.sales_price = @"4929.00";
//
//        YTSystemPackageModel *s1 = [YTSystemPackageModel new];
//        s1.name = @"父级系统1";
//        YTSystemPackageModel *c1 = [YTSystemPackageModel new];
//        c1.name = @"子级系统1";
//
//    YTSystemPackageModel *s3 = [YTSystemPackageModel new];
//    s3.name = @"父级系统3";
//    s3.status = 1;
//
//
//    YTSystemPackageModel *c3 = [YTSystemPackageModel new];
//    c3.name = @"子级系统3";
//        c3.is_check = YES;
//    c3.status = 1;
//
//        s1.child_system = @[c1].mutableCopy;
//    s3.child_system = @[c3].mutableCopy;
//
//        l1.system_list = @[s1,s3].mutableCopy;
//
//        m.list = @[l0,l1].mutableCopy;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      
        
        self.model = model;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];

    
    [self.tableView.tableHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packageRuleAction)]];
    
}//
- (void)packageRuleAction{
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTPackageRulesController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)saveSys{
    
    if (IsEmptyStr(self.model.insurance_info.phone)) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    NSMutableDictionary *package = [NSMutableDictionary dictionary];
    [self.model.list enumerateObjectsUsingBlock:^(YTBillPackageModel * _Nonnull lobj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *larray = [NSMutableArray array];
        [lobj.system_list enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(sobj.is_check) [larray addObject:[NSString stringWithFormat:@"%@",sobj.Id]];
            [sobj.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.is_check) [larray addObject:[NSString stringWithFormat:@"%@",obj.Id]];
            }];
        }];
        if(larray.count) [package setObject:larray forKey:lobj.code];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] saveBillPackage:self.billId phone:self.model.insurance_info.phone is_sync:self.model.insurance_info.check bill_package:package success:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"保存成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.model.insurance_info? 1 : 0) + self.model.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.model.insurance_info) {
        if (!indexPath.row) {
            YTPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phone"];
            cell.model = self.model.insurance_info;
            return cell;
        }
        
        YTBillPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"free"];
        cell.model = self.model.list[indexPath.row-1];
        cell.reload = ^{
            [UIView performWithoutAnimation:^{
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;

    }

    YTBillPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"free"];
    cell.model = self.model.list[indexPath.row];
    cell.reload = ^{
        [UIView performWithoutAnimation:^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };

    return cell;

}

@end
