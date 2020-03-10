//
//  YHSettlementController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/7/3.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSettlementController.h"
#import "YHCommon.h"
#import "IQTextView.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"

#import "YHSuccessController.h"
#import "YHOrderListController.h"
#import "YHWebFuncViewController.h"
extern NSString *const notificationOrderListChange;
@interface YHSettlementController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)comfierAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *priceFT;
@property (weak, nonatomic) IBOutlet IQTextView *remarksTV;
- (IBAction)buttonsActions:(id)sender;
@property (nonatomic)NSUInteger selButtonIndex;
@property (weak, nonatomic) IBOutlet UIButton *weixinB;
@property (weak, nonatomic) IBOutlet UIButton *zhiFuBoaB;
@property (weak, nonatomic) IBOutlet UIButton *cashB;
@property (weak, nonatomic) IBOutlet UIButton *bankB;
@property (weak, nonatomic) IBOutlet UIButton *jiFenB;
@property (weak, nonatomic) IBOutlet UIButton *otherB;
@property (weak, nonatomic) IBOutlet UILabel *receivablePriceL;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actualTopLC;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *actualViews;

@end

@implementation YHSettlementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = (([self.orderInfo[@"billType"] isEqualToString:@"G"])? (@"结算") : (@"录入检测费"));
    CGRect frame =  _contentView.frame;
    frame.size.width = screenWidth;
    frame.size.height = 655;
    frame.origin.y = kStatusBarAndNavigationBarHeight-64;
    _contentView.frame = frame;
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:CGSizeMake(screenWidth, 655)];
    _remarksTV.placeholder = @"备注";
    [self buttonShow:_selButtonIndex];
    
    _actualTopLC.constant = ((_isChild)? (0) : (464));
    [_actualViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.hidden = _isChild;
    }];
    
    _actualPriceL.text = ((_isChild)? (@"应收金额") : (@"实收金额"));
    _receivablePriceL.text = [NSString stringWithFormat:@"¥%@元", _price];
    
    self.scrollV.backgroundColor = _contentView.backgroundColor;
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

- (IBAction)comfierAction:(id)sender {
    
    
    if (self.priceFT.text.length == 0 ) {
        
        [MBProgressHUD showError:@"请输入金额"];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     saveEndBill:[YHTools getAccessToken]
     billId:self.orderInfo[@"id"]
     payMode:((_isChild)? (nil) : (@[@"微信支付",@"支付宝支付",@"现金支付",@"银行卡／信用卡",@"会员卡／积分",@"其他"][_selButtonIndex]))
     receiveAmount:_priceFT.text
     remark:((_isChild)? (nil) : (_remarksTV.text))
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             [[NSNotificationCenter
               defaultCenter]postNotificationName:notificationOrderListChange
              object:Nil
              userInfo:nil];
              [MBProgressHUD showSuccess:@"提交成功" toView:self.navigationController.view];
             __weak __typeof__(self) weakSelf = self;
             __block BOOL isBack = NO;

             [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if ([obj isKindOfClass:[YHOrderListController class]]) {
                     [weakSelf.navigationController popToViewController:obj animated:YES];
                     *stop = YES;
                     isBack = YES;
                 }
                 
             }];
             
             if(!isBack){
                 [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
                         [weakSelf.navigationController popToViewController:obj animated:YES];
                         *stop = YES;
                         isBack = YES;
                     }
                 }];
             }

         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 [weakSelf showErrorInfo:info];
                 YHLogERROR(@"");
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

- (IBAction)buttonsActions:(UIButton*)sender {
    _selButtonIndex = sender.tag;
    [self buttonShow:sender.tag];
}

-(void)buttonShow:(NSUInteger)index{
    NSArray *buttons = @[_weixinB, _zhiFuBoaB, _cashB, _bankB, _jiFenB, _otherB];
    [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = (index == idx);
    }];
}
@end
