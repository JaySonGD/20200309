//
//  YHHelpCheckViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/4/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHHelpCheckViewController.h"
#import "YHHelpCheckModel0.h"
#import "YHHelpCheckCell0.h"
#import "YHRefundReasonView.h"
#import "YHPayServiceFeeView.h"
#import "YHDetailViewController.h"
#import "YHNewOrderController.h"

#import "YHCarVersionVC.h"
#import "YHDiagnosisBaseVC.h"

#import "YHTools.h"
#import "YHCommon.h"
#import "YHNetworkManager.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "YHHelpSellService.h"

@interface YHHelpCheckViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, weak) YHRefundReasonView *refundReasonView;
@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;      //支付服务费视图

@property (nonatomic, strong) YHHelpCheckModel0 *payModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YHHelpCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.isPop) {
        self.isPop = NO;
        [self initData];
    }
}

#pragma mark - --------------------------------------一、加载UI------------------------------------------
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"icon_nodata" titleStr:@"暂无数据,下拉可刷新" detailStr:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHHelpCheckCell0" bundle:nil] forCellReuseIdentifier:@"YHHelpCheckCell0"];
}

#pragma mark - --------------------------------------二、加载数据---------------------------------------------
- (void)initData
{
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf queryData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)queryData
{
    [[YHNetworkManager sharedYHNetworkManager]requestHelpCheckListWithToken:[YHTools getAccessToken]
                                                                       Page:[NSString stringWithFormat:@"%ld",self.page]
                                                                   pageSize:@"10"
                                                                 onComplete:^(NSDictionary *info)
    {
        NSLog(@"info: %@===retMsg: %@",info,info[@"retMsg"]);
        
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            
            //1.下拉刷新,清除所有数据源,避免重复添加
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            //2.解析数据,并模型化
            NSArray *tempArray = info[@"result"][@"helpDetList"];
            for (NSDictionary *dict in tempArray) {
                YHHelpCheckModel0 *model = [YHHelpCheckModel0 mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            
            //3.Page++
            self.page += 1;

            //4.结束头尾刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            //5.刷新列表
            [self.tableView reloadData];
        } else {
            YHLogERROR(@"");
            [self showErrorInfo:info];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } onError:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - --------------------------------------tableView代理方法--------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    YHHelpCheckCell0 *cell0 = [tableView dequeueReusableCellWithIdentifier:@"YHHelpCheckCell0"];
    [cell0 refreshUIWithModel:self.dataArray[indexPath.row]];
    [cell0 setBtnClickBlock:^(UIButton *button) {
        switch (button.tag) {
            case 1://微信支付
                [weakSelf showPayServiceFeeViewWithRow:indexPath.row];
                break;
            case 2://申请退款
                [weakSelf showRefundReasonViewWithRow:indexPath.row];
                break;
            default:
                break;
        }
    }];
    
    return cell0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHHelpCheckModel0 *model = self.dataArray[indexPath.row];
    if ([model.orderStatus isEqualToString:@"1"]){
        YHDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetailViewController"];
        VC.rptCode = model.rptCode;
        VC.jumpString = @"详情";
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([model.orderStatus isEqualToString:@"6"]){
        YHDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetailViewController"];
        VC.rptCode = model.rptCode;
        VC.title = @"历史车况详情";
        VC.jumpString = @"详情";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - --------------------------------------textField代理方法--------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - --------------------------------------五、功能模块代码------------------------------------------
#pragma mark - 1.退款原因
- (void)showRefundReasonViewWithRow:(NSInteger)row
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.refundReasonView) {
        self.refundReasonView = [[NSBundle mainBundle]loadNibNamed:@"YHRefundReasonView" owner:self options:nil][0];
        self.refundReasonView.frame = CGRectMake(30, (screenHeight-200)/2 - 100, screenWidth-60, 200);
        self.refundReasonView.refundReasonTF.delegate = self;
        self.refundReasonView.layer.cornerRadius = 5;
        self.refundReasonView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.refundReasonView];
    }
    
    //点击事件
    self.refundReasonView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://取消
                [weakSelf.functionView removeFromSuperview];
                break;
            case 3://确定
            {
                YHHelpCheckModel0 *model = weakSelf.dataArray[row];
                [[YHNetworkManager sharedYHNetworkManager]applyRefundWithToken:[YHTools getAccessToken] 
                                                                            ID:model.ID
                                                                        reason:weakSelf.refundReasonView.refundReasonTF.text
                                                                    onComplete:^(NSDictionary *info) {
                    NSLog(@"info: %@===retMsg: %@",info,info[@"retMsg"]);
                    if ([info[@"retCode"] isEqualToString:@"0"]) {
                        [MBProgressHUD showSuccess:@"提交成功"];
                        [weakSelf.functionView removeFromSuperview];
                        model.orderStatus = @"3";
                        [weakSelf.tableView reloadData];
                    } else {
                        [MBProgressHUD showSuccess:info[@"retMsg"]];
                        [weakSelf.functionView removeFromSuperview];
                    }
                } onError:^(NSError *error) {
                    [MBProgressHUD showSuccess:@"提交失败"];
                    [weakSelf.functionView removeFromSuperview];
                }];
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 2.支付服务费
- (void)showPayServiceFeeViewWithRow:(NSInteger)row
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.payServiceFeeView) {
        self.payServiceFeeView = [[NSBundle mainBundle]loadNibNamed:@"YHPayServiceFeeView" owner:self options:nil][0];
        self.payServiceFeeView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.payServiceFeeView.layer.cornerRadius = 5;
        self.payServiceFeeView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.payServiceFeeView];
    }
    
    //刷新UI
    YHHelpCheckModel0 *model = self.dataArray[row];
    self.payServiceFeeView.payRemindLabel.text = @"支付检测费";
    self.payServiceFeeView.moneyLabel.text = [NSString stringWithFormat:@"检测费:%.02f元",[model.detectFee floatValue]];

    //点击事件
    self.payServiceFeeView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://微信支付
            {
                [weakSelf.payServiceFeeView.weChatPayButton setImage:[UIImage imageNamed:@"icon_wechatSelected"] forState:UIControlStateNormal];
                [weakSelf.payServiceFeeView.alipayPayButton setImage:[UIImage imageNamed:@"icon_aliPayUnSelected"] forState:UIControlStateNormal];
                weakSelf.payModel = model;
                //[weakSelf wxPay:model.ID];//(曹志)
                [weakSelf wxPayVersionTwoWithId:model.ID];//(梅文峰)
            }
                break;
            case 3://支付宝支付
            {
                [weakSelf.payServiceFeeView.weChatPayButton setImage:[UIImage imageNamed:@"icon_wechatUnSelected"] forState:UIControlStateNormal];
                //[weakSelf.payServiceFeeView.alipayPayButton setImage:[UIImage imageNamed:@"icon_aliPaySelected"] forState:UIControlStateNormal];
                [MBProgressHUD showError:@"支付宝后期开通,敬请期待"];
            }
                break;
            default:
                break;
        }
    };
}


#pragma mark - -----------------------------------------微信支付---------------------------------------------
//FIXME:  -  微信支付(梅文峰)
- (void)wxPayVersionTwoWithId:(NSString *)Id
{
    WeakSelf;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService payHelpTradeVersionTwoWithId:Id onComplete:^(NSDictionary *info) {
        weakSelf.orderId = info[@"result"][@"orderId"];
        [weakSelf payWithDict:info];
        [weakSelf.functionView removeFromSuperview];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
    }];
}

//FIXME:  -  微信支付(曹志)
- (void)wxPay:(NSString *)Id
{
    //第一步：点击微信支付后，跳转到微信客户端
    WeakSelf;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService payHelpTradeWithId:Id onComplete:^(NSString *wxPrepayId, NSString *orderId) {
        weakSelf.orderId = orderId;
        [weakSelf payByPrepayId:wxPrepayId];
        [weakSelf.functionView removeFromSuperview];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
    }];
}

//FIXME:  -  微信结果回调
- (void)tongzhi:(NSNotification *)text
{
    NSString * success = text.userInfo[@"Success"];
    if ([success isEqualToString:@"YES"]) {
        //第二步：点击“返回商家”后，回到自己App调用
        [self payCallBack];
    }else{
        [MBProgressHUD showError:@"支付失败"];
    }
}

//FIXME:  -  订单查询
- (void)payCallBack
{
    if(!self.orderId){
        return;
    }
    
    //第三步：点击“返回商家”后，回到自己App调用
    WeakSelf;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService payCallBackWithId:self.orderId onComplete:^{
        weakSelf.page = 1;
        [weakSelf initData];
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showSuccess:@"支付成功！" toView:weakSelf.view];
    } onError:^(NSError *error) {
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
    }];
}

#pragma mark - --------------------------------------三、点击事件---------------------------------------------
- (IBAction)addPush:(UIButton *)sender
{
    YHNewOrderController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHNewOrderController"];
    VC.isCar = YES;
    VC.isHelpCheck = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - ---------------------------------------四、懒加载----------------------------------------------
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
