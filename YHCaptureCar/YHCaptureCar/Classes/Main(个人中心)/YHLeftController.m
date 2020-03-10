//
//  YHLeftController.m
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/3.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHLeftController.h"
#import "UIViewController+RESideMenu.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHWebFuncViewController.h"
#import "YHMyCollectController.h"

#import "YHAppIntroduceController.h"

#import "YHModifyPassWordController.h"

#import "YHReceiveMsgViewController.h"

extern NSString *const notificationReloadLoginInfo;
@interface YHLeftController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *stateB;
@property (weak, nonatomic) IBOutlet UILabel *allAmountL;
@property (weak, nonatomic) IBOutlet UILabel *frozenAmountL;
@property (weak, nonatomic) IBOutlet UILabel *allAmountFL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic)NSDictionary *result;
@property (nonatomic)YHLeftMenuActions menuKey;
@property (nonatomic, strong) NSArray <NSArray<NSDictionary *> *> *myData;

@property (nonatomic, strong) UILabel *versionLB;
@end

@implementation YHLeftController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.moneyViewHeight.constant = 0;
    
    YHLayerBorder(_stateB, [UIColor whiteColor], 1);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 52;
    self.myData = @[
                    @[
                        @{@"img":@"collect",@"title":@"我的收藏"},
                        @{@"img":@"agreement",@"title":@"用户协议"},
                        @{@"img":@"icon_AppIntroduce",@"title":@"关于捕车"},
                        @{@"img":@"icon_FeedBack",@"title":@"反馈建议"},
                        @{@"img":@"modifyPassword",@"title":@"修改密码"},
                        @{@"img":@"icon_changePhone",@"title":@"修改手机号码"}
                        ],
                    @[
                        @{@"img":@"logout",@"title":@"退出登录"},
                        ]
                    ];
    
    [self addVersion];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameL.text = [YHTools getSubName];
    [self reupdataDatasource];
}

- (void)addVersion{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    //NSString *buildVersion = [info valueForKey:@"CFBundleVersion"];
    self.versionLB.text = [NSString stringWithFormat:@"版本号：%@",version];
    

    [self.view addSubview:self.versionLB];
    [self.versionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-18-SafeAreaBottomHeight);
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.height.mas_equalTo(12);
    }];
}

- (UILabel *)versionLB{
    if (!_versionLB) {
        _versionLB = [[UILabel alloc] init];
        _versionLB.font = [UIFont systemFontOfSize:12];
        _versionLB.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00];
        _versionLB.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLB;
}

- (IBAction)logoutAction:(id)sender {
    [YHTools setAccessToken:nil];
    [self hideMenuViewController:sender];
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
}

//FIXME:   - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *model = self.myData[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.imageView.image = [UIImage imageNamed:model[@"img"]];
    cell.textLabel.text = model[@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [UIView new];
    footer.backgroundColor = tableView.backgroundColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self hideMenuViewController:nil];
                    YHMyCollectController *vc = [YHMyCollectController new];
                    vc.title = @"我的收藏";
                    [self.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    [self agreementAction];
                }
                    break;
                case 2:
                {
                    [self hideMenuViewController:nil];
                    YHAppIntroduceController *VC = [[UIStoryboard storyboardWithName:@"YHAppIntroduce" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAppIntroduceController"];
                    [self.parentViewController.childViewControllers.lastObject pushViewController:VC animated:YES];
                }
                    break;
                case 3:
                {
                    [self hideMenuViewController:nil];
                    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                    controller.urlStr = [NSString stringWithFormat:@"%s%s%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk,[NSString stringWithFormat:@"/suggestion.html?token=%@&appId=yh9gwIB5Wk2gknCaIh&status=ios",[YHTools getAccessToken]]];
                    controller.title = @"反馈建议";
                    controller.barHidden = NO;
                    [self.parentViewController.childViewControllers.lastObject pushViewController:controller animated:YES];
                }
                    break;
                case 4:
                {
                    [self hideMenuViewController:nil];
                    YHModifyPassWordController *modifyViewVC = [[YHModifyPassWordController alloc] init];
                    [self.parentViewController.childViewControllers.lastObject pushViewController:modifyViewVC animated:YES];
                }
                    break;
                case 5:
                {
                    [self hideMenuViewController:nil];
                    YHReceiveMsgViewController *controller = [[UIStoryboard storyboardWithName:@"YHChangePhone" bundle:nil] instantiateViewControllerWithIdentifier:@"YHReceiveMsgViewController"];
//                    controller.title = @"反馈建议";
//                    controller.barHidden = NO;
                    [self.parentViewController.childViewControllers.lastObject pushViewController:controller animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self logoutAction:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)userInfoActions:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(leftMenuActions: withInfo:)] && self.delegate) {
//        [self.delegate leftMenuActions:_menuKey withInfo:_result];
//    }
//    [self hideMenuViewController:sender];
}

- (IBAction)agreementAction {
    [self hideMenuViewController:nil];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/registerProtocol.html"];
    controller.barHidden = YES;
    [self.parentViewController.childViewControllers.lastObject pushViewController:controller animated:YES];
    
}

- (void)reupdataDatasource {
    
    if ([YHTools getAccessToken]) {
        //    [SVProgressHUD showWithStatus:@"登录中..."];
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkManager sharedYHNetworkManager]
         userInfo:[YHTools getAccessToken]
         onComplete:^(NSDictionary *info) {
             //         [SVProgressHUD dismiss];
             if ([info[@"retCode"] isEqualToString:@"0"]) {
                 NSDictionary *result = info[@"result"];
                 weakSelf.result = result;
                 /**
                  是否认证  0 未申请   1审核中  2 已认证  3 不通过
                  **/
                 NSString *auditResult = result[@"auditResult"];
                 
                 NSNumber *payMoney = result[@"payMoney"];
                 NSNumber *paidMoney = result[@"paidMoney"];
                 NSNumber *freezeMoney = result[@"freezeMoney"];
                 if (auditResult.integerValue == 0) {
                     weakSelf.allAmountL.text = payMoney.description;
                     weakSelf.allAmountFL.text = @"需缴纳保证金";
                 }else{
                     weakSelf.allAmountL.text = paidMoney.description;
                     weakSelf.allAmountFL.text = @"保证金";
                 }
                 weakSelf.frozenAmountL.text = freezeMoney.description;
                 NSArray *stateStrs = @[@"未认证", @"审核中", @"已认证", @"查看原因"];
                 NSString *stateStr = @"";
                 if (auditResult.integerValue < stateStrs.count) {
                     stateStr =  stateStrs[auditResult.integerValue];
                 }
                 _menuKey = auditResult.integerValue;
                 _stateB.enabled = !(auditResult.integerValue == 2);
                 weakSelf.stateB.titleLabel.text = stateStr;
                 [weakSelf.stateB setTitle:stateStr forState:UIControlStateNormal];
             }else{
                 YHLogERROR(@"");
                 [weakSelf showErrorInfo:info];
             }
         } onError:^(NSError *error) {
             //         [SVProgressHUD dismiss];
         }];
    }
}

@end
