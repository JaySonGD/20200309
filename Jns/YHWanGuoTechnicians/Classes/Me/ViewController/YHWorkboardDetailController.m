//
//  YHWorkboardDetailController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkboardDetailController.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "IQTextView.h"
#import "YHWorkbordNoticeCell.h"
#import "YHWorkbordRecordCell.h"
#import "YHWorkbordOrderCell.h"
#import "YHWorkbordSelectController.h"
#import "UIAlertView+Block.h"
#import "YHOrderDetailController.h"
#import "YHWorkbordNewController.h"
#import "AppDelegate.h"
#import "UITableView+FDTemplateLayoutCell.h"

NSString *const notificationDustbin = @"YHNotificationDustbin";

@interface YHWorkboardDetailController ()

@property (strong, nonatomic)NSArray *dataSourceShow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)saveAction:(id)sender;
@property (nonatomic)YHWorkbordModel model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopLC;
@property (weak, nonatomic) IBOutlet UIButton *saveB;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *carNameL;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *updateDateL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
- (IBAction)unremindActions:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *vinL;
@property (strong, nonatomic)NSDictionary *info;
- (IBAction)menuActions:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menuB1;
@property (weak, nonatomic) IBOutlet UIButton *menuB2;
@property (weak, nonatomic) IBOutlet UIButton *menuB3;
@property (weak, nonatomic) IBOutlet UIView *menuLine1;
@property (weak, nonatomic) IBOutlet UIView *menuLine2;
@property (weak, nonatomic) IBOutlet UIView *menuLine3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomRightBWidthLC;
@property (weak, nonatomic) IBOutlet UILabel *timeFL;
- (IBAction)sendWeiXinAction:(id)sender;
- (IBAction)newWorkbordAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *recycleBox;
- (IBAction)recycleAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomBView;

//客户ID(记录客户养车管理)
@property (nonatomic, strong) NSDictionary *customerId;

@end

@implementation YHWorkboardDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (UIViewController *VC in self.navigationController.viewControllers) {
        NSLog(@"-----=====>%@<======-----",VC);
    }
//    [self initUI];

    [self initNot];
    
    [self loadDatessource:YHWorkbordModelNotice];
    
    self.saveB.layer.borderColor  = YHNaviColor.CGColor;
    self.saveB.layer.borderWidth  = 1;
    self.textView.layer.borderColor  = YHLineColor.CGColor;
    self.textView.layer.borderWidth  = 1;
    self.bottomBView.layer.borderColor  = YHNaviColor.CGColor;
    self.bottomBView.layer.borderWidth  = 1;
    self.textView.placeholder = @"请填写回访结果内容";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initUI{
    
    //(1)客户养车管理
    if (self.isTubeCarPush == YES)
    {
        self.navigationItem.title = @"客户养车管理详情";
    }
    //(2)工作板详情
    else
    {
        self.navigationItem.title = @"工作板详情";
    }
}

- (void)initNot{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationDustbin:) name:notificationDustbin object:nil];
}

- (void)notificationDustbin:(NSNotification*)notice{
    [self loadDatessource:YHWorkbordModelNotice];
}

 #pragma mark - Navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     YHWorkbordNewController *controller =segue.destinationViewController;
     controller.uesrInfo = _info;
 }
 

#pragma mark - 1.工作板进来的用户详情接口
- (void)reupdataDatasource
{
    __weak __typeof__(self) weakSelf = self;
   
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    //（1）客户养车管理
    if (self.isTubeCarPush == YES) {
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]workboardCustomerDetail:[YHTools getAccessToken]
                                                                            vin:self.vin
                                                                     onComplete:^(NSDictionary *info)
        {
            NSLog(@"---===1.客户养车管理进来的用户详情接口:%@===---",info);
            [MBProgressHUD hideHUDForView:self.view];
            if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                NSArray *data = info[@"data"];
                if (data.count != 0) {
                    NSDictionary *item = data[0];
                    weakSelf.info = item;
                    weakSelf.carNameL.text = EmptyStr(item[@"carName"]);
                    weakSelf.vinL.text = EmptyStr(item[@"vin"]);
                    weakSelf.userNameL.text = EmptyStr(item[@"name"]);
                    weakSelf.phoneL.text = EmptyStr(item[@"phone"]);
                    weakSelf.timeFL.hidden = IsEmptyStr(item[@"lastFollowUp"]);
                    weakSelf.updateDateL.hidden = IsEmptyStr(item[@"lastFollowUp"]);
                    weakSelf.updateDateL.text = EmptyStr(item[@"lastFollowUp"]);
                    
                    if (![item[@"partnerCustomerId"] isEqualToString:@""] && item[@"partnerCustomerId"]) {
                        _bottomRightBWidthLC.constant = (screenWidth - 24 ) / 2;
                    }else{
                        _bottomRightBWidthLC.constant = (screenWidth - 24 );
                    }
                    NSArray *businessTips = item[@"businessTips"];
                    NSMutableArray *tempAr = [@[]mutableCopy];
                    [businessTips enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([item[@"isDel"] isEqualToString:@"0"]) {
                            [tempAr addObject:item];
                        }
                    }];
                    weakSelf.dataSourceShow = tempAr;
                }
                
            }else {
                if(![weakSelf networkServiceCenter:info[@"code"]]){
                    YHLog(@"");
                    if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                        [weakSelf showErrorInfo:info];
                        weakSelf.dataSourceShow = nil;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        }];
        
    //（2）工作板详情
    } else {
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]workboardCustomerDetail:[YHTools getAccessToken]
                                                                    workBoardId:_wordbordInfo[@"id"]
                                                                     onComplete:^(NSDictionary *info)
         {
             NSLog(@"---===1.工作板进来的用户详情接口:%@===---",info);
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSArray *data = info[@"data"];
                 if (data.count != 0) {
                     NSDictionary *item = data[0];
                     weakSelf.info = item;
                     weakSelf.carNameL.text = EmptyStr(item[@"carName"]);
                     weakSelf.vinL.text = EmptyStr(item[@"vin"]);
                     weakSelf.userNameL.text = EmptyStr(item[@"name"]);
                     weakSelf.phoneL.text = EmptyStr(item[@"phone"]);
                     weakSelf.timeFL.hidden = IsEmptyStr(item[@"lastFollowUp"]);
                     weakSelf.updateDateL.hidden = IsEmptyStr(item[@"lastFollowUp"]);
                     weakSelf.updateDateL.text = EmptyStr(item[@"lastFollowUp"]);
                     
                     if (![item[@"partnerCustomerId"] isEqualToString:@""] && item[@"partnerCustomerId"]) {
                         _bottomRightBWidthLC.constant = (screenWidth - 24 ) / 2;
                     }else{
                         _bottomRightBWidthLC.constant = (screenWidth - 24 );
                     }
                     NSArray *businessTips = item[@"businessTips"];
                     NSMutableArray *tempAr = [@[]mutableCopy];
                     [businessTips enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
                         if ([item[@"isDel"] isEqualToString:@"0"]) {
                             [tempAr addObject:item];
                         }
                     }];
                     weakSelf.dataSourceShow = tempAr;
                 }
                 
             }else {
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                     if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                         [weakSelf showErrorInfo:info];
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

#pragma mark - 2.最近工单
- (void)reupdataDatasourceOrder
{
    __weak __typeof__(self) weakSelf = self;
    
    NSString *vin;
    
    //(1)客户养车管理
    if (self.isTubeCarPush == YES)
    {
        vin = self.vin;
    }
    //(2)工作板详情
    else
    {
        vin = _wordbordInfo[@"vin"];
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]recentlyBill:[YHTools getAccessToken]
                                                             vin:vin
                                                      customerId:nil
                                                      onComplete:^(NSDictionary *info) {
          NSLog(@"---===2.回访列表:%@===---",info);
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             weakSelf.dataSourceShow = info[@"data"];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     [weakSelf showErrorInfo:info];
                     weakSelf.dataSourceShow = nil;
                 }
             }
         }
         [weakSelf.tableView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark - 3.回访列表(wordbordInfo通过业务提醒接口来获取)
- (void)reupdataDatasourceReord
{
    __weak __typeof__(self) weakSelf = self;
    
    NSString *customerId;
    
    //(1)客户养车管理
    if (self.isTubeCarPush == YES)
    {
        customerId = self.info[@"customerId"];
    }
    //(2)工作板详情
    else
    {
        customerId = _wordbordInfo[@"customerId"];
    }

    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]followUpList:[YHTools getAccessToken]
                                                      customerId:customerId
                                                            page:nil
                                                        pagesize:nil
                                                      onComplete:^(NSDictionary *info) {
          NSLog(@"---===3.回访列表:%@===---",info);
          [MBProgressHUD hideHUDForView:self.view];
          if (((NSNumber*)info[@"code"]).integerValue == 20000) {
              NSDictionary *data = info[@"data"];
              weakSelf.dataSourceShow = data[@"list"];
          }else {
              if(![weakSelf networkServiceCenter:info[@"code"]]){
                  YHLog(@"");
                  if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                      [weakSelf showErrorInfo:info];
                      weakSelf.dataSourceShow = nil;
                  }
              }
          }
          [weakSelf.tableView reloadData];
      } onError:^(NSError *error) {
          [MBProgressHUD hideHUDForView:self.view];
      }];
}

#pragma mark - ===============================tableView代理方法=================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceShow.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_model == YHWorkbordModelNotice) {
        YHWorkbordNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notice" forIndexPath:indexPath];
        [cell loaddataSource:_dataSourceShow[indexPath.row] inde:indexPath.row];
        return cell;
    }else if (_model == YHWorkbordModelOrder) {
        YHWorkbordOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order" forIndexPath:indexPath];
        [cell loaddataSource:_dataSourceShow[indexPath.row]];
        return cell;
    } else  if (_model == YHWorkbordModelRecord) {
        YHWorkbordRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"record" forIndexPath:indexPath];
        [cell loaddataSource:_dataSourceShow[indexPath.row] index:indexPath.row];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_model == YHWorkbordModelNotice) {
    }else if (_model == YHWorkbordModelOrder) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHOrderDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderDetailController"];
        controller.functionKey = YHFunctionIdHistoryWorkOrder;
        //        NSString *billStatus = orderInfo[@"billStatus"];
        //        if ([billStatus isEqualToString:@"complete"] || [billStatus isEqualToString:@"close"]) {
        //            controller.functionKey = YHFunctionIdHistoryWorkOrder;
        //        }
        controller.orderInfo = _dataSourceShow[indexPath.row];
        controller.isPop2Root = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }else  if (_model == YHWorkbordModelRecord) {
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_model == YHWorkbordModelNotice) {
        return 60;
    }else if (_model == YHWorkbordModelOrder) {
        return 120;
    }else  if (_model == YHWorkbordModelRecord) {
        float h =[tableView fd_heightForCellWithIdentifier:@"record" configuration:^(YHWorkbordRecordCell* cell) {
            [cell loaddataSource:_dataSourceShow[indexPath.row] index:indexPath.row];
        }];
        return h;
    }
    return 0;
}

#pragma mark - 业务提醒、最近工单、回访记录按钮点击事件
- (IBAction)menuActions:(UIButton*)sender
{
    _model = sender.tag;
    if (_model == YHWorkbordModelOrder
        || _model == YHWorkbordModelRecord) {
        NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
        NSDictionary *data = userInfo[@"data"];
        NSArray *menuList = data[@"menuList"];
        BOOL isExistenceE = NO;
        for (NSDictionary *menuItem in menuList) {
            if([menuItem[@"id"] isEqualToString:@"2c9180825f28010d015f324b55fe0cb0"]){
                isExistenceE = YES;
                break;
            }
        }
        if(!isExistenceE){
            [MBProgressHUD showError:@"您无权操作，请联系管理员"];
            return;
        }
    }
    
    [self loadDatessource:_model];
}

- (void)loadDatessource:(YHWorkbordModel)model
{
    //(1)客户养车管理
    if (self.isTubeCarPush == YES)
    {
        self.navigationItem.title = @"客户养车管理详情";
    }
    //(2)工作板详情
    else
    {
        self.navigationItem.title = @"工作板详情";
    }
    
    [@[_menuB1,_menuB2,_menuB3]enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTitleColor:((idx == model) ? (YHNaviColor) : (YHCellColor)) forState:UIControlStateNormal];
    }];
    
    [@[_menuLine1,_menuLine2,_menuLine3]enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.hidden = !(idx == model);
        //        [view setBackgroundColor:((idx == model) ? (YHNaviColor) : (YHCellColor))];
    }];
    
    if (model == YHWorkbordModelNotice) {
        [self reupdataDatasource];
        _tableTopLC.constant = 1 + 70;
        _recycleBox.hidden = NO;
    }else if (model == YHWorkbordModelOrder) {
        [self reupdataDatasourceOrder];
        _tableTopLC.constant = 1;
        _recycleBox.hidden = YES;
    }else  if (model == YHWorkbordModelRecord) {
        [self reupdataDatasourceReord];
        _recycleBox.hidden = YES;
        _tableTopLC.constant = 1 + 140;
    }
}

- (IBAction)saveAction:(id)sender {
    if ([_textView.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写回访结果内容"];
        return;
    }
    
    
    NSString *customerId;
    //(1)客户养车管理
    if (self.isTubeCarPush == YES)
    {
        customerId = self.info[@"customerId"];
    }
    //(2)工作板详情
    else
    {
        customerId = _wordbordInfo[@"customerId"];
    }
    
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]addCustomerFollowUp:[YHTools getAccessToken]
                                                             customerId:customerId
                                                                 result:_textView.text
                                                             onComplete:^(NSDictionary *info)
     {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [weakSelf reupdataDatasourceReord];
             weakSelf.textView.text = @"";
             [MBProgressHUD showError:@"保存成功"];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     [weakSelf showErrorInfo:info];
                     weakSelf.dataSourceShow = nil;
                 }
             }
         }
         [weakSelf.tableView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

- (IBAction)sendWeiXinAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHWorkbordSelectController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkbordSelectController"];
    //    controller.wordbordInfo = _wordbordInfo;
    controller.info = _info;
    NSMutableArray *temp = [@[]mutableCopy];
    
    NSArray *businessTips = _info[@"businessTips"];
    for (NSInteger i = 0; businessTips.count > i; i++) {
        NSDictionary *item = businessTips[i];
        if ([item[@"isDel"] isEqualToString:@"0"]){
            [temp addObject:[item mutableCopy]];
        }
    }
    controller.dataSourceShow = temp;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)newWorkbordAction:(id)sender
{
    YHWorkbordNewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWorkbordNewController"];
    controller.uesrInfo = _info;
    controller.isPushByWorkListDetail = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)recycleAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHWorkbordSelectController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkbordSelectController"];
    //    controller.wordbordInfo = _wordbordInfo;
    controller.info = _info;
    NSArray *businessTips = _info[@"businessTips"];
    NSMutableArray *temp = [@[]mutableCopy];
    for (NSInteger i = 0; businessTips.count > i; i++) {
        NSDictionary *item = businessTips[i];
        if ([item[@"isDel"] isEqualToString:@"1"]){
            [temp addObject:[item mutableCopy]];
        }
    }
    controller.dataSourceShow = temp;
    controller.isRecovery = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)unremindActions:(UIButton*)button {
    __weak __typeof__(self) weakSelf = self;
    NSDictionary *item = _dataSourceShow[button.tag];
    if (_dataSourceShow.count == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请问要取消车辆当前的所有提醒项目吗" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf noticeUndefault:item];
            }
        }];
    }else{
        [self noticeUndefault:item];
    }
}

- (void)noticeUndefault:(NSDictionary*)item{
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showMessage:@"关闭中..." toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     notifyDel:[YHTools getAccessToken]
     notifyId:item[@"id"]
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [weakSelf reupdataDatasource];
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLogERROR(@"");
                 [weakSelf showErrorInfo:info];
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

- (IBAction)recordDelAction:(UIButton*)button {
    NSDictionary *data = _dataSourceShow[button.tag];
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     delFollowUp:[YHTools getAccessToken]
     followUpId:data[@"id"]
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [weakSelf reupdataDatasourceReord];
             [MBProgressHUD showError:@"删除成功"];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     [weakSelf showErrorInfo:info];
                     weakSelf.dataSourceShow = nil;
                 }
             }
         }
         [weakSelf.tableView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}
@end
