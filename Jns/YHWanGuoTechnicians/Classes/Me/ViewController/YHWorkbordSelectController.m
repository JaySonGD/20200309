//
//  YHWorkbordSelectController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/27.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkbordSelectController.h"
#import "YHworkbordSelectCell.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
extern NSString *const notificationDustbin;
@interface YHWorkbordSelectController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomB;
@end

@implementation YHWorkbordSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = ((_isRecovery)? ([NSString stringWithFormat:@"回收箱(%d)", _dataSourceShow.count]) : (@"请选择微信提醒项目"));
    self.bottomB.titleLabel.text = ((_isRecovery)? (@"恢复提醒") : (@"发送维保提醒"));
    [self.bottomB setTitle:((_isRecovery)? (@"恢复提醒") : (@"发送维保提醒")) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceShow.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHworkbordSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDataSource:_dataSourceShow[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item = _dataSourceShow[indexPath.row];
    if (item[@"sel"]) {
        [item removeObjectForKey:@"sel"];
    }else{
        [item setObject:@"" forKey:@"sel"];
    }
    [tableView reloadData];
}

- (IBAction)sendAction:(id)sender {
    
    if (_isRecovery) {
        if (_dataSourceShow.count == 0) {
            [MBProgressHUD showError:@"没有要恢复提醒的项目"];
            return;
        }
        __block NSMutableArray *tempAr = [@[]mutableCopy];
        for (NSDictionary *item in _dataSourceShow) {
            if (item[@"sel"]) {
                [tempAr addObject:item[@"id"]];
            }
        }
        
        if (tempAr.count == 0) {
            [MBProgressHUD showError:@"请选择恢复项目"];
            return;
        }
        __weak __typeof__(self) weakSelf = self;
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         recoverNotify:[YHTools getAccessToken]
         ids:[tempAr componentsJoinedByString:@","]
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showError:@"恢复成功" toView:weakSelf.navigationController.view];
                 [[NSNotificationCenter
                   defaultCenter]postNotificationName:notificationDustbin
                  object:Nil
                  userInfo:nil];
                 [weakSelf popViewController:nil];
             }else {
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                     [weakSelf showErrorInfo:info];
                     if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                         weakSelf.dataSourceShow = nil;
                     }
                 }
             }
             [weakSelf.tableView reloadData];
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }else{
        
        __block NSMutableArray *tempAr = [@[]mutableCopy];
        for (NSDictionary *item in _dataSourceShow) {
            if (item[@"sel"]) {
                [tempAr addObject:item[@"title"]];
            }
        }
        
        if (tempAr.count == 0) {
            [MBProgressHUD showError:@"请选择提醒项目"];
            return;
        }
        
        __weak __typeof__(self) weakSelf = self;
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         sendWechatTips:[YHTools getAccessToken]
         name:_info[@"name"] carLineName:_info[@"carLineName"] tipsItems:[tempAr componentsJoinedByString:@","] customerId:_info[@"customerId"] partnerCustomerId:_info[@"partnerCustomerId"] repairBillId:_info[@"repairBillId"]
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [MBProgressHUD showError:@"发送成功" toView:weakSelf.navigationController.view];
                 [weakSelf popViewController:nil];
             }else {
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                     [weakSelf showErrorInfo:info];
                     if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                         weakSelf.dataSourceShow = nil;
                     }
                 }
             }
             [weakSelf.tableView reloadData];
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}
@end
