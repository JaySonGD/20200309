//
//  YHOrderDetailViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/30.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailViewController.h"
#import "YHNetworkManager.h"
//#import "MBProgressHUD+MJ.h"
#import "YHCommon.h"


#import "YHTools.h"
#import "UIAlertView+Block.h"
@interface YHOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLable;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLable;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *crapNameLable;
@property (weak, nonatomic) IBOutlet UILabel *crapAddrLable;
@property (weak, nonatomic) IBOutlet UILabel *telLable;
@property (strong, nonatomic)NSDictionary *orderDetail;
@property (weak, nonatomic) IBOutlet UIView *interView;
@property (weak, nonatomic) IBOutlet UIButton *interButton;
@property (weak, nonatomic) IBOutlet UIButton *singleInterButton;
@property (weak, nonatomic) IBOutlet UIButton *singleEndButton;
@property (strong,nonatomic)NSTimer *runloopTimer;
@property (weak, nonatomic) IBOutlet UIButton *enButton;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeF;
@property (weak, nonatomic) IBOutlet UIButton *reflashButton;
@property (weak, nonatomic) IBOutlet UILabel *orderStateL;
- (IBAction)reflashAction:(id)sender;
- (IBAction)endOrderAction:(id)sender;

//是否是控制器本身
@property (nonatomic, assign) BOOL isSelf;

@end

@implementation YHOrderDetailViewController
@dynamic orderInfo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isSelf = NO;

    // Do any additional setup after loading the view.
//        [self reupdataDatasource:NO];
//    [self startRunloop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.runloopTimer invalidate];
    [super viewWillDisappear:animated];
}

- (void)startRunloop{
    self.runloopTimer = [NSTimer scheduledTimerWithTimeInterval:(60. * 2)  target:self selector:@selector(timerRunloop) userInfo:nil repeats:YES];
    [self.runloopTimer fire];
}

- (void)timerRunloop{
    [self reupdataDatasource:YES];
}

- (void)loadData{
    _orderIdLable.text = _orderDetail[@"orderId"];
    _orderDetailLable.text = _orderDetail[@"orderName"];
    _orderTypeF.text = _orderDetail[@"typeName"];
    NSDate *date = [YHTools dateFromString:_orderDetail[@"bookTime"] byFormatter:@"yyyyMMddHHmmss"];
    _creatTimeLable.text = [NSString stringWithFormat:@"%@", [YHTools stringFromDate:date byFormatter:@"yyyy.MM.dd  HH:mm"]];
    _crapNameLable.text = _orderDetail[@"stationName"];
    _crapAddrLable.text = _orderDetail[@"stationAddr"];
    _telLable.text = _orderDetail[@"stationTel"];
    _orderStateL.text = _orderDetail[@"statusName"];
    NSNumber *btnFlag = _orderDetail[@"btnFlag"];
    
    NSNumber *btnNext = _orderDetail[@"btnNext"];
    _interView.hidden = NO;
    if (btnNext.boolValue) {
        _enButton.hidden = NO;
        _singleEndButton.hidden = YES;
        _interButton.hidden = NO;
        _singleInterButton.hidden = YES;
        _reflashButton.hidden = NO;
        [_interButton setTitle:@"继续服务" forState:UIControlStateNormal];
    }else if(btnFlag.boolValue){
        NSString *orderStatus = _orderDetail[@"orderStatus"];
        if ([orderStatus isEqualToString:@"stop_999"]) {
            _enButton.hidden = YES;
            _singleEndButton.hidden = YES;
            _interButton.hidden = YES;
            _singleInterButton.hidden = NO;
            _reflashButton.hidden = YES;
            [_singleInterButton setTitle:_orderDetail[@"btnName"] forState:UIControlStateNormal];
        }else{
            _enButton.hidden = NO;
            _singleEndButton.hidden = YES;
            _interButton.hidden = NO;
            _singleInterButton.hidden = YES;
            _reflashButton.hidden = NO;
            [_interButton setTitle:_orderDetail[@"btnName"] forState:UIControlStateNormal];
        }
    }else{
        NSString *orderStatus = _orderDetail[@"orderStatus"];
        _interView.hidden = [orderStatus isEqualToString:@"stop_999"];
        _enButton.hidden = YES;
        _singleEndButton.hidden = NO;
        _interButton.hidden = YES;
        _singleInterButton.hidden = YES;
        _reflashButton.hidden = YES;
    }
}

- (void)reupdataDatasource:(BOOL)isFormTimer{
    if (!isFormTimer) {
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
//    
//    NSDictionary *result = loginInfo[@"result"];
//    __weak __typeof__(self) weakSelf = self;
//    [[YHNetworkManager sharedYHNetworkManager] getOrderDetail:result[@"sessionId"] orderId:self.orderInfo[@"orderId"] onComplete:^(NSDictionary *info) {
//        NSString *retCode = info[@"retCode"];
//        [MBProgressHUD hideHUDForView:self.view];
//        if ([retCode isEqualToString:@"0"]) {
//            //
//            weakSelf.orderDetail = info[@"result"];
//            [weakSelf loadData];
//        }else{
//            [self.runloopTimer invalidate];
//            [weakSelf sso:retCode];
//        }
//    }  onError:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
//        [self.runloopTimer invalidate];
//        YHLog(@"%@", error);
//        [weakSelf netError:error];
//    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    YHMaintainViewController *controller = segue.destinationViewController;
//    [controller setOrderInfo:self.orderInfo];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    
    NSNumber *btnNext = _orderDetail[@"btnNext"];
    if (btnNext.boolValue) {
        [self stepByKey:@"member_owner_03"];
    }
    return !btnNext.boolValue;
}

- (IBAction)reflashAction:(id)sender {
    [self reupdataDatasource:NO];
}

- (IBAction)endOrderAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定关闭订单吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __block typeof(self) weakSelf = self;
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf stepByKey:@"stop_999"];
        }
    }];
}

- (void)stepByKey:(NSString*)stepKey{
//    
//    NSDictionary *result = loginInfo[@"result"];
//    __weak __typeof__(self) weakSelf = self;
//    [[YHNetworkManager sharedYHNetworkManager] updateNextStep:result[@"sessionId"] orderId:self.orderInfo[@"orderId"] stepName:stepKey onComplete:^(NSDictionary *info) {
//        NSString *retCode = info[@"retCode"];
//        //        [MBProgressHUD hideHUDForView:self.view];
//        if ([retCode isEqualToString:@"0"]) {
//            //
//            weakSelf.orderDetail = info[@"result"];
//            [weakSelf loadData];
//        }else{
//            [weakSelf sso:retCode];
//        }
//    }  onError:^(NSError *error) {
//        //        [MBProgressHUD hideHUDForView:self.view];
//        YHLog(@"%@", error);
//        [weakSelf netError:error];
//    }];
    
}
@end
