//
//  YHLeftController.m
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/3.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHLeftController.h"
#import "PCAlertViewController.h"
#import "YHMessageCenterController.h"
#import "UIViewController+RESideMenu.h"
#import "YHCallCenterController.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "PCAccountController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "PCBlutoothController.h"
#import "YHPersonInfoController.h"
#import "LenovoIDInlandSDK.h"
#import "PCPostureController.h"
#import <UIButton+WebCache.h>
#import <Masonry/Masonry.h>
#import "PCMsgViewController.h"
#import "PCWifiController.h"
#import "PCBluetoothManager.h"
#import "PCTestRecordController.h"
#import "PCFigureContrastController.h"
#import "PCLeftCell.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
extern NSString *const notificationReloadLoginInfo;
@interface YHLeftController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton*nameBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic)NSDictionary *result;
@property (nonatomic)YHLeftMenuActions menuKey;
@property (nonatomic, strong) NSArray <NSArray<NSDictionary *> *> *myData;

@property (nonatomic, strong) UILabel *versionLB;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *nickNameLB;
@property (nonatomic, assign) NSInteger msgCount;
@property (weak, nonatomic) IBOutlet UIButton *settingB;
@property (weak, nonatomic) IBOutlet UIButton *picB;

@end

@implementation YHLeftController



- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.tableFooterView = [UIView new];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];
    [self updateUnreadMessage];
}

- (void)updateUnreadMessage{
    [self.tableView reloadData];
    return;
    NSString *accountId = YHTools.accountId;
    if (!accountId) return;
    [[YHNetworkManager sharedYHNetworkManager] unreadMessageCount:@{@"accountId":accountId} onComplete:^(NSInteger count) {
        self.msgCount = count;
        [self.tableView reloadData];
    } onError:^(NSError * _Nonnull error) {
        self.msgCount = 0;
        [self.tableView reloadData];
        [MBProgressHUD showError:error.userInfo[@"message"]];
    }];
}

- (void)getUserInfo{
    
    PCPersonModel *masterPersion = [YHTools sharedYHTools].masterUser;
    if (masterPersion) {
        
        [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:masterPersion.headImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        [self.nickNameLB setTitle:IsEmptyStr(masterPersion.personName)? @"" : masterPersion.personName forState:UIControlStateNormal];
    }else{
        [[LenovoIDInlandSDK shareInstance] leInlandObtainLenovoUserInfo:^(NSDictionary *userInfo) {
            NSString *nickName = userInfo[@"nickName"];
            
            [self.nickNameLB setTitle:IsEmptyStr(nickName)? @"" : nickName forState:UIControlStateNormal];
        } error:^(NSDictionary *errorDic) {
            YHLog(@"%s", __func__);;
        }];
        [[LenovoIDInlandSDK shareInstance] leInlandObtainLenovoUserIcon:^(NSDictionary *userInfo) {
            [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:userInfo[@"iconUrl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
        } error:^(NSDictionary *errorDic) {
            YHLog(@"%s", __func__);;
        }];
    }

}

- (IBAction)nameAction:(UIButton *)sender {
    [self hideMenuViewController:nil];
//    [LenovoIDInlandSDK leInlandShowAccountWithRootViewController:self error:^(NSDictionary *errorDic) {
//        ;
//    }];
//    return;
//
//    UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
//    [self.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
    YHPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
    vc.action = PersonInfoActionMasterDetail;
    vc.model = [YHTools sharedYHTools].masterUser;
    vc.isLeft = YES;
    
    [self.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
    
}


- (IBAction)logoutAction:(UIButton *)sender {
    [self hideMenuViewController:nil];
    
    [LenovoIDInlandSDK leInlandShowAccountWithRootViewController:self error:^(NSDictionary *errorDic) {
        ;
    }];
    return;
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHLogoutController"];
    [self.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
}
- (void)historyDataAction{
    
    [self hideMenuViewController:nil];

    if (![YHTools sharedYHTools].masterPersion) {
        return;
    }
    PCPostureController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCPostureController"];
    vc.title = @"体态测量";
    [self.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];

}

//FIXME:   - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    self.picB.alpha = 0.0;
    self.nickNameLB.alpha = 0.0;
    self.settingB.alpha = 0.0;
    [UIView animateWithDuration:1.  animations:^{
        self.picB.alpha = 1.0;
        self.nickNameLB.alpha = 1.0;
        self.settingB.alpha = 1.0;
    } completion:^(BOOL finisahed){
        
    }];
    
    return self.myData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *obj = self.myData[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = obj[@"title"];
    cell.imageView.image = [UIImage imageNamed:obj[@"icon"]];
    UIImageView *imageV = [UIImageView new];
    cell.accessoryView = imageV;
    imageV.alpha = 0.;
    [imageV setImage:[UIImage imageNamed:@"点击"]];
    imageV.frame = CGRectMake(cell.frame.size.width - 44, (44 - 13) / 2, 13, 13);
    UILabel *tips = [cell.contentView viewWithTag:100];
    [tips removeFromSuperview];
    
    if ([obj[@"title"] isEqualToString:@"关于"]) {
        NSDictionary *appInfo = [YHTools sharedYHTools].appInfo;;
        NSString *AppStoreVersion = appInfo[@"version"];
        BOOL update = [YHTools canUpDate:AppStoreVersion];
        if (update) {
            tips = [[UILabel alloc] init];
            tips.tag = 100;
            tips.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:tips];
            [tips mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.textLabel.mas_left).offset(40);
                make.centerY.mas_equalTo(cell.textLabel);
                make.size.mas_equalTo(CGSizeMake(4, 4));
            }];
            YHViewRadius(tips, 2);
        }

    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footer = [UIView new];
    footer.backgroundColor = tableView.backgroundColor;

//    if (!section) {
//        UIButton *tttestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        tttestBtn.backgroundColor = YHColor0X(0xD1B182, 1.0);
//        [tttestBtn setTitle:@"体态测量" forState:UIControlStateNormal];
//        [tttestBtn addTarget:self action:@selector(historyDataAction) forControlEvents:UIControlEventTouchUpInside];
//        [footer addSubview:tttestBtn];
//        YHViewRadius(tttestBtn, 22);
//        [tttestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(44);
//            make.left.mas_equalTo(tttestBtn.superview.mas_left).offset(30);
//            make.right.mas_equalTo(tttestBtn.superview.mas_right).offset(-30);
//            make.centerY.mas_equalTo(tttestBtn.superview.mas_centerY);
//        }];
//
//    }

    return footer;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellFrameStart = cell.contentView.frame;
    cellFrameStart.origin.x = -cellFrameStart.size.width;
    cell.contentView.frame = cellFrameStart;
    NSTimeInterval time = indexPath.row*0.05 +indexPath.section * 0.2;
    [UIView animateWithDuration:0.4 delay:time options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect cellFrameEnd = cell.contentView.frame;
        cellFrameEnd.origin.x = 0;
        cell.contentView.frame = cellFrameEnd;
    } completion:^(BOOL finisahed){
        
    }];
    cell.accessoryView.alpha = 0.0;
   [UIView animateWithDuration:1.  animations:^{
       cell.accessoryView.alpha = 1.0;
   } completion:^(BOOL finisahed){
       
   }];
//    [(PCLeftCell *)cell rightAnimated];
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
//    CGFloat h = 100 - section * 50;
//    return h? h : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *obj = self.myData[indexPath.section][indexPath.row];
    dispatch_block_t action = obj[@"action"];
    !(action)? : action();
}

- (IBAction)userInfoActions:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(leftMenuActions: withInfo:)] && self.delegate) {
//        [self.delegate leftMenuActions:_menuKey withInfo:_result];
//    }
//    [self hideMenuViewController:sender];
}

- (NSArray<NSArray<NSDictionary *> *> *)myData{
    if (!_myData) {
        
        WeakSelf
        void (^action03)(void) = ^(){
            [weakSelf hideMenuViewController:nil];

//            YHMessageCenterController *msgvc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCMsgViewController"];
//            msgvc.title = @"消息中心";
//            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:msgvc animated:YES];
//            
//            return ;
            YHMessageCenterController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHMessageCenterController"];
            vc.title = @"消息中心";
            vc.type = DataTypeMessage;
            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
        };
        
        void (^action00)(void) = ^(){
            [weakSelf hideMenuViewController:nil];
            PCTestRecordController *vc = [PCTestRecordController new];
            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
            return ;
        };
        
//        void (^action04)(void) = ^(){
//            [weakSelf hideMenuViewController:nil];
//            PCFigureContrastController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"PCFigureContrastController"];
//            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
//            return ;
//        };

        
        
        void (^action01)(void) = ^(){
            [weakSelf hideMenuViewController:nil];
            PCAccountController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCAccountController"];
            vc.isLeft = YES;
            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
        };
        void (^action02)(void) = ^(){
            
            [self hideMenuViewController:nil];
            if ([[PCBluetoothManager sharedPCBluetoothManager] isConnected]) {
                PCWifiController *VC = [[UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil] instantiateViewControllerWithIdentifier:@"PCWifiController"];
                VC.func = PCFuncWifi;
                [self.parentViewController.childViewControllers.lastObject pushViewController:VC animated:YES];
            }else{
                PCBlutoothController *VC = [[UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil] instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
                VC.isSetWifi = YES;
                [self.parentViewController.childViewControllers.lastObject pushViewController:VC animated:YES];
            }
        };
        void (^action10)(void) = ^(){
            
            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否拨打售后服务电话\n4009908888" message:nil];
            
            [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
            [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                NSString *callPhone = @"telprompt://4009908888";
                   if (@available(iOS 10.0, *)) {
                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                   } else {
                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                   }
            }];
            
            [weakSelf.parentViewController.childViewControllers.lastObject presentViewController:vc animated:NO completion:nil];
//            [weakSelf hideMenuViewController:nil];
//            UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCContactController"];
//            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];
        };
        void (^action11)(void) = ^(){
           
            [weakSelf hideMenuViewController:nil];
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHHelpCenterController"];
            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];

        };
        void (^action12)(void) = ^(){
            [weakSelf hideMenuViewController:nil];
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAboutController"];
            [weakSelf.parentViewController.childViewControllers.lastObject pushViewController:vc animated:YES];

        };
        
        
        _myData = @[
//                    @[
//                        @{@"title":@"消息中心",@"icon":@"分组_3 copy 2",@"action":action00}                        ],
                    @[
                        @{@"title":@"测量记录",@"icon":@"测量记录",@"action":action00},
                        @{@"title":@"消息中心",@"icon":@"分组_3 copy 2",@"action":action03},
//                        @{@"title":@"体形对比",@"icon":@"体型对比",@"action":action04},

                        @{@"title":@"用户管理",@"icon":@"分组_6 copy",@"action":action01},
                        @{@"title":@"配置网络",@"icon":@"分组_3 copy 3",@"action":action02}
                        ],
                    @[
                        @{@"title":@"售后服务电话",@"icon":@"分组_5 copy",@"action":action10},
                        @{@"title":@"帮助",@"icon":@"分组_4 copy 2",@"action":action11},
                        @{@"title":@"关于",@"icon":@"分组_4 copy 3",@"action":action12}
                        ]
                    ];
    }
    return _myData;
}
@end
