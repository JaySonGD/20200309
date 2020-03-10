//
//  YTCounterController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTCounterController.h"
#import "YTTopupViewController.h"
#import "YHWebFuncViewController.h"

#import "UIView+add.h"
#import "YTCounterCell.h"
#import "YTMobileCell.h"
#import "YHCarPhotoService.h"
#import "YTPayModeInfo.h"
#import "WXPay.h"
#import "YTDiscountCell.h"
#import "AppDelegate.h"

#import <MJExtension.h>

@interface YTCounterController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) YTPayModeInfo *model;
@property (nonatomic, weak) UITextField *phoneNumberTft;
@property (weak, nonatomic) IBOutlet UILabel *pushSmsStatusMsgLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushSmsStatusMsgViewH;
@end

@implementation YTCounterController
- (IBAction)pushSmsCloseAction:(UIButton *)sender {
    self.pushSmsStatusMsgViewH.constant = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // isVerifier = YES 没有工单关闭权限  NO 有关闭工单权限
    BOOL isVerifier = NO;
    
    if(![self.billType isEqualToString:@"AirConditioner"] && !isVerifier && self.buy_type != 4){
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭工单" style:UIBarButtonItemStylePlain target:self action:@selector(closeToOrder)];
        
    }
    if (self.code) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YTCounterCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YTMobileCell" bundle:nil] forCellReuseIdentifier:@"YTMobileCell"];
    [self.tableView registerClass:[YTDiscountCell class] forCellReuseIdentifier:@"YTDiscountCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;


}

- (void)closeToOrder{
    
    self.orderInfo = @{@"id":self.billId};
    [self endBill:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData];
}

- (void)loadData{
    
//    NSInteger buy_type = self.buy_type;
//    if ([self.billType isEqualToString:@"AirConditioner"]) {
//        buy_type = buy_type ? 3 : 0;
//    }
    
    NSString *bill_sort = [self.billType isEqualToString:@"AirConditioner"]? @"2":nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] getPayModeInfo:self.billId
                        parts_suggestion_id:self.parts_suggestion_id
                                   buy_type:self.buy_type
                                  bill_sort:bill_sort
                                        vin:self.vin
                                       code:self.code
                                    success:^(YTPayModeInfo *model) {
                                        
                                        if (model.pay_status) {
                                            [self pushReport];
                                            return ;
                                        }
                                        
                                        [model.pay_mode enumerateObjectsUsingBlock:^(YTPayMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            if ([obj.type isEqualToString:@"ORG_POINTS"]) {
                                                obj.org_point = model.org_point;
                                            }
                                            if ([obj.type isEqualToString:@"OTHER_ORG_POINTS"]) {
                                                obj.org_point = model.org_point;
                                            }
                                            
                                        }];
                                        
//                                        YTDiscount *d = [YTDiscount new];
//                                        d.discount_name = @"444";
//                                        d.discount_price = @"444";
//
//                                        YTDiscount *d1 = [YTDiscount new];
//                                        d1.discount_name = @"444";
//                                        d1.discount_price = @"444";
//
//                                        model.discount_info = @[d,d1];
//                                        model.total_price = @"-12200.00";
//                                        model.pushSmsStatusMsg = @"66";
//                                        model.mobile = nil;//@"";
//                                        model.pay_mode = @[];

                                        
                                        self.pushSmsStatusMsgLB.text = model.pushSmsStatusMsg;
                                        self.pushSmsStatusMsgViewH.constant =  IsEmptyStr(model.pushSmsStatusMsg)? 0 : 44;
                                        self.model = model;
                                        [self.tableView reloadData];
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        
                                    } failure:^(NSError *error) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }];
    
}

- (void)popViewController:(id)sender{
//    if ([self.billType isEqualToString:@"J005"]) {
//        NSMutableArray *newVC = [NSMutableArray array];
//        NSMutableArray *controllers =  self.navigationController.viewControllers.mutableCopy;
//        
//        [newVC addObject:controllers.firstObject];
//        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
//        
//        NSString *urlString = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@"/jns/index.html?token=%@&bill_id=%@&jnsAppStep=J005_list&bill_type=%@&status=ios&#/appToH5",[YHTools getAccessToken],self.billId,self.billType];
//        controller.urlStr = urlString;
//        controller.barHidden = YES;
//        [newVC addObject:controller];
//        [self.navigationController setViewControllers:newVC];
//        return;
//    }
    
    [super popViewController:sender];
}


- (void)pushReport{
    
    //单次购买为：combo_personal
    //套餐购买为：combo
    if (!IsEmptyStr(self.code) && ![self.code isEqualToString:@"combo_personal"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    if ([self.code isEqualToString:@"combo_personal"]) {
        
        __block YHWebFuncViewController *vc = nil;
        NSArray *viewControllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
        [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
                vc = obj;
                [vc toH5:@{@"jnsAppStep":@"payOrder",@"code":self.code,@"vin":self.vin? :@""}];
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
        return;
    }

    

    if(self.block){
        self.block();
    }
    
    if(self.buy_type == 3 || self.buy_type == 4 || self.buy_type == 5){
        [self popViewController:nil];
        return;
    }
    
    if([self.billType isEqualToString:@"AirConditioner"]){
        
        if(self.buy_type){//说明从未支付过来
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSucToloadData) name:@"notificationSucToloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationPaySucToloadData" object:nil];
            return;
        }
    }
    
    if (!IsEmptyStr(self.parts_suggestion_id)) {
        [self popViewController:nil];
        !(_paySuccessBlock)? : _paySuccessBlock(self.parts_suggestion_id);
        
        return;
    }
    
   {
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    
       AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

        NSString *h5Source = app.h5Source;
       
       if (!IsEmptyStr(h5Source)) {
           h5Source = [NSString stringWithFormat:@"homeToCheck=%@&",h5Source];
       }else{
           h5Source = @"";
       }

       
        NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=%@_report&status=ios&%@#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId,self.billType,h5Source];
       app.h5Source = @"";

       if([self.billType isEqualToString:@"J002"]){
           
        urlString = [NSString stringWithFormat:@"%@%@/car_check_report.html?token=%@&billId=%@&status=ios&history=1",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], self.billId];
           
       }else if ([self.billType isEqualToString:@"AirConditioner"]){
       
       urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios&#/aiSolution/airConditionerReport?order_id=%@",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId];
       }else if([self.billType isEqualToString:@"J009"]) {
           
        urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStatus=ios&jnsAppStep=J009_report&%@#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId,h5Source];
           
       }
       
        __block BOOL isBack;
       NSMutableArray *vcs = [NSMutableArray array];
       [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
           [vcs addObject:obj];
           if ([obj isKindOfClass:NSClassFromString(@"YHOrderListController")]) {
               [[NSNotificationCenter
                 defaultCenter] postNotificationName:@"YHNotificationOrderListChange" object:Nil userInfo:nil];
               //[self.navigationController popToViewController:obj animated:YES];
               *stop = YES;
               isBack = YES;
           }
       }];
       
       if(!isBack){
           vcs = [NSMutableArray array];
           [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
               [vcs addObject:obj];
               if([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]){
                   *stop = YES;
               }
               
           }];
       }
       

       [vcs addObject:controller];
       controller.urlStr = urlString;
       controller.barHidden = YES;
       self.navigationController.viewControllers = vcs;
       return;
       
       //YHOrderListController
       NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:10];
       __block BOOL isHave;
       [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
           [viewControllers addObject:obj];
           if([obj isKindOfClass:NSClassFromString(@"YHOrderDetailNewController")] || [obj isKindOfClass:NSClassFromString(@"YTOrderDetailNewController")] ){//有详情页只去掉信息确认页
               *stop = YES;
           }
           
           
       }];
       
       if([viewControllers containsObject:self]
          || [self.billType isEqualToString:@"AirConditioner"]
          || [self.billType isEqualToString:@"J005"]
          || [self.billType isEqualToString:@"J007"]
          || [self.billType isEqualToString:@"J009"]){
           viewControllers = [NSMutableArray arrayWithCapacity:10];
           [viewControllers addObject:self.navigationController.viewControllers.firstObject];
       }
       
       if([self.billType isEqualToString:@"J004"]){
           
           [self.navigationController.viewControllers.reverseObjectEnumerator.allObjects enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
               if([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]){
                   [viewControllers addObject:obj];
                   [obj appToH5:nil];
                   self.navigationController.viewControllers = viewControllers;
                   *stop = YES;
               }
               
           }];
           return;
       }
       
       [viewControllers addObject:controller];
       controller.urlStr = urlString;
       controller.barHidden = YES;
       self.navigationController.viewControllers = viewControllers;
    }
 
}

- (void)notificationSucToloadData{
    NSArray *viewControllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"YTOrderDetailNewController")]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

- (void)app2H5{
    
    __block YHWebFuncViewController *vc = nil;
    if (!self.isReloadH5) {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHOrderListController")]) {
                [[NSNotificationCenter
                  defaultCenter] postNotificationName:@"YHNotificationOrderListChange" object:Nil userInfo:nil];
                vc = obj;
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
    }
    
    if (!vc) {
        
        NSArray *viewControllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
        [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHWebFuncViewController")]) {
                vc = obj;
                NSString *json = [@{@"jnsAppStatus":@"ios",@"jnsAppStep":@"payOrder",@"bill_id":self.billId,@"bill_type":self.billType} mj_JSONString];
                [vc appToH5:json];
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
    }
    
    if (!vc) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (IBAction)determinePay:(UIButton *)sender {
    
    
    __block YTPayMode *mode = nil;
    
    [self.model.pay_mode enumerateObjectsUsingBlock:^(YTPayMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            mode = obj;
            *stop = YES;
        }
    }];
    
    if (self.model.pay_mode.count && !mode) {
        [MBProgressHUD showError:@"请选择支付方式！"];
        return;
    }
    
    NSString *phoneNumber = nil;
    
    if(self.model.mobile){
    
        if(self.phoneNumberTft.text.length != 11) {
                        [MBProgressHUD showError:@"手机号码有误！"];
                return;
        }
        
        phoneNumber = self.phoneNumberTft.text;
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[YHCarPhotoService new] determinePayMode:self.billId
                                      payType:mode.type
                                       mobile:phoneNumber
                                     buy_type:self.buy_type
                          parts_suggestion_id:self.parts_suggestion_id
                                    bill_sort:[self.billType isEqualToString:@"AirConditioner"] ? @"2":nil
                                          vin:self.vin
                                         code:self.code
                                      success:^(NSDictionary *obj) {
                                          
                                          if (!obj) {
                                              [MBProgressHUD hideHUDForView:self.view];
                                              
                                              if([mode.type isEqualToString:@"OWNER"]){//跳转h5付款二维码页面
                                                  
                                                  YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                                                  
                                                  NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@#/bill/ownerQrCodePay?bill_id=%@&jnsAppStatus=ios",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId];
                                                  controller.urlStr = urlString;
                                                  controller.barHidden = YES;
                                                  [self.navigationController pushViewController:controller animated:YES];
                                        
                                                  
                                                  return;
                                              }
                                              
                                              
                                              NSString *msg = (self.parts_suggestion_id || self.buy_type == 3 || self.isReloadH5  || self.buy_type == 5)? @"支付成功！" :((self.buy_type == 4)? @"发送成功":@"推送成功！");
                                              //[MBProgressHUD showError:(self.parts_suggestion_id || self.buy_type == 3) ? @"购买成功": @"推送成功！"];
                                              [MBProgressHUD showError:msg];

                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  [self pushReport];
                                              });
                                              return ;
                                          }
                                          
                                          //
                                          [[WXPay sharedWXPay] payByParameter:obj success:^{
                                              [MBProgressHUD showError:@"支付成功！"];
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  [self pushReport];
                                              });
                                          } failure:^{
                                              [MBProgressHUD hideHUDForView:self.view];
                                              [MBProgressHUD showError:@"支付失败！"];
                                          }];
                                          
                                          
                                      } failure:^(NSError *error) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                      }];
    
    return;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if(IsEmptyStr(self.model.product_name)) return nil;
        //if(!self.model.discount_info.count) return nil;
    }
    if (section == 1) {
        if(!self.model.pay_mode.count) return nil;
    }
    if (section == 2) {
        if(!self.model.mobile) return nil;
    }

    
    UIView *header = [UIView new];
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(10, 10, screenWidth-20, 44)];
    [header addSubview:title];
    title.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 34)];
    [title addSubview:titleLB];
    titleLB.font = [UIFont systemFontOfSize:17];
    
    [title setRounded:title.bounds corners:UIRectCornerTopRight|UIRectCornerTopLeft radius:10];
    
    if (section == 1) {
        titleLB.text = @"选择支付方式";
    }else if (section == 0) {
        titleLB.text = @"订单信息";
    }else if (section == 2){
        titleLB.text = @"推送手机号";
    }
    
    return header;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        if(IsEmptyStr(self.model.product_name)) return nil;
        //if(!self.model.discount_info.count) return nil;
    }
    if (section == 1) {
        if(!self.model.pay_mode.count) return nil;
    }
    if (section == 2) {
        if(!self.model.mobile) return nil;
    }

    UIView *footer = [UIView new];
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(10, -20, screenWidth-20, 25)];
    [footer addSubview:title];
    footer.clipsToBounds = YES;
    title.backgroundColor = [UIColor whiteColor];
    
    [title setRounded:title.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return IsEmptyStr(self.model.product_name)? CGFLOAT_MIN:5;
        //return (self.model.discount_info.count? 5:CGFLOAT_MIN);
    }
    if (section == 1) {
        return (self.model.pay_mode.count? 5:CGFLOAT_MIN);
    }
    if (section == 2) {
        return (self.model.mobile? 5:CGFLOAT_MIN);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return IsEmptyStr(self.model.product_name)? CGFLOAT_MIN:54;

        //if(self.model.discount_info.count) return 54;
        //return CGFLOAT_MIN;
    }
    if (section == 1) {
        if(self.model.pay_mode.count) return 54;
        return CGFLOAT_MIN;
    }
    if (section == 2) {
        if(self.model.mobile) return 54;
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return self.model.mobile? 44 : CGFLOAT_MIN;
    }
    
    if (indexPath.section == 0) {
        return IsEmptyStr(self.model.product_name)? CGFLOAT_MIN:(16+16+(self.model.discount_info.count+1) * 28 + 0.5+12);
        //return self.model.discount_info.count? (16+16+(self.model.discount_info.count+1) * 28 + 0.5+12): CGFLOAT_MIN;
    }

    
    YTPayMode *model = self.model.pay_mode[indexPath.row];
    CGFloat cellHeight = model.totalHeight;
    if (cellHeight) {
        return model.isSelect? model.totalHeight : model.height;
    }
    
    YTCounterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    model.totalHeight = [cell rowHeight:model];
    
    model.height = 34;
    
    
    return model.isSelect? model.totalHeight : model.height;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        YTDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTDiscountCell"];
        cell.model = self.model;
        return cell;
    }

    
    if (indexPath.section == 2) {
        
        YTMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTMobileCell"];
        cell.mobileTF.text = self.model.mobile;
        self.phoneNumberTft = cell.mobileTF;
        cell.mobileTfBlock = ^(NSString * _Nonnull mobile) {
             self.model.mobile = mobile;
        };
        return cell;
    }
    //section == 1
    YTCounterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.model.pay_mode[indexPath.row];
    cell.topupBlock = ^{
        YTTopupViewController *vc = [[UIStoryboard storyboardWithName:@"Car" bundle:nil] instantiateViewControllerWithIdentifier:@"YTTopupViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.selectBlock = ^(YTPayMode * model) {
        [self.model.pay_mode enumerateObjectsUsingBlock:^(YTPayMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj != model) {
                obj.isSelect = NO;
            }
        }];
        [self.tableView reloadData];
    };
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return self.model.pay_mode.count;
    }

    if (section == 2) {
        return 1;
    }

    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;

}




@end
