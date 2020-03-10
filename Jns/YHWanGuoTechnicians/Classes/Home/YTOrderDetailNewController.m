//
//  YTOrderDetailNewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 30/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTOrderDetailNewController.h"
#import "YHWebFuncViewController.h"
#import "YTCounterController.h"
#import "YTDepthController.h"
#import "YHDiagnoseView.h"
#import "YTPlanCell.h"
#import "YHNoPayStatusView.h"
#import "YHCarPhotoService.h"
#import "WXPay.h"
#import <MJExtension.h>
#import "YHEditDiagnoseResultVc.h"

@interface YTOrderDetailNewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) CGFloat diagnoseHeight;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UIButton *bottomBtn;
@property (nonatomic, strong) UIView *tableFootV;
@property (nonatomic,strong) YHReportModel *feasibleModel;//保存网络可行的维修方案

@end

@implementation YTOrderDetailNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!self.diagnoseModel.reportEditStatus.integerValue){
        self.diagnoseModel.reportEditStatus = @"1";
    }
    [self setUI];
    self.feasibleModel = YHReportModel.new;
    self.feasibleModel.maintain_scheme = self.diagnoseModel.maintain_scheme.mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"notificationPaySucToloadData" object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if([self.billType isEqualToString:@"AirConditioner"]){
    [self loadData];
//    }
    [self.tableview reloadData];
}

#pragma mark --- 立即购买 ---
- (void)immediatelyPayBtnClickEvent{
    
//    [[YHCarPhotoService new] airConditionOrderPay:self.billId success:^(NSDictionary *info) {
//        
//        [[WXPay sharedWXPay] payByParameter:info success:^{
//            [MBProgressHUD showError:@"支付成功！"];
//            [self loadData];
//            [_noPayView removeFromSuperview];
//            _noPayView = nil;
//            self.tableview.hidden = NO;
//        } failure:^{
//            [MBProgressHUD showError:@"支付失败"];
//        }];
//        
//    } failure:^(NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];
    
    [self bottomClickEvent];
}



- (YHNoPayStatusView *)noPayView{
    if (!_noPayView) {
        
        CGFloat bottonMargin = iPhoneX ? 34 : 0;
        CGFloat topMargin = IphoneX ? 88 : 64;
        
        YHNoPayStatusView *noPayView = [[NSBundle mainBundle] loadNibNamed:@"YHNoPayStatusView" owner:nil options:nil].firstObject;
        [self.view addSubview:noPayView];
        [self.view bringSubviewToFront:noPayView];
        [noPayView.immediatelyPayBtn addTarget:self action:@selector(immediatelyPayBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [noPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@(topMargin));
            make.bottom.equalTo(@(bottonMargin));
        }];
        _noPayView = noPayView;
        
        self.tableview.hidden = YES;
        self.bottomBtn.hidden = YES;
        
    }
    return _noPayView;
}

- (BOOL)isNo{
    if (_isNo && !self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self loadData];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    }
    if (!_isNo && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    return _isNo;
}

- (void)popViewController:(id)sender{
    
    if ([self.billType isEqualToString:@"J009"]) {
         __block BOOL isBack;
        NSArray *viewControllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
        [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHOrderListController")]) {
                [[NSNotificationCenter
                  defaultCenter] postNotificationName:@"YHNotificationOrderListChange" object:Nil userInfo:nil];
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
                isBack = YES;
            }
        }];
        
        if(isBack)return;
    }
    
    if([self.billType isEqualToString:@"J009"]){
        [super popViewController:sender];
        return;
    }
    
    if ([self.billType isEqualToString:@"J007"] ||[self.billType isEqualToString:@"J009"])
    {
        NSMutableArray *newVC = [NSMutableArray array];
        NSMutableArray *controllers =  self.navigationController.viewControllers.mutableCopy;
        
        [newVC addObject:controllers.firstObject];
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=%@_list&bill_type=%@&status=ios&menuCode=%@&billType=%@&#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId,self.billType,self.billType,self.menuCode,self.billIdNew];
        controller.urlStr = urlString;
        controller.barHidden = YES;
        [newVC addObject:controller];
        [self.navigationController setViewControllers:newVC];
        return;
    }
    
    if([self.billType isEqualToString:@"AirConditioner"]){
        
        NSArray *viewControllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
        [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
                NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"airCondition",@"token":[YHTools getAccessToken]} mj_JSONString];
                YHWebFuncViewController *vc = (YHWebFuncViewController *)obj;
                [vc appToH5:json];
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
        return;

        
        [super popViewController:sender];
        YHWebFuncViewController *vc = [self.navigationController.childViewControllers lastObject];
        
        NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"airCondition",@"token":[YHTools getAccessToken]} mj_JSONString];
        [vc appToH5:json];
        return;
    }
    
    [super popViewController:sender];
}

- (void)getIntelligentReport:(NSString *)order_id{
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getIntelligentCheckReport:[YHTools getAccessToken] order_id:order_id onComplete:^(NSDictionary *info) {
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            
            //            "order_info": {
            //                "pay_price": "58.88", // 支付费用
            //                "pay_status": 1 // 是否支付：1支付，0未支付
            //            },
            
            NSDictionary *order_info = info[@"data"][@"order_info"];
            BOOL pay_status = [order_info[@"pay_status"] boolValue];
            if (!pay_status) { // 未支付
                self.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                NSString *title = [self.billType isEqualToString:@"AirConditioner"] ? @"马上购买" : [NSString stringWithFormat:@"马上购买（￥%@）", order_info[@"pay_price"]];
                
                [self.noPayView.immediatelyPayBtn setTitle:title forState:UIControlStateNormal];
                self.noPayView.hidden = NO;
                
                self.tableview.hidden = YES;
                self.bottomBtn.hidden = NO;
                return ;
            }
            //"reportStatus":"1", // 报告生成状态 0：未生成，1：已生成
            BOOL reportStatus =  [info[@"data"][@"reportStatus"] boolValue];
            if (!reportStatus) {
                self.isNo = YES;
                self.diagnoseModel = nil;
                [self.tableview reloadData];
                self.bottomBtn.hidden = self.isNo;
                return;
            }
            
            self.isNo = NO;
            self.diagnoseModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            
            if(!self.diagnoseModel.reportEditStatus.integerValue){
                self.diagnoseModel.reportEditStatus = @"1";
            }
            
            self.feasibleModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            self.bottomBtn.hidden = self.isNo;
            [_noPayView removeFromSuperview];
            self.tableview.hidden = self.isNo;
            [self.tableview reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSucToloadData" object:nil];
            
            return;
            
        }
        
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)getReportByBillIdV2:(NSString *)billId{

    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getReportByBillIdV2:[YHTools getAccessToken] billId:billId onComplete:^(NSDictionary *info) {
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            
            
            //            "order_info": {
            //                "pay_price": "58.88", // 支付费用
            //                "pay_status": 1 // 是否支付：1支付，0未支付
            //            },
            
            NSDictionary *order_info = info[@"data"][@"order_info"];
            BOOL pay_status = YES;// [order_info[@"pay_status"] boolValue];
            if (!pay_status) { // 未支付
                self.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                NSString *title = @"马上购买";
                
                [self.noPayView.immediatelyPayBtn setTitle:title forState:UIControlStateNormal];
                self.noPayView.hidden = NO;
                
                self.tableview.hidden = YES;
                self.bottomBtn.hidden = NO;
                return ;
            }
            
            self.diagnoseModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            if(!self.diagnoseModel.reportEditStatus.integerValue){
                self.diagnoseModel.reportEditStatus = @"1";
            }
            //"reportStatus":"1", // 报告生成状态 0：未生成，1：已生成
            BOOL reportStatus =  [info[@"data"][@"report_status"] boolValue];
//            reportStatus = NO;

            if (!reportStatus) {
                self.isNo = YES;
//                self.diagnoseModel = nil;
                [self.tableview reloadData];
                self.bottomBtn.hidden = self.isNo;
                return;
            }
            
            self.isNo = NO;
//            self.diagnoseModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            
//            if(!self.diagnoseModel.reportEditStatus.integerValue){
//                self.diagnoseModel.reportEditStatus = @"1";
//            }
            
            self.feasibleModel = [YHReportModel mj_objectWithKeyValues:info[@"data"][@"report"]];
            self.bottomBtn.hidden = self.isNo;
            [_noPayView removeFromSuperview];
            self.tableview.hidden = self.isNo;
            [self.tableview reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSucToloadData" object:nil];
            
            return;
            
        }
        
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];

}

- (void)loadData{
    
    if([self.billType isEqualToString:@"AirConditioner"]){
        [self getIntelligentReport:self.billId];
        return;
    }
    
    if([self.billType isEqualToString:@"J009"]){
        [self getReportByBillIdV2:self.billId];
        return;
    }

    
    // J005
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getDepthDiagnoseWithToken:[YHTools getAccessToken]
                                                                        billId:self.billId
                                                                    onComplete:^(NSDictionary *info) {
                                                                        
                                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
                                                                        if ([code isEqualToString:@"20000"]) {
                                                                            
                                                                            NSDictionary *data = info[@"data"];
                                                                            
                                                                            
//                                                                            BOOL pay_status = [data[@"diagnose_pay"] boolValue];
//                                                                            if (!pay_status  && [self.billType isEqualToString:@"J005"]) { // 未支付
//                                                                                self.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
//                                                                                NSString *title =  @"马上购买";
//
//                                                                                [self.noPayView.immediatelyPayBtn setTitle:title forState:UIControlStateNormal];
//                                                                                self.noPayView.hidden = NO;
//
//                                                                                self.tableview.hidden = YES;
//                                                                                self.bottomBtn.hidden = NO;
//                                                                                return ;
//                                                                            }
//                                                                            self.noPayView.hidden = YES;
//                                                                            self.tableview.hidden = NO;

                                                                            //"reportStatus":"1", // 报告生成状态 0：维修方式未生成，1：维修方式已生成
                                                                            //"reportEditStatus":"1", // 报告是否可编辑状态 0：不可编辑，1：可编辑
                                                                            //reportStatus 先判断这个状态 报告有没有出，没有就跑到你那个中间页，如果出了
                                                                            //再判断 reportEditStatus这个状态 如果为0 就跳支付页面
                                                                            
                                                                            BOOL reportStatus = [[data valueForKey:@"reportStatus"] boolValue];
                                                                            BOOL reportEditStatus = [[data valueForKey:@"reportEditStatus"] boolValue];
                                                                            
                                                                            if (reportStatus == NO) {
                                                                                //中间页
                                                                                self.isNo = YES;
                                                                                self.diagnoseModel = nil;
                                                                                [self.tableview reloadData];
                                                                                self.bottomBtn.hidden = self.isNo;
                                                                                return;
                                                                            }
                                                                            
                                                                            BOOL pay_status = [data[@"diagnose_pay"] boolValue];
                                                                            if (!pay_status  && [self.billType isEqualToString:@"J005"]) { // 未支付
                                                                                self.noPayView.diagnoseContentL.text  = @"购买报告后可以查看完整检测结果以及编辑维修方案";
                                                                                NSString *title =  @"马上购买";
                                                                                
                                                                                [self.noPayView.immediatelyPayBtn setTitle:title forState:UIControlStateNormal];
                                                                                self.noPayView.hidden = NO;
                                                                                
                                                                                self.tableview.hidden = YES;
                                                                                self.bottomBtn.hidden = NO;
                                                                                return ;
                                                                            }
                                                                            self.noPayView.hidden = YES;
                                                                            self.tableview.hidden = NO;

                                                                            
                                                                            if (!reportEditStatus) {
                                                                                //支付页面
                                                                                YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
                                                                                vc.billId = self.billId;
                                                                                vc.billType = self.billType;
                                                                                [self.timer invalidate];
                                                                                self.timer = nil;
                                                                                [self.navigationController pushViewController:vc animated:YES];
                                                                               return;
                                                                            }
                                                                            
                                                                            self.isNo = NO;
                                                                            self.diagnoseModel = [YHReportModel mj_objectWithKeyValues:data];
                                                                            if(!self.diagnoseModel.reportEditStatus.integerValue){
                                                                                self.diagnoseModel.reportEditStatus = @"1";
                                                                            }
                                                                            [self.tableview reloadData];
                                                                            [self creatFooderView];
                                                                            self.bottomBtn.hidden = self.isNo;
                                                                            return ;
                                                                        }
                                                                        
                                                                    }
                                                                       onError:^(NSError *error) {
                                                                    
                                                                           
                                                                       }];
}


-(void)creatFooderView{
    
    [self.tableview layoutIfNeeded];
    if (self.tableview.contentSize.height > self.tableview.frame.size.height) {
        [self.tableview.tableFooterView addSubview:self.tableFootV];
        [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableview.tableFooterView).offset(10);
            make.right.equalTo(self.tableview.tableFooterView).offset(-10);
        }];
        
    }else{
        
        if (self.tableview.frame.size.height - self.tableview.contentSize.height > 60) {
            CGFloat bottomMargin = iPhoneX ? 34 : 0;
            [self.view addSubview:self.tableFootV];
            [self.tableFootV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.bottom.equalTo(self.tableFootV.superview).offset(-bottomMargin);
                make.height.equalTo(@60);
            }];
            
        }else{
            
        [self.tableview.tableFooterView addSubview:self.tableFootV];
        [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableview.tableFooterView).offset(10);
            make.right.equalTo(self.tableview.tableFooterView).offset(-10);
        }];
        }
    }
}


//
//- (CGFloat)diagnoseHeight:(BOOL)isEdit{
//
//    _diagnoseHeight = 100;
//
//    NSArray *strArr = [isEdit ? self.diagnoseModel.checkResultArr.makeIdea :self.diagnoseModel.checkResultArr.makeResult componentsSeparatedByString:@"<br>"];
//    if (!strArr.count) {
//        _diagnoseHeight = 45;
//    }
//    __block int sum = 0;
//    [strArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat height = [obj boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
//        int num = ceil(height/(screenWidth-46));
//        if (num > 1) { // +行距
//            _diagnoseHeight += (num - 1)*12;
//        }
//        sum += num;
//    }];
//    _diagnoseHeight += sum *18;
//    return _diagnoseHeight;
//}

- (void)setUI{
    [self tableview];
    self.view.backgroundColor = self.tableview.backgroundColor;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    self.tableFootV = footView;
    // 底部按钮
    UIButton *bottomBtn = [[UIButton alloc] init];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.bottomBtn = bottomBtn;
    self.bottomBtn.hidden = self.isNo;
    [footView addSubview:bottomBtn];
    bottomBtn.backgroundColor = YHNaviColor;
    //[bottomBtn setTitle:[self.billType isEqualToString:@"J007"] ? @"生成报告" : @"推送车主" forState:UIControlStateNormal];
    [bottomBtn setTitle:@"生成报告" forState:UIControlStateNormal];

    bottomBtn.layer.cornerRadius = 5.0;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn addTarget:self action:@selector(bottomClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.offset(-10);
        make.bottom.offset(-10);
        make.height.equalTo(@40);
    }];
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    [self creatFooderView];
}

- (void)bottomClickEvent{
    
   //没有值就不可推送
    YTCounterController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTCounterController"];
    vc.billId = self.billId;
    vc.billType = self.billType;
    vc.buy_type = self.tableview.hidden ? ([self.billType isEqualToString:@"J009"]? 3 : 5) : 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addPlan{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *localPlans = [self.diagnoseModel.maintain_scheme filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_sys < 1"]];
        NSArray *localNames = [localPlans valueForKey:@"name"];
        
        NSInteger sysC = self.diagnoseModel.maintain_scheme.count - localPlans.count;
        NSInteger i = sysC + 1;
        while ([localNames containsObject:[NSString stringWithFormat:@"方案%ld",i]]) {
            i++;
        }
        YHSchemeModel *localPlan = [YHSchemeModel new];
        localPlan.name = [NSString stringWithFormat:@"方案%ld",i];
        localPlan.total_price = @"0.00";
        [self.diagnoseModel.maintain_scheme addObject:localPlan];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
            YTDepthController *vc =[YTDepthController new];
            vc.orderType = self.billType;
            vc.order_id = self.billId;
            vc.index = [self.diagnoseModel.maintain_scheme indexOfObject:localPlan];
            vc.reportModel = self.diagnoseModel;
            __weak typeof(self)weakSelf = self;
            vc.removeRepairCaseSuccessOperation = ^{
                [weakSelf loadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            [self.tableview reloadData];
            return;
            
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isNo ? 1 : self.diagnoseModel.reportEditStatus.integerValue + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < self.diagnoseModel.reportEditStatus.integerValue) {
        return 1;
    }else{
        return self.diagnoseModel.maintain_scheme.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section < self.diagnoseModel.reportEditStatus.integerValue)
    {
    
        if (self.isNo) {
            YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
            diagnoseCell.backgroundColor = [UIColor clearColor];
            diagnoseCell.orderType = @"J004";///test
            diagnoseCell.diagnoseTitieL.textColor = [UIColor blackColor];
            diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
            diagnoseCell.diagnoseTitieL.text = @"温馨提示";
            diagnoseCell.diagnoseTextView.textColor = [UIColor blackColor];
            diagnoseCell.diagnoseTextView.text = @"报告生成中，请稍后查询。";
            diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return diagnoseCell;
        }
        
        BOOL isEdit = self.diagnoseModel.reportEditStatus.integerValue == 2 && !indexPath.section;//诊断思路
        
        YHDiagnoseView *diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YHDiagnoseView"];
        diagnoseCell.backgroundColor = [UIColor clearColor];
        diagnoseCell.orderType = @"J004";///test
        diagnoseCell.diagnoseTitieL.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
        diagnoseCell.diagnoseTitieL.font = [UIFont systemFontOfSize:17.0];
        diagnoseCell.diagnoseTitieL.text = isEdit ? @"诊断思路" : @"诊断结果";
        
        NSString *result = [isEdit ? self.diagnoseModel.checkResultArr.makeIdea :self.diagnoseModel.checkResultArr.makeResult stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        diagnoseCell.diagnoseTextView.text = IsEmptyStr(result)? isEdit ? @"暂无诊断思路" : @"暂无诊断结果" : result;
        diagnoseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(self.diagnoseModel.reportEditStatus.integerValue == 2){
        diagnoseCell.editBlock = ^{
            YHEditDiagnoseResultVc *VC = [YHEditDiagnoseResultVc new];
            VC.type = indexPath.section + 1;
            VC.bill_id = self.billId;
            VC.diagnoseResultText = isEdit ? self.diagnoseModel.checkResultArr.makeIdea :self.diagnoseModel.checkResultArr.makeResult;
            [self.navigationController pushViewController:VC animated:YES];
        };
        }
        
        return diagnoseCell;
    }
    
    
    YTPlanCell *plancell = [tableView dequeueReusableCellWithIdentifier:@"YTPlanCell"];
    plancell.leftMargin.constant = 8.0;
    plancell.rightMargin.constant = 8.0;
    plancell.orderType = ([self.billType isEqualToString:@"J005"] || [self.billType isEqualToString:@"AirConditioner"] || [self.billType isEqualToString:@"J009"] || [self.billType isEqualToString:@"J007"]) ? self.billType : @"J002";
    plancell.selectionStyle = UITableViewCellSelectionStyleNone;
    plancell.line.hidden = (indexPath.row == self.diagnoseModel.maintain_scheme.count-1);
    
    YTPlanModel *obj = self.diagnoseModel.maintain_scheme[indexPath.row];
    obj.isOnlyOne = (self.diagnoseModel.maintain_scheme.count == 1);
    
    plancell.model = obj;
    
    
    return plancell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.diagnoseModel.reportEditStatus.integerValue){
        if (self.isNo) {
            return 84;
        }
        return UITableViewAutomaticDimension;
    }
    
    return ([self.billType isEqualToString:@"J005"] || [self.billType isEqualToString:@"J009"] || [self.billType isEqualToString:@"AirConditioner"] || [self.billType isEqualToString:@"J007"]) ? UITableViewAutomaticDimension :  100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == self.diagnoseModel.reportEditStatus.integerValue) {
        
        //if ([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"])
        {
            
            YTDepthController *vc =[YTDepthController new];
            vc.orderType = self.billType;
            vc.index = indexPath.row;
            vc.reportModel = self.diagnoseModel;
            vc.order_id = self.billId;
            __weak typeof(self)weakSelf = self;
            vc.removeRepairCaseSuccessOperation = ^{
                [weakSelf loadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            return;
            
        }
        return;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == self.diagnoseModel.reportEditStatus.integerValue) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = tableView.backgroundColor;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 40)];
        view.clipsToBounds = YES;
        UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(8, 0, screenWidth - 16, 40)];
        [view addSubview:boxV];
        [boxV setRounded:boxV.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
        boxV.backgroundColor = [UIColor whiteColor];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
        //                if (!section) {
        //                    titleLB.text = @"诊断结果";
        //                }else{
        //titleLB.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
        titleLB.text = @"维修方案";
        //                    if(self.diagnoseModel.isTechOrg && [self.diagnoseModel.nextStatusCode isEqualToString:@"initialSurveyCompletion"])
//        if(self.diagnoseModel.maintain_scheme.count < 2 && ([self.diagnoseModel.nowStatusCode isEqualToString:@"initialSurvey"] || [self.diagnoseModel.nowStatusCode isEqualToString:@"newWholeCarInitialSurvey"]))
        if(self.diagnoseModel.maintain_scheme.count < 2)

            
        {// && !IsEmptyStr(self.diagnoseModel.checkResultArr.makeResult)
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(boxV.width - 54, 10, 44, 30);
            [addBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
            addBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [addBtn setTitle:@"新增" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addPlan) forControlEvents:UIControlEventTouchUpInside];
            [boxV addSubview:addBtn];
        }
        //                }
        [boxV addSubview:titleLB];
        [bgView addSubview:view];
        return bgView;
    }
    
    return  [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    if (section == self.diagnoseModel.reportEditStatus.integerValue) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        UIView *boxV = [[UIView alloc] initWithFrame:CGRectMake(8, 0, screenWidth - 16, 10)];
        boxV.backgroundColor = [UIColor whiteColor];
        [view addSubview:boxV];
        [boxV setRounded:boxV.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
        return view;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section < self.diagnoseModel.reportEditStatus.integerValue) {
        
        return 10;
        
    }
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.diagnoseModel.reportEditStatus.integerValue) {
        return 20;
    }
    return 0.0;
}


#pragma mark - 创建tableview ---
- (UITableView *)tableview{
    
    if (!_tableview) {
        CGFloat bottonMargin = iPhoneX ? 34 : 0;
        
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        tableview.delegate = self;
        tableview.dataSource = self;
        
        [self.view addSubview:tableview];
        [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableview.superview).offset(10);
            make.left.equalTo(@0);
            make.width.equalTo(tableview.superview);
            make.bottom.equalTo(tableview.superview).offset(-bottonMargin);
        }];
        
        [tableview registerNib:[UINib nibWithNibName:@"YHDiagnoseView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YHDiagnoseView"];
        [tableview registerNib:[UINib nibWithNibName:@"YTPlanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTPlanCell"];
        
        _tableview = tableview;
    }
    
    
    return _tableview;
}
@end
