//
//  YHAssignTechnicianController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/24.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHAssignTechnicianController.h"
#import "YHWenXunCell.h"
#import "YHAssignTechnicianController.h"

#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHOrderListController.h"
#import "YHOrderDetailController.h"
#import "YHSuccessController.h"
#import "YHMarkCell.h"
NSString *const notificationOrderListChange = @"YHNotificationOrderListChange";
@interface YHAssignTechnicianController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)assignAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *assignB;
@property (weak, nonatomic) IBOutlet UIView *bottonB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableLC;
@property (nonatomic)NSUInteger selIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopLC;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *heardView;
@end

@implementation YHAssignTechnicianController
@dynamic orderInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isMark) {
        _tableTopLC.constant = 70;
        _rightButton.hidden = YES;
    }else{
        _tableTopLC.constant = 0;
    }
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
    
    YHAssignTechnicianController *controller = segue.destinationViewController;
    controller.data = self.data;
    controller.orderInfo = self.orderInfo;
    controller.isMark = NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isMark) {
        NSArray *redeployRecord = _data[@"redeployRecord"];
        return redeployRecord.count;
    }else{
        NSArray *redeploy_tech_list = _data[@"redeploy_tech_list"];
        if (redeploy_tech_list.count > 0 && redeploy_tech_list) {
            return redeploy_tech_list.count;
        }
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMark) {
        NSArray *redeployRecord = _data[@"redeployRecord"];
        YHMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark" forIndexPath:indexPath];
        YHMark state = YHMarkComplete;
        if (indexPath.row == 0 && redeployRecord.count > 1) {
            state = YHMarkCurrent;
        }else if (indexPath.row == redeployRecord.count - 1) {
            state = YHMarkComplete;
        }else  if (indexPath.row == 1 && redeployRecord.count > 2) {
            state = YHMarkPreviousStepTwo;
        }else {
            state = YHMarkPreviousStep;
        }
        [cell loadDatasource:redeployRecord[redeployRecord.count - indexPath.row - 1] state:state];
        return cell;
    }else{
        NSArray *redeploy_tech_list = _data[@"redeploy_tech_list"];
        if (redeploy_tech_list.count > 0 && redeploy_tech_list) {
            YHWenXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            NSArray *redeploy_tech_list = _data[@"redeploy_tech_list"];
            NSDictionary *assign = redeploy_tech_list[indexPath.row];
            [cell loadDatasource:assign number:[NSString stringWithFormat:@"当前的工单数 %@", assign[@"initialSurvey_bill_num"]] isSel:(indexPath.row == _selIndex)];
            
            return cell;
        }else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"empty" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selIndex = indexPath.row;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isMark) {
        NSArray *redeployRecord = _data[@"redeployRecord"];
        if (redeployRecord.count == 0) {
            return 0;
        }
        return 44;
    }else{
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isMark) {
        return _heardView;
    }else{
        return nil;
    }
}

- (IBAction)assignAction:(id)sender {
    NSArray *redeploy_tech_list = _data[@"redeploy_tech_list"];
    
    if (redeploy_tech_list.count > 0 && redeploy_tech_list) {
        NSDictionary *assign = redeploy_tech_list[_selIndex];
        __weak __typeof__(self) weakSelf = self;
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         turnToSendBill:[YHTools getAccessToken]
         billId:self.orderInfo[@"id"]
         userOpenId:assign[@"userOpenId"]
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [[NSNotificationCenter
                   defaultCenter]postNotificationName:notificationOrderListChange
                  object:Nil
                  userInfo:nil];
                 
                 [MBProgressHUD showSuccess:@"指派成功" toView:self.navigationController.view];
                 
                 __strong __typeof__(self) strongSelf = weakSelf;
                 [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[YHOrderListController class]]) {
                         [strongSelf.navigationController popToViewController:obj animated:YES];
                         *stop = YES;
                     }
                 }];
                 
                 //                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 //                 YHSuccessController *controller = [board instantiateViewControllerWithIdentifier:@"YHSuccessController"];
                 //                 NSMutableDictionary *billStatus =  [self.orderInfo mutableCopy];
                 //                 [billStatus addEntriesFromDictionary:info[@"billStatus"]] ;
                 //                 controller.orderInfo = billStatus;
                 //                 controller.titleStr = @"提交成功";
                 //                 [self.navigationController pushViewController:controller animated:YES];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     [weakSelf showErrorInfo:info];
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
    //    if (_assigned) {
    //        __block NSMutableArray *assign = [@[]mutableCopy];
    //        [_assignInfos enumerateObjectsUsingBlock:^(NSDictionary *assignInfo, NSUInteger idx, BOOL * _Nonnull stop) {
    //            [assign addObject:@{@"userOpenId" : assignInfo[@"userOpenId"],
    //                                @"billType" : assignInfo[@"billType"]
    //                                }];
    //        }];
    //
    //        [MBProgressHUD showMessage:@"登录中..." toView:self.view];
    //         __weak __typeof__(self) weakSelf = self;
    //        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
    //         saveCheckCar:[YHTools getAccessToken]
    //         checkCarVal:_flags
    //         assign:assign
    //         billId:self.orderInfo[@"id"]
    //         onComplete:^(NSDictionary *info) {
    //
    //             [MBProgressHUD hideHUDForView:self.view];
    //             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
    //                 _successView.hidden = NO;
    //                 weakSelf.title = @"指派成功";
    //                 weakSelf.timer=  [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(timeout:) userInfo:nil repeats:YES];
    //                 weakSelf.times = 8;
    //                 [weakSelf.timer fire];
    //
    //             }else{
    //                 if(![weakSelf networkServiceCenter:info[@"code"]]){
    //                     YHLogERROR(@"");
    //                 }
    //             }
    //
    //         } onError:^(NSError *error) {
    //             [MBProgressHUD hideHUDForView:self.view];;
    //         }];
    //        
    //    }
}

- (IBAction)selAction:(id)sender {
}
@end
