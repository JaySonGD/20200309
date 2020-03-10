//
//  YHHomeViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/1.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
// 首页

#import <SDCycleScrollView/SDCycleScrollView.h>
#import <WebKit/WebKit.h>
#import "YHWebViewController.h"
#import "YHHomeViewController.h"
#import "PCAccountController.h"
#import "YHPersonInfoController.h"
#import "YHHistoryController.h"
#import "PCPostureDetailController.h"
#import "PCShareController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "LenovoIDInlandSDK.h"
#import "YBPopupMenu.h"
#import "UIView+add.h"
#import "UIViewController+RESideMenu.h"
#import "YHModelItem.h"
#import "PCHomeLeftCell.h"
#import "YHModelCell.h"
#import "PCPersonModel.h"
#import "PCBlutoothController.h"
#import "PCTestRecordModel.h"
#import "PCMessageModel.h"
#import "PCFigureContrastController.h"
#import "PCChartController.h"
#import "PCSurveyController.h"
#import <MJExtension/MJExtension.h>
#import <UMCommon/UMCommon.h>   // 公共组件是所有友盟产品的基础组件，必选
#import <UMShare/UMShare.h>     // 分享组件
#import "PCMQTT.h"
#import <UShareUI/UShareUI.h>  //分享面板
#import <Masonry.h>
#import "PCBluetoothManager.h"
#import "PCAlertViewController.h"
#import "YHHomeViewController+Tools.h"
#import "PCHistoryContentView.h"
#import "CheckNetwork.h"
#import "Reachability.h"
#import "PCSharePreviewController.h"

#import "iCarousel.h"
#import "PCCarouselCell.h"

#import "penco-Swift.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
extern NSString *const notificationReloadLoginInfo;
extern NSString *const notificationRefreshToken;
extern NSString *const notificationRefreshTokenDelegate;
extern NSString *const notificationReloadUser;
extern NSString *const notificationCheckUser;
extern NSString *const notificationMqtt;
extern NSString *const PCNotificationMQQTT;
extern NSString *const notificationConfirmReport;
extern NSString *const notificationNoNetwork;

extern NSString *const notificationLoad3d;
NSString *const notificationFunction = @"YHNotificationFunction";
NSString *const notificationRecordListToHomeDetail = @"notificationRecordListToHomeDetail";
NSString *const notificationAppActive = @"notificationAppActive";
@interface YHHomeViewController ()<
UIGestureRecognizerDelegate,YBPopupMenuDelegate,
UITableViewDelegate,UITableViewDataSource,
LenovoIDInlandDelegate, WKScriptMessageHandler,
iCarouselDataSource,iCarouselDelegate
>
@property (weak, nonatomic)  UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *leftCollV;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (weak, nonatomic) IBOutlet UIButton *shapingBtn;
@property (weak, nonatomic) IBOutlet UIButton *muscleGrowthBtn;
@property (weak, nonatomic) IBOutlet UIView *postureScrollF;
@property (weak, nonatomic) IBOutlet UICollectionView *postureImgCollV;
@property (weak, nonatomic) IBOutlet UIImageView *homeB;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *homeNviBar;
@property (weak, nonatomic) IBOutlet UIButton *firgureBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *postureCollV;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *postureT;
@property (weak, nonatomic)PCChartController *chartCtr;
@property (nonatomic, strong)IBOutlet UIView *titleView;
@property (nonatomic, weak) IBOutlet UIButton *arrowBtn;
@property (nonatomic, weak) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIView *postureNoDataV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardHLC;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
//@property (nonatomic, strong) NSMutableArray <YHCellItem *>*tableModels;
@property (nonatomic, strong) NSMutableArray <YHCellItem *>*reportModels;

@property (nonatomic, strong)YHModelItem *muscleGrowth;
@property (nonatomic, strong)YHModelItem *shaping;
@property (nonatomic, strong) NSMutableArray<PCPersonModel *> *models;
@property (strong, nonatomic)PCPostureModel *postureModel;
@property (nonatomic, strong)NSDictionary *recordModel;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;

@property (nonatomic, strong)WKWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *nodataTableV;

@property (weak, nonatomic) IBOutlet UIView *listBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (nonatomic)PC3dModel model;
@property (nonatomic, copy) NSString *reportId;

@property (nonatomic, assign) CGFloat offy;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgAnimaLeft;
@property (nonatomic)BOOL isPosture;
@property (nonatomic)BOOL isFigureNodata;//体形是否暂无数据

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeBarHLC;
@property (nonatomic, strong) iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIButton *postureBtn;
@property (weak, nonatomic) IBOutlet UILabel *postureTimeL;

@end

@implementation YHHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    [YHTools setpostureScroll:nil];
    [[CheckNetwork sharedCheckNetwork] registerNetworkNotice];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloginAction:) name:notificationReloadLoginInfo object:nil];
    [center addObserver:self selector:@selector(refreshToken:) name:notificationRefreshToken object:nil];
    [center addObserver:self selector:@selector(refreshToken:) name:notificationRefreshTokenDelegate object:nil];
    [center addObserver:self selector:@selector(loadData) name:notificationReloadUser object:nil];
    [center addObserver:self selector:@selector(changeUser) name:notificationCheckUser object:nil];
    [center addObserver:self selector:@selector(noNetwork) name:notificationNoNetwork object:nil];
    [center addObserver:self selector:@selector(notificationRecordListToHomeDetail:) name:notificationRecordListToHomeDetail object:nil];
    
    [center addObserver:self selector:@selector(autoLogin) name:notificationAppActive object:nil];
    [center addObserver:self selector:@selector(load3d:) name:notificationLoad3d object:nil];
    //    [center addObserver:self selector:@selector(mqttAction:) name:notificationMqtt object:nil];
    [center addObserver:self selector:@selector(mqttAction:) name:PCNotificationMQQTT object:nil];
    [center addObserver:self selector:@selector(confirmReport) name:notificationConfirmReport object:self];
    [center addObserver:self selector:@selector(firstFigureResult:) name:@"PCNotificationFirstFigureResult" object:nil];
    [center addObserver:self selector:@selector(addCoverView) name:@"PCNotificationShowCoverView" object:nil];
    
    //注册网络变化监听通知
    [center addObserver:self
               selector:@selector(checkNetworkStatus:)
                   name:kReachabilityChangedNotification object:nil];
    
    
    // 创建布局
//    VegaScrollFlowLayout * layout = [[VegaScrollFlowLayout alloc]init];
    
    GravitySliderFlowLayout *layout = [[GravitySliderFlowLayout alloc] init];
    //layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(95,150);
    //layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    self.leftCollV.collectionViewLayout = layout;
    

    // 创建布局
         layout = [[GravitySliderFlowLayout alloc]init];
//       layout.minimumLineSpacing = 20;
       layout.itemSize = CGSizeMake(125,95);
//       layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
       self.postureCollV.collectionViewLayout = layout;
    
    [YHTools setshapingId:nil];
    [YHTools setmuscleId:nil];
    [self loadWeb3D];
    [self initUI];
    
    //    [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
    [self autoLogin];
    self.homeBarHLC.constant = NavbarHeight;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor =ZTColor;// [UIColor blueColor]; //YHColor0X(0X3E424B, 1);
//    self.navigationController.navigationBar.translucent = NO;
    if (self.chartCtr) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.homeNviBar.hidden = YES;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.homeNviBar.hidden = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}


- (void)addCarousel{
    return;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    _carousel = [[iCarousel alloc] initWithFrame:self.tableView.frame];
    
    _carousel.type = iCarouselTypeRotary;//旋转类型
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.vertical = YES;
    //添加到view上
    [self.tableView.superview addSubview:_carousel];
    _carousel.clipsToBounds = YES;
    
    [_carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(_carousel.superview);
    }];
    //    });
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    self.tableView.hidden = YES;
    if (self.isPosture) {
        return 10;
    }else{
//        if(!self.chartCtr) self.listBox.hidden = !self.reportModels.count;
        return self.reportModels.count + 1;
    }
}

//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
//{
//    switch (option)
//    {
//        case iCarouselOptionWrap:
//        {
//            return NO;
//        }
////        case iCarouselOptionFadeMax:
////        {
////            if (carousel.type == iCarouselTypeCustom)
////            {
////                return 0.0f;
////            }
////            return value;
////        }
////        case iCarouselOptionArc:
////        {
////            return value;
////
////            //            return 2 * M_PI * _arcSlider.value;
////        }
////        case iCarouselOptionRadius:
////        {
////            return value;
////
////            //            return value * _radiusSlider.value;
////        }
////        case iCarouselOptionTilt:
////        {
////            return value;
////
////            //            return _tiltSlider.value;
////        }
////        case iCarouselOptionSpacing:
////        {
////            return value;
////
////            //            return value * _spacingSlider.value;
////        }
//        default:
//        {
//            return value;
//        }
//    }
//}



- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    PCCarouselCell *cell = nil;// (PCCarouselCell *)view;
    if (cell == nil)
    {
        NSString *celKey = (self.isPosture) ? (index == 0 ? @"postureHead" : @"posture") :  (index == 0 ? @"figureHead" : @"cell");
        cell = [PCCarouselCell viewWithKey:celKey];
        
        CGFloat h = ( self.isPosture ? (index == 0 ? 135 : 105) :  (150));
        
        cell.frame = CGRectMake(0.0f, 0.0f, carousel.bounds.size.width, h);
    }
    
    if (self.isPosture) {
        [cell postureLoad:self.postureModel.postureCards[index]];
    }else{
        if (index != 0) {
            cell.item = self.reportModels[index - 1];
        }
    }
    
    
    
    return cell;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)indexPath{
    if (self.isPosture) {
        if (self.postureModel.postureId) {
            PCPostureCard *card = self.postureModel.postureCards[indexPath];
            PushControllerBlockAnimated(@"Survey", @"YHWebViewController",((YHWebViewController*)controller).urlStr = card.detailUrl; if(indexPath == 0) ((YHWebViewController*)controller).title = @"体态结论";, YES);
        }
    }else{
        if (indexPath == 0) {
            if (self.isFigureNodata) {
                [MBProgressHUD showError:@"暂无数据!"];
                return;
            }
            PushControllerBlockAnimated(@"Survey", @"PCFigureContrastController",, YES);
        }else{
            [self checkPart:self.reportModels[indexPath - 1]];
        }
    }
}

- (void)noNetwork{

    [self hideMenuViewController:nil];
    PushControllerBlockAnimated(@"Main", @"PCNoNetworkController",, NO);
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (internetStatus){
        case NotReachable:{
            YHLog(@"The internet is down.");
//            [self noNetwork];
            break;
        }
        case ReachableViaWiFi:
        case ReachableViaWWAN:{
            YHLog(@"The internet is working via WWAN!");
            break;
        }
    }
}

- (void)initUI{
    //[self.profileBtn setImage:[UIImage imageNamed:@"我的"] forState:UIControlStateNormal];
    //self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"我的"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
//    self.navigationItem.titleView = self.titleView;
//    [self.homeNviBar addSubview:self.titleView];
    
    self.tableView.rowHeight = 160;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.bounces = NO;
    UIEdgeInsets inset = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom - 10, inset.right);
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.scanBtn.superview setRounded:self.scanBtn.superview.bounds corners:UIRectCornerTopLeft radius:25];
    //    });
    
    
    //    [self updateTime];
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:50 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    //    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    self.muscleGrowthBtn.superview.hidden = YES;
    
    [self addCarousel];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scanBtn.superview setRounded:self.scanBtn.superview.bounds corners:UIRectCornerTopLeft radius:25];
    
}

- (void)updateTime{
    
    
    
    NSString *dateLBTime = (self.reportModels.firstObject.reportTime.length >= 10)? ([self.reportModels.firstObject.reportTime substringToIndex:10]) : @"";
    
    
    NSString *timeLBTime = (self.reportModels.firstObject.reportTime.length >= 16)? ([self.reportModels.firstObject.reportTime substringWithRange:NSMakeRange(11, 5)]) : @"暂无数据";
    
    
    //NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //fmt.dateFormat = @"YYYY.MM.dd";
    self.dateLB.text = dateLBTime;//[fmt stringFromDate:[NSDate date]];
    //fmt.dateFormat = @"HH:mm";
    self.timeLB.text = timeLBTime;//[fmt stringFromDate:[NSDate date]];
}

- (void)addCoverView{
    
    //if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PCAddCoverView"] boolValue]) return;
    
    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame = CGRectMake(6, kStatusBarAndNavigationBarHeight-44, 35, 44);
    profileBtn.backgroundColor = [UIColor whiteColor];
    [coverView addSubview:profileBtn];
    YHViewRadius(profileBtn, 5);
    [profileBtn setImage:[UIImage imageNamed:@"我的"] forState:UIControlStateNormal];
    
    
    UIView *l0 = [UIView new];
    [coverView addSubview:l0];
    l0.backgroundColor = YHColor0X(0xD9D9DA, 1.0);
    kViewRadius(l0, 2.5);
    
    UIView *l1 = [UIView new];
    [coverView addSubview:l1];
    l1.backgroundColor = YHColor0X(0xD9D9DA, 1.0);
    UIView *l2 = [UIView new];
    [coverView addSubview:l2];
    l2.backgroundColor = YHColor0X(0xD9D9DA, 1.0);
    
    [l0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(profileBtn.mas_right).offset(2);
        make.centerY.mas_equalTo(profileBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(l0.mas_right);
        make.centerY.mas_equalTo(l0.mas_centerY);
        make.right.mas_equalTo(l1.superview.mas_centerX);
        make.height.mas_equalTo(2.5);
    }];
    
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor whiteColor];
    [closeBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [closeBtn setTitleColor:YHColor0X(0xBFA889, 1.0) forState:UIControlStateNormal];
    YHViewRadius(closeBtn, 22);
    [coverView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(removeCover:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@250);
        make.height.equalTo(@44);
        make.bottom.equalTo(closeBtn.superview.mas_bottom).offset(-200);
        make.centerX.equalTo(closeBtn.superview.mas_centerX);
    }];
    
    
    UIButton *tipLB = [[UIButton alloc] init];
    [tipLB setTitle:@"   可在我的中为新设备配置wifi   " forState:UIControlStateNormal];
    [coverView addSubview:tipLB];
    [tipLB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    YHViewRadius(tipLB, 22);
    [tipLB setBackgroundImage:[UIImage imageNamed:@"tipbg"] forState:UIControlStateNormal];
    
    
    [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLB.superview.mas_top).offset(kStatusBarAndNavigationBarHeight + 44);
        make.centerX.equalTo(closeBtn.superview.mas_centerX);
        make.height.mas_equalTo(44);
    }];
    
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(l1.mas_top);
        make.right.mas_equalTo(l1.mas_right);
        make.width.mas_equalTo(2.5);
        make.bottom.mas_equalTo(tipLB.mas_top);
    }];
    
    
    
    //    tipLB.backgroundColor = [UIColor redColor];
    
    
}

- (void)removeCover:(UIButton *)sender{
    //[[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"PCAddCoverView"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [sender.superview removeFromSuperview];
    }];
}

- (void)setModels:(NSMutableArray<PCPersonModel *> *)models{
    _models = models;
    
    //    self.listBox.hidden = !models;
    //self.muscleGrowthBtn.superview.hidden = !models.count;
    self.titleView.hidden = !models.count;
    
    
    
    if(models.count){
        //[self addCoverView];
    }else{
        //        static i = 0;
        //        if (i != 0) {
        //            return;
        //        }
        //        i = 1;
        YHPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
        vc.action = PersonInfoActionNext;
        vc.exitBlock = ^{
            [self reloginAction:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)refreshToken:(NSNotification*)notice{
    
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
    WeakSelf
    
    if ([notice.name isEqualToString:notificationRefreshTokenDelegate]) {
        [[LenovoIDInlandSDK shareInstance] leInlandObtainStData:^(BOOL isLogin, NSString *st, NSString *userID) {
            [YHTools setAccessToken:st];
            [YHTools setAccountId:userID];
            [weakSelf refreshAccount:notice.name];
        } error:^(NSDictionary *errorDic) {
            YHLog(@"errer%@", errorDic);
            [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
            [weakSelf reloginAction:nil];
        }];
    }else{
        [self refreshAction:notice.name];
    }
}


- (void)refreshAction:(NSString*)name{
    WeakSelf
    if ([YHTools refreshToken]) {
        if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
            [self noNetwork];
            return;
        }
        [[YHNetworkManager sharedYHNetworkManager] refreshToken:@{@"refreshToken":[YHTools refreshToken]} onComplete:^(NSDictionary * _Nonnull info) {
            YHLog(@"%@", info);
            if ([info isKindOfClass:[NSDictionary class]] && ![info[@"code"] integerValue]) {
                NSDictionary *result = info[@"result"];
                NSString *refreshToken = result[@"refreshToken"];
                NSString *token = result[@"rulerToken"];
                [YHTools setRefreshToken:refreshToken];
                [YHTools setRulerToken:token];
                [[YHNetworkManager sharedYHNetworkManager].requestSerializer setValue:token forHTTPHeaderField:@"rulerToken"];
                [weakSelf getAccountInfo];
            }else{
                [weakSelf reloginAction:nil];
            }
        } onError:^(NSError * _Nonnull error) {
            [weakSelf reloginAction:nil];
        }];
    }else{
        [self autoLogin];
    }
}

- (void)refreshAccount:(NSString*)name{
    if ([[LenovoIDInlandSDK shareInstance] leInlandObtainLoginStatus] && [YHTools getAccessToken] != nil) {
        if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
            [self noNetwork];
            return;
        }
        WeakSelf
        [[YHNetworkManager sharedYHNetworkManager].requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
        [[YHNetworkManager sharedYHNetworkManager] login:@{@"lenovoToken":[YHTools getAccessToken]} onComplete:^(NSDictionary *info) {
            if ([info isKindOfClass:[NSDictionary class]] && ![info[@"code"] integerValue]) {
                NSDictionary *result = info[@"result"];
                NSString *accountId = result[@"accountId"];
                NSString *refreshToken = result[@"refreshToken"];
                NSString *token = result[@"rulerToken"];
                [YHTools setAccountId:accountId];
                [YHTools setRefreshToken:refreshToken];
                [YHTools setRulerToken:token];
                [[YHNetworkManager sharedYHNetworkManager].requestSerializer setValue:token forHTTPHeaderField:@"rulerToken"];
            }else{
            }
            YHLog(@"%s", __func__);
        } onError:^(NSError *error) {
            YHLog(@"%s", __func__);
            //            [weakSelf getAccountInfo];
            if (error.code == 0xFFFFFFF8) {
                return ;
            }
        }];
    }else{
        [self reloginAction:nil];
    }
}

- (void)reloginAction:(NSNotification*)notice{
//    if ([YHTools refreshToken]) {
//        [[YHNetworkManager sharedYHNetworkManager] logout:@{@"refreshToken":[YHTools refreshToken]} onComplete:^(NSDictionary * _Nonnull info) {
//            ;
//        } onError:^(NSError * _Nonnull error) {
//            ;
//        }];
//    }
    YHLog(@"reloginAction");
    //启动接受通知
    [PCMQTT sharedPCMQTT].autoConnect = NO;
    [[PCMQTT sharedPCMQTT] unsubscribe:YHTools.accountId];
    [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
    [YHTools setAccessToken:nil];
    [YHTools setAccountId:nil];
    [YHTools setRefreshToken:nil];
    [YHTools setRulerToken:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self autoLogin];
    
    [YHTools sharedYHTools].masterPersion = nil;
    self.reportModels = nil;
    self.postureModel = nil;
    self.offy = 0;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.titleView.hidden = YES;
    
    [self figureAction:self.firgureBtn];//恢复默认状态
//    self.isPosture = NO;
//    [self.leftCollV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//    [self postureAndFigure];
    [self default3d:[YHTools sharedYHTools].masterPersion];
}

- (void)changeUser{
    [self changUser:[YHTools sharedYHTools].masterPersion isForce:YES];
}

-(void)loadData{
    [self getPersionList];
    //    [self getShaping];
    //    [self getMuscleGrowth];
    //[self addCoverView];
}

#pragma mark - loadData

- (void)getPersionList{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
    NSString *accountId = YHTools.accountId;
    
    if (!accountId) {
//        
        return;
    }
    DebugTime
    WeakSelf
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getPersonsOnComplete:^(NSMutableArray<PCPersonModel *> *models) {
        //models = nil;
        [MBProgressHUD hideHUDForView:self.view];
        weakSelf.models = models;
        [YHTools sharedYHTools].personList = weakSelf.models;
        if (models.count >= 1) {
            [YHTools sharedYHTools].masterUser = models[0];
        }
        NSString *lastTimePersionId = YHTools.personId;
        __block PCPersonModel *model = models.firstObject;
        [models enumerateObjectsUsingBlock:^(PCPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([lastTimePersionId isEqualToString:obj.personId]){
                model = obj;
                *stop = YES;
            }
        }];
        
        [weakSelf changUser:model isForce:NO];
        
        if([model.personId isEqualToString:[YHTools sharedYHTools].masterPersion.personId] && self.isFigureNodata){
            [weakSelf default3d:model];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];

    }];
}

- (void)changUser:(PCPersonModel *)user isForce:(BOOL)isForce{
    if (user == nil) {
        return;
    }
    
    self.nameLB.text =user.personName;
    
    if([user.personId isEqualToString:[YHTools sharedYHTools].masterPersion.personId] && !isForce) return;
    
    self.shapingBtn.selected = NO;
    self.muscleGrowthBtn.selected = NO;
    
    [YHTools setPersonId:user.personId];
    [YHTools sharedYHTools].masterPersion = user;
    [self getLastReport];
    [self getLastPosture];
    
}

-(void)getAccountInfo{
    if ([[LenovoIDInlandSDK shareInstance] leInlandObtainLoginStatus] && [YHTools getAccessToken] != nil) {
        if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
            [self noNetwork];
            return;
        }
        DebugTime
        WeakSelf
        [[YHNetworkManager sharedYHNetworkManager].requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
        [[YHNetworkManager sharedYHNetworkManager] login:@{@"lenovoToken":[YHTools getAccessToken]} onComplete:^(NSDictionary *info) {
            if ([info isKindOfClass:[NSDictionary class]] && ![info[@"code"] integerValue]) {
                NSDictionary *result = info[@"result"];
                NSString *accountId = result[@"accountId"];
                NSString *refreshToken = result[@"refreshToken"];
                NSString *token = result[@"rulerToken"];
                [YHTools setAccountId:accountId];
                [YHTools setRefreshToken:refreshToken];
                [YHTools setRulerToken:token];
                [[YHNetworkManager sharedYHNetworkManager].requestSerializer setValue:token forHTTPHeaderField:@"rulerToken"];
                //                [weakSelf refreshToken:nil];
                [weakSelf loadData];
                //启动接受通知
                //[[PCMQTTMannager sharedPCMQTTMannager] subscribe:accountId];
                [weakSelf checkAppUpdate];
                [PCMQTT sharedPCMQTT].autoConnect = YES;
                [[PCMQTT sharedPCMQTT] subscribe:accountId];
            }else{
                //                [MBProgressHUD showError:[info objectForKey:@"message"]];
//                [weakSelf reloginAction:nil];
            }
            YHLog(@"%s", __func__);
        } onError:^(NSError *error) {
            YHLog(@"%s", __func__);
            //            [weakSelf getAccountInfo];
            if (error.code == 0xFFFFFFF8) {
                return ;
            }
//            [weakSelf reloginAction:nil];
            
        }];
    }else{
        [self reloginAction:nil];
    }
}
- (void)checkAppUpdate{
    
    NSString *accountId = YHTools.accountId;
    if ( !accountId ) {
//        
        return;
    }
    
    [[YHNetworkManager sharedYHNetworkManager] appOTA:@{@"appId":[[NSBundle mainBundle] bundleIdentifier],@"accountId":[YHTools accountId],@"systemType":@"IOS"} onComplete:^(NSDictionary *obj) {
        //        versionNum
        //        String
        //        版本号
        //        otaUrl
        //        String
        //        软件升级地址
        //        isForce
        //        String
        //        是否强制升级
        NSString *AppStoreVersion = obj[@"version"];
        NSString *otaUrl = obj[@"otaUrl"];
        if(!otaUrl || !AppStoreVersion) return;
        
        BOOL isForce = [obj[@"isForce"] integerValue] == 1;
        BOOL update = [YHTools canUpDate:AppStoreVersion];
        
        [YHTools sharedYHTools].appInfo = obj;
        return;
        if(!update) return ;
        
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"有新的版本" message:[NSString stringWithFormat:@"%@",AppStoreVersion]];
        if (!isForce) {
            [vc addActionWithTitle:@"取消" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
                //                if(isForce) exit(1);
            }];
        }
        [vc addActionWithTitle:@"更新" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:otaUrl];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(isForce) exit(1);
                });
            }
        }];
        [self presentViewController:vc animated:NO completion:nil];
        
    } onError:^(NSError *error) {

    }];
}

- (void)getShaping{
    WeakSelf
    self.model = PC3dModelShaping;
    PCPersonModel *masterP = [YHTools sharedYHTools].masterPersion;
    NSDictionary *parm = @{@"sex":@(masterP.sex),@"age":@(masterP.age),@"height":@(masterP.height),@"weight":@(masterP.weight)};
    //parm = @{@"sex":@(1),@"age":@(22),@"height":@(120),@"weight":@(112)};
    
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] shaping:parm onComplete:^(YHModelItem *item) {
        
        //        weakSelf.tableModels = item.items;
        //        [weakSelf.tableView reloadData];
        weakSelf.shaping = item;
        [MBProgressHUD hideHUDForView:self.view];
        [weakSelf download3DModel:PC3dModelShaping url:item.modelUrl modelId:item.modelId];
        //        [weakSelf completeMdeol:PC3dModelShaping];
        YHLog(@"%s", __func__);
    } onError:^(NSError *error) {
        YHLog(@"%s", __func__);
        [MBProgressHUD hideHUDForView:self.view];

    }];
}
- (void)getMuscleGrowth{
    self.model = PC3dModelMuscleGrowth;
    PCPersonModel *masterP = [YHTools sharedYHTools].masterPersion;
    NSDictionary *parm = @{@"sex":@(masterP.sex),@"age":@(masterP.age),@"height":@(masterP.height),@"weight":@(masterP.weight)};
    //parm = @{@"sex":@(1),@"age":@(22),@"height":@(178),@"weight":@(140)};
    WeakSelf
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] muscleGrowth:parm onComplete:^(YHModelItem *item) {
        weakSelf.muscleGrowth = item;
        //        weakSelf.tableModels = item.items;
        //        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view];
        [weakSelf download3DModel:PC3dModelMuscleGrowth url:item.modelUrl modelId:item.modelId];
        //        [weakSelf completeMdeol:PC3dModelMuscleGrowth];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];

    }];
}


- (void)notificationRecordListToHomeDetail:(NSNotification*)notice{
    NSDictionary *info = notice.userInfo;
    [self changUserByPersonId:[info valueForKey:@"personId"] mode:[info valueForKey:@"isPosture"]];
}
- (void)firstFigureResult:(NSNotification*)notice{
    [self figureAction:self.firgureBtn];//确认记录后重置到体形界面
    PCTestRecordModel *model = notice.userInfo[@"data"];
    
    //    self.recordModel = notice.userInfo[@"info"];
    //    self.reportModels = model.items;
    //
    //    //CGFloat offy =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ScrollViewOffY"] floatValue];
    //    [self updateTime];
    //    [self reset3d];
    //    //self.navigationItem.rightBarButtonItem = model? [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)] : nil;
    //
    //    [self.tableView reloadData];
    //    [self.tableView setContentOffset:CGPointMake(0, self.offy) animated:YES];
    //
    //    [self downloadPly:model.modelUrl plyId:model.reportId];
    //
    //
    //    if (!model.status) {
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定测量用户为\"%@\"",model.personName] message:nil];
    //
    //            [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
    //                [self modifyUser];
    //            }];
    //            [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
    //                [self confirmReport];
    //            }];
    //            [self presentViewController:vc animated:NO completion:nil];
    //
    //        });
    //    }
    WeakSelf
    [self.models enumerateObjectsUsingBlock:^(PCPersonModel * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([user.personId isEqualToString:model.personId]) {
            
            [YHTools sharedYHTools].masterPersion = user;
            [YHTools setPersonId:user.personId];
            
            self.nameLB.text =user.personName;
            [weakSelf changUser:user isForce:YES];
            *stop = YES;
        }
    }];
    
}

- (void)confirmReport{
    
    NSString *personId = self.recordModel[@"personId"];//[YHTools sharedYHTools].masterPersion.personId;
    NSString *accountId = YHTools.accountId;
    NSString *reportId = self.recordModel[@"figureRecordId"];
    
    if (!personId || !accountId || !reportId) {
//        
        return;
    }
    
    //@{@"personId":@"",@"reportId":@"",@"accountId":@""}
    NSDictionary *parm = @{@"personId":personId,@"reportId":reportId,@"accountId":accountId};
    
    [[YHNetworkManager sharedYHNetworkManager] confirmReport:parm onComplete:^{
        
//        [MBProgressHUD showError:@"确定成功"];
    } onError:^(NSError *error) {

    }];
}


- (void)modifyUser{
    PCAccountController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCAccountController"];
    vc.sourceVC = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getLastReport{
       if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
    self.model = PC3dModelCancel;
    NSString *personId = [YHTools sharedYHTools].masterPersion.personId;
    NSString *accountId = YHTools.accountId;
    
    if (!personId || !accountId ) {
//        
        return;
    }
    DebugTime
    WeakSelf
    self.selectBtn = nil;
    [MBProgressHUD showMessage:nil toView:self.view];
    NSDictionary *parm = @{@"personId":personId,@"accountId":accountId};
    [[YHNetworkManager sharedYHNetworkManager] lastReport:parm onComplete:^(PCTestRecordModel *model, NSDictionary *info) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        weakSelf.recordModel = info;
        BOOL isFirst = YES;//!(BOOL)self.reportModels;
        
        //CGFloat offy =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ScrollViewOffY"] floatValue];
        weakSelf.reportModels = model.items;
        [weakSelf updateTime];
        //        [weakSelf reset3d];
        //weakSelf.navigationItem.rightBarButtonItem = model? [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)] : nil;
        
//        [weakSelf.tableView reloadData];
        [weakSelf.leftCollV reloadData];
        if(isFirst && model) [weakSelf.tableView setContentOffset:CGPointMake(0, self.offy) animated:YES];
        if(weakSelf.carousel.numberOfItems>3) [weakSelf.carousel scrollToItemAtIndex:2 animated:YES];
        else [weakSelf.carousel scrollToItemAtIndex:weakSelf.carousel.numberOfItems animated:YES];
        
        if (model) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction:)];
            weakSelf.shareBtn.hidden = NO;
            self.timeL.text = [NSString stringWithFormat:@"测量时间：%@", [YHTools stringFromDate:[YHTools dateFromString:model.reportTime byFormatter:@"yyyy-MM-dd HH:mm:ss"] byFormatter:@"yyyy.MM.dd HH:mm"]];
        }else{

            self.navigationItem.rightBarButtonItem = nil;
            weakSelf.shareBtn.hidden = YES;
            self.timeL.text = @"还没有进行过体形测量";
        }
        if (!model) { // 没数据
            PCTestRecordModel *model = [PCTestRecordModel new];
            weakSelf.reportModels = model.items;
            [weakSelf.tableView reloadData];
            [weakSelf.leftCollV reloadData];
            if(isFirst) [weakSelf.tableView setContentOffset:CGPointMake(0, self.offy) animated:YES];
            
        }
        //        else if (!model.status){
        //            if (!model.isConfirm) {
        //
        //                if(![YHTools sharedYHTools].masterPersion.isShow){
        //                    [YHTools sharedYHTools].masterPersion.isShow = YES;
        //                    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定测量用户为\"%@\"",model.personName] message:nil];
        //
        //                    [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
        //                        [self modifyUser];
        //                    }];
        //                    [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        //                        [self confirmReport];
        //                    }];
        //                    [self presentViewController:vc animated:NO completion:nil];
        //                }
        //                return ;
        //            }
        //            if(![YHTools sharedYHTools].masterPersion.isShow){
        //                [YHTools sharedYHTools].masterPersion.isShow = YES;
        //                PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"数据差异较大，是否是%@测量。",model.personName] message:nil];
        //
        //                [vc addActionWithTitle:@"更换用户" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
        //                    [self modifyUser];
        //                }];
        //                [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        //                    [self confirmReport];
        //                }];
        //                [weakSelf presentViewController:vc animated:NO completion:nil];
        //            }
        //        }
        
        [weakSelf downloadPly:model.modelUrl plyId:model.reportId];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        self.timeL.text = @"还没有进行过体形测量";
        self.navigationItem.rightBarButtonItem = nil;
        weakSelf.shareBtn.hidden = YES;
        //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"关闭"] style:UIBarButtonItemStylePlain target:self action:nil];
        { // 没数据
            
            //CGFloat offy =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ScrollViewOffY"] floatValue];
            
            PCTestRecordModel *model = [PCTestRecordModel new];
            weakSelf.recordModel = nil;
            weakSelf.reportModels = model.items;
            [weakSelf.tableView reloadData];
            [weakSelf.leftCollV reloadData];
            if(YES) [weakSelf.tableView setContentOffset:CGPointMake(0, self.offy) animated:YES];
            
            [weakSelf updateTime];
            [weakSelf default3d:[YHTools sharedYHTools].masterPersion];
        }
    }];
}

- (void)getLastPosture{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
    NSString *personId = [YHTools sharedYHTools].masterPersion.personId;
    NSString *accountId = YHTools.accountId;
    
    if (!personId || !accountId ) {
//        
        return;
    }
    WeakSelf
    self.selectBtn = nil;
    [MBProgressHUD showMessage:nil toView:self.view];
    NSDictionary *parm = @{@"personId":personId,@"accountId":accountId};
    [[YHNetworkManager sharedYHNetworkManager] lastPosture:parm onComplete:^(PCPostureModel *model) {
        
        if (model && model.measureTime != nil) {
            weakSelf.postureTimeL.text = [NSString stringWithFormat:@"测量时间：%@", [YHTools stringFromDate:[YHTools dateFromString:model.measureTime byFormatter:@"yyyy-MM-dd HH:mm:ss"] byFormatter:@"yyyy.MM.dd HH:mm"]];
        }else{
            weakSelf.postureTimeL.text = @"还没有进行过体态测量";
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.postureModel = model;
        [weakSelf.postureModel postureImg:^(UIImage * _Nonnull image) {
            if (self.isPosture)[weakSelf postureAndFigure];
            
        }];
        if (self.isPosture)[weakSelf postureAndFigure];
    } onError:^(NSError *error) {
        weakSelf.postureTimeL.text = @"还没有进行过体态测量";
        weakSelf.postureModel = [PCPostureModel new];
        if (self.isPosture)[weakSelf postureAndFigure];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)postureAndFigure{
    //    return;
    if (self.isPosture) {
        NSNumber *postureScroll = [YHTools postureScroll];
        self.postureT.hidden = !(self.postureModel.postureId);
        self.leftCollV.hidden = YES;
        self.postureCollV.hidden = NO;
        self.webView.hidden = YES;
        self.postureTimeL.hidden = NO;
        self.timeL.hidden = YES;
        self.bannerView.hidden = !(self.postureModel.postureId);
        self.postureNoDataV.hidden = self.postureModel.postureId;
        self.cardHLC.constant = 125;
        self.postureScrollF.hidden = postureScroll != nil || !(self.postureModel.postureId);
        [self showPosture];
        [self.postureCollV reloadData];
    }else{
        self.postureT.hidden = YES;
        self.leftCollV.hidden = NO;
        self.postureCollV.hidden = YES;
        self.webView.hidden = NO;
        self.postureTimeL.hidden = YES;
        self.timeL.hidden = NO;
        self.bannerView.hidden = YES;
        self.postureNoDataV.hidden = YES;
        self.cardHLC.constant = 95;
        self.postureScrollF.hidden = YES;
        [self.leftCollV reloadData];
    }
//    [self.tableView reloadData];
    
}
- (IBAction)postureScrollFAction:(id)sender {
    [YHTools setpostureScroll:@NO];
    self.postureScrollF.hidden = YES;
}

-(void)showPosture{
    self.bannerView.localizationImageNamesGroup = self.postureModel.imgs;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = YHColor(219, 219, 219); // 自定义分页控件小圆标颜色
    self.bannerView.pageDotColor = YHColor(74, 68, 64);
    self.bannerView.placeholderImage = [UIImage imageNamed:@"adN"];
    self.bannerView.autoScroll = NO;
    self.bannerView.infiniteLoop = NO;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    [self.bannerView adjustWhenControllerViewWillAppera];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                          describe:(NSString *)describe
                            titles:(NSString *)titles
                          imageUrl:(NSString *)imageUrl
                           address:(NSString *)address{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:describe thumImage:imageUrl];
    
    shareObject.webpageUrl = address;
    
    messageObject.shareObject = shareObject;
    
    //5.调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            //[MBProgressHUD showSuccess:@"分享失败" toView:self.view];
            //UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                //[MBProgressHUD showSuccess:@"分享成功" toView:self.view];
                
                //UMSocialShareResponse *resp = data;
                
                //分享结果消息
                //UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                //UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


#pragma mark - 事件监听

- (IBAction)figureAction:(UIButton *)sender {
    
    
    
    sender.selected = YES;
    UIButton *btn = sender.superview.subviews[sender.tag];
    btn.selected = NO;
    self.bgAnimaLeft.constant = sender.frame.origin.x;
    [UIView animateWithDuration:0.25 animations:^{
        [sender.superview layoutIfNeeded];
    }];
    
    self.isPosture = (sender.tag == 1);
    [self postureAndFigure];
}

- (IBAction)scanAction:(UIButton *)sender {
    
    if (!self.models) {
        return;
    }
    
    if ([[PCBluetoothManager sharedPCBluetoothManager] isConnected]) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
        PCSurveyController *controller = [board instantiateViewControllerWithIdentifier:@"PCSurveyController"];
        controller.isPosture = self.isPosture;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil];
        PCBlutoothController *controller = [board instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
        controller.func =self.isPosture ? PCFuncPosture : PCFuncFigure;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)historyDataAction:(UIButton *)sender {
    if (!self.models) {
        return;
    }
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHMessageCenterController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)add{
    YHPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
    vc.action = PersonInfoActionAdd;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shareAction:(id)sender{
//        [self mqttAction:nil];
//        return;
    PCSharePreviewController *sharePreviewVC = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCSharePreviewController"];
    //vc.shareImage = nil;
    sharePreviewVC.tableModels = self.reportModels;
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    //vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //vc.tableModels = self.tableModels;
    [self.navigationController pushViewController:sharePreviewVC animated:YES];
    return;
    
    //[[PCMQTT sharedPCMQTT] unsubscribe];
    //    "{\"uriUser\":\"models/obj/male\", \"part\":\"waist\",\"uriTypical\":\"models/obj/typical\"}
    //    [self appToH5:@{@"uriUser":@"models/obj/male"}];
    //    [self appToH5:@{@"uriUser":self.model1}];
    
    //    [self download3DModel:PC3dModelShaping url:@"http://siot-ruler-oss-private.oss-cn-beijing.aliyuncs.com/upfile/modelss/16/male.zip?Expires=1721203409&OSSAccessKeyId=LTAIMSW8Fb1ohbzk&Signature=Qhwa1L0VRJ6x51ndqU96Lwv2uB8%3D"];
    //    [self loadFile:[NSString stringWithFormat:@"%@/%@", [self downloadModelPath:PC3dModelMuscleGrowth], @"bust_points.txt"]];
    
    //    [self downloadPly:@"http://siot-ruler-oss-private.oss-cn-beijing.aliyuncs.com/device/report/annex/20190730/cc%3Aaa%3A99%3A99/030823/model.ply?Expires=3141256118&OSSAccessKeyId=LTAIMSW8Fb1ohbzk&Signature=4d1ef4PbzWdlJQ97KB4w8wraaDs%3D"];
    
    //    NSBundle *bundle = [NSBundle mainBundle];
    //    NSString *destination = [bundle resourcePath];
    //    NSString *html = [destination stringByAppendingPathComponent:@"index.html"];
    //    [self loadFile:html];
    //    return;
    
    //    NSDictionary * ii = @{@"type":@"figure_result",@"info":@{@"accountId":@13,@"personId":@18,@"personName":@"lgp",@"measureTime":@"3019-08-03 11:08:47",@"status":@"success",@"figureRecordId":@138,@"confirmStatus":@0}};
    
    
    //    NSDictionary * ii = @{@"type":@"posture_result",@"info":@{@"accountId":@13,@"personId":@18,@"personName":@"lgp",@"measureTime":@"3019-08-03 11:08:47",@"status":@"success",@"postureRecordId":@138}};
    ////      UInt16 bb =  [[PCMQTT sharedPCMQTT] sendMessage:ii];
    //    [self mqttAction:ii];
    
    //    [[YHNetworkManager sharedYHNetworkManager].requestSerializer setValue:@"23432" forHTTPHeaderField:@"rulerToken"];
    //       return;
    
    PCShareController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCShareController"];
    //    vc.tableModels = self.tableModels;
    //    vc.tableModels = self.reportModels;
    
    UINavigationController *navVC =  [[UINavigationController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:navVC animated:YES completion:nil];
}
- (IBAction)btnAction:(UIButton *)sender{
    //    if (self.selectBtn == sender && self.models) {//全部取消
    //        self.selectBtn.selected = NO;
    //        [self getLastReport];
    //        return;
    //    }
    //
    
    if(self.selectBtn == sender && sender.isSelected)
    {
        [self completeMdeol:PC3dModelCancel];
        self.selectBtn.selected = NO;
        return;
    }
    
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
    
    if (sender.tag == 1) {
        [self getShaping];
    }else if (sender.tag == 2) {
        [self getMuscleGrowth];
    }
}
- (IBAction)tapAction:(id)sender{
    if (!self.models || self.models.count == 0) {
        [self autoLogin];
        return;
    }
    self.arrowBtn.selected = YES;
    
    [YBPopupMenu showRelyOnView:self.homeNviBar titles:[self.models valueForKeyPath:@"personName"] icons:nil menuWidth:150 delegate:self];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    //    self.nameLB.text = self.models[index].personName;
    //    [self.nameLB sizeToFit];
    //    self.nameLB.frame = CGRectMake(0, 0, self.nameLB.bounds.size.width, 44);
    //    self.arrowBtn.frame = CGRectMake(CGRectGetMaxX(self.nameLB.frame)+5, 0, 18, 44);
    //    self.navigationItem.titleView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.arrowBtn.frame), 44);
    //    //self.nameLB.tag = index;
    //    [YHTools setPersonId:self.models[index].personId];
    //    [YHTools sharedYHTools].masterPersion = self.models[index];
    
    //    [self.models makeObjectsPerformSelector:@selector(setIsShow:) withObject:@(NO)];
    
    [self changUser:self.models[index] isForce:NO];
}

- (void)ybPopupMenuDidDismiss{
    self.arrowBtn.selected = NO;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/**
 每个分区item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.leftCollV == collectionView || self.postureCollV == collectionView) {
        if (self.isPosture && self.postureCollV == collectionView) {
            return 10;
        }else{
//            if(!self.chartCtr) self.listBox.hidden = !self.reportModels.count;
            return (self.reportModels.count == 0)? 0 : self.reportModels.count + 1;
        }
    }
    return 2;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftCollV == collectionView || self.postureCollV == collectionView) {
        NSString *celKey = (self.isPosture) ? (indexPath.row == 0 ? @"postureHead" : @"posture") :  (indexPath.row == 0 ? @"figureHead" : @"cell");
        PCHomeLeftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:celKey forIndexPath:indexPath];
        if (self.isPosture && self.postureCollV == collectionView) {
            [cell postureLoad:self.postureModel.postureCards[indexPath.row]];
        }else{
            if (indexPath.row != 0) {
                cell.item = self.reportModels[indexPath.row - 1];
            }
        }
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(indexPath.row == 0? @"cell" : @"cell1") forIndexPath:indexPath];
    return cell;
}

/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    collectionViewLayout.i
    if (self.leftCollV == collectionView){
        return CGSizeMake(95, 150);
    }
    if (self.postureCollV == collectionView){
       return CGSizeMake(125, (indexPath.row == 0 ? 125 : 95));
   }
    return self.postureNoDataV.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.postureCollV == collectionView) {
            if (self.postureModel.postureId) {
                PCPostureCard *card = self.postureModel.postureCards[indexPath.row];
                PushControllerBlockAnimated(@"Survey", @"YHWebViewController",((YHWebViewController*)controller).urlStr = (indexPath.row == 0)? card.postreUrl : card.detailUrl; ((YHWebViewController*)controller).titleStr =  card.name;, YES);
            }
        }else{
            if (indexPath.row == 0) {
                if (self.isFigureNodata) {
                    [MBProgressHUD showError:@"暂无数据!"];
                    return;
                }
                PushControllerBlockAnimated(@"Survey", @"PCFigureContrastController",, YES);
            }else{
                [self checkPart:self.reportModels[indexPath.row - 1]];
            }
        }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.nodataTableV == tableView) {
        return 2;
    }
    [self.carousel reloadData];
    if (self.isPosture) {
        return 10;
    }else{
//        if(!self.chartCtr) self.listBox.hidden = !self.reportModels.count;
        return (self.reportModels.count == 0)? 0 : self.reportModels.count + 1;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nodataTableV == tableView) return;
    if (self.isPosture) {
        if (self.postureModel.postureId) {
            PCPostureCard *card = self.postureModel.postureCards[indexPath.row];
            PushControllerBlockAnimated(@"Survey", @"YHWebViewController",((YHWebViewController*)controller).urlStr = card.detailUrl; ((YHWebViewController*)controller).titleStr = @"体态结论";, YES);
        }
    }else{
        if (indexPath.row == 0) {
            if (self.isFigureNodata) {
                [MBProgressHUD showError:@"暂无数据!"];
                return;
            }
            PushControllerBlockAnimated(@"Survey", @"PCFigureContrastController",, YES);
        }else{
            [self checkPart:self.reportModels[indexPath.row - 1]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nodataTableV == tableView) {
        
        YHModelCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell2;
    }
    NSString *celKey = (self.isPosture) ? (indexPath.row == 0 ? @"postureHead" : @"posture") :  (indexPath.row == 0 ? @"figureHead" : @"cell");
    YHModelCell *cell = [tableView dequeueReusableCellWithIdentifier:celKey];
    if (self.isPosture) {
        [cell postureLoad:self.postureModel.postureCards[indexPath.row]];
    }else{
        if (indexPath.row != 0) {
            cell.item = self.reportModels[indexPath.row - 1];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nodataTableV == tableView) return self.postureNoDataV.frame.size.height;
    return ( self.isPosture ? (indexPath.row == 0 ? 135 : 105) :  (150));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    YHLog(@"%s", __func__);
    self.offy = scrollView.contentOffset.y;
    //    CGFloat offY = scrollView.contentOffset.y;
    //    [[NSUserDefaults standardUserDefaults] setObject:@(offY) forKey:@"ScrollViewOffY"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isFigureNodata{
    if (!self.reportModels || self.reportModels.count < 1) {
        return YES;
    }
    YHCellItem *item = self.reportModels[0];
    return (IsEmptyStr(item.reportTime));
}
- (void)checkPart:(YHCellItem *)item {
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
    if(self.chartCtr) return;
    
    //    if (!(item.value >0  || item.change > 0)) {
    if (IsEmptyStr(item.reportTime)) {
        [MBProgressHUD showError:@"暂无数据!"];
        return;
    }
    
    
    NSString *personId = self.recordModel[@"personId"];//[YHTools sharedYHTools].masterPersion.personId;
    NSString *accountId = YHTools.accountId;
    NSString *at = item.bodyParts;
    //    return;
    if (!personId || !accountId || !at) {
//        
        return;
    }
    [MBProgressHUD showMessage:nil toView:self.view];
    PCChartController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCChartController"];
    self.chartCtr = vc;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *endTime = [fmt stringFromDate:[NSDate date]];
    
    NSDictionary *parm = @{@"personId":YHTools.personId,@"accountId":YHTools.accountId,@"startTime":@"2017-05-01 00:00:00",@"endTime":endTime,@"at":item.bodyParts};
    WeakSelf
    [[YHNetworkManager sharedYHNetworkManager] getReport:parm onComplete:^(PCReportModel *model) {
//        [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
        weakSelf.homeNviBar.hidden = YES;
        [MBProgressHUD hideHUDForView:weakSelf.view];
        //PCChartController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCChartController"];
        vc.personId = personId;
        vc.accountId = accountId;
        vc.item = item;
        vc.xyPt = model;
        vc.closeBlock = ^{
            
//            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
            weakSelf.homeNviBar.hidden = NO;
            weakSelf.listBox.hidden = NO;
            weakSelf.timeL.hidden = NO;
            weakSelf.muscleGrowthBtn.superview.hidden = YES;
            weakSelf.selectBtn.selected = NO;
            weakSelf.selectBtn = nil;
            weakSelf.chartCtr = nil;
            
            [weakSelf reset3d];
            //            [weakSelf completeMdeol:PC3dModelCancel];
        };
        
        NSString *at = item.bodyParts;
        
        [weakSelf appToH5:@{@"part":at}];
        [weakSelf.view insertSubview:vc.view belowSubview:self.muscleGrowthBtn.superview];
        [weakSelf addChildViewController:vc];
        weakSelf.listBox.hidden = YES;
        weakSelf.timeL.hidden = YES;
        weakSelf.muscleGrowthBtn.superview.hidden = NO;
        //self.chartCtr = vc;
        
        //        return ;
        //        PCChartController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCChartController"];
        //        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        //        vc.xyPt = model;
        //        vc.item = item;
        //        vc.closeBlock = ^{
        //            [self.view insertSubview:self.webView atIndex:0];
        //            [self.navigationController setNavigationBarHidden:NO animated:NO];
        //            self.listBox.hidden = NO;
        //            [self reset3d];
        //            [self completeMdeol:self.model];
        //        };
        //        [vc.view insertSubview:self.webView atIndex:0];
        //        self.listBox.hidden = YES;
        //        weakSelf.chartCtr = vc;
        //        [self presentViewController:vc animated:NO completion:nil ];
        
    } onError:^(NSError *error) {
        weakSelf.chartCtr = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
    }];
}

- (void)autoLogin{
    
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        return;
    }
    if ([YHTools appAgreement]) {
        [LenovoIDInlandSDK shareInstance].delegate = self;
        if ([[LenovoIDInlandSDK shareInstance] leInlandObtainLoginStatus]) {
            WeakSelf
            [[LenovoIDInlandSDK shareInstance] leInlandObtainStData:^(BOOL isLogin, NSString *st, NSString *userID) {
                [YHTools setAccessToken:st];
                [YHTools setAccountId:userID];
                [weakSelf getAccountInfo];
//                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            } error:^(NSDictionary *errorDic) {
                YHLog(@"errer%@", errorDic);
                [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
                [weakSelf reloginAction:nil];
            }];
//            [self getAccountInfo];
        }else{
            //[[LenovoIDInlandSDK shareInstance]  leInLandLoginToKeyWindowRootViewControllerWithisHiddenNavigation:YES isHidbackButton:YES];

            [self hideMenuViewController:nil];
            [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
            YHLog(@"leInlandLoginWithRootViewController");
            [LenovoIDInlandSDK leInlandLoginWithRootViewController:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                UINavigationController *vc = (UINavigationController *)self.presentedViewController;
                if([vc isKindOfClass:[UINavigationController class]]) vc.childViewControllers.lastObject.navigationItem.leftBarButtonItem = nil;
            });
        }
    }else{
        PushControllerAnimated(@"AppLoading", @"PCLoadingController", NO);
    }
}


#pragma mark - 登陆代理


//功能:登录结束，退出SDK页面的回调 page是退出的页面名称 注意:这是一个代理，会返回登录状态
- (void)leInlandDidFinishFromPage:(LeInlandPageIndentifier)page WithLoginStatus:(BOOL)isLogin {
    YHLog(@"获取了登录状态，%@",isLogin?@"已登录":@"未登录");
    [self hideMenuViewController:nil];
    if (!isLogin) {
        [self reloginAction:nil];
        return;
    }
    YHLog(@"%ld",(long)page);
    NSString *pageStr = @"";
    switch (page) {
            //设置
        case LeInlandSettingPageIndentifier:
            [self presentLeftMenuViewController:nil];
            pageStr = @"LeInlandSettingPageIndentifier";
            break;
            //修改密码
        case LeInlandModifyPasswordPageIndentifier:
            pageStr = @"LeInlandModifyPasswordPageIndentifier";
            break;
            
            //登录
        case LeInlandLoginPageIndentifier:
            //手机号登录
        case LeInlandPhoneNumPageIndentifier:
            //邮箱登录
        case LeInlandEmailNumPageIndentifier:
            //注册
        case LeInlandRegisterPageIndentifier:
            //三方登录
        case LeInlandThirdLoginPageIndentifier:
        case LeInlandResetPasswordPageIndentifier:
        {
            pageStr = @"LeInlandPhoneNumPageIndentifier";
            [YHTools setPersonId:nil];
            WeakSelf
            [[LenovoIDInlandSDK shareInstance] leInlandObtainStData:^(BOOL isLogin, NSString *st, NSString *userID) {
                [YHTools setAccessToken:st];
                [YHTools setAccountId:userID];
                [weakSelf getAccountInfo];
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            } error:^(NSDictionary *errorDic) {
                YHLog(@"errer%@", errorDic);
                [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
                [weakSelf reloginAction:nil];
            }];
        }
            
            break;
            //验证绑定帐号页面
        case LeInlandVerifyAssistIDPageIndentifier:
            pageStr = @"LeInlandVerifyAssistIDPageIndentifier";
            break;
            //添加绑定帐号
        case LeInlandAddAssistIDPageIndentifier:
            pageStr = @"LeInlandAddAssistIDPageIndentifier";
            break;
        default:
            break;
    }
}

-(void)changUserByPersonId:(NSString*)personId mode:(NSNumber*)isPosture{
   __block PCPersonModel *model;
   [self.models enumerateObjectsUsingBlock:^(PCPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if([personId isEqualToString:obj.personId]){
           model = obj;
           *stop = YES;
       }
   }];
    if (!model) {
        return;
    }
    
    [self figureAction:isPosture.boolValue? self.postureBtn : self.firgureBtn];//确认记录后重置到体形界面
    [self changUser:model isForce:YES];
}


#pragma mark - MQTT
- (void)mqttAction:(NSNotification*)notice{
    
    NSDictionary *result = notice.userInfo;
//        result = @{@"msgType" : @"figure_result3",
//                                 @"info" : @{
//                                         @"analysisCode" : @(NO),
//                                         @"confirmStatus" : @1,
//                                         @"figureRecordId" : @3531,
//                                         @"personId" : @512,
//                                         @"accountId" : @13
//                                         }
//                                 };
    PCMessageModel *model = [PCMessageModel mj_objectWithKeyValues:result];
    WeakSelf
    PCAlertViewController *vc;
    if ([@"message" isEqualToString:model.msgType]) {
        NSString *info = [result objectForKey:@"info"];
        vc = [PCAlertViewController alertControllerWithTitle:@"消息" message:info];
        [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            
        }];
    }else{
        if (model.info.analysisCode) {//失败
            vc = [PCAlertViewController alertControllerWithTitle:@"本次测量失败，请重新测量" message:nil];
            [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            }];
            [weakSelf presentViewController:vc animated:NO completion:nil];
            return;
        }
        
        if ([@"figure_result" isEqualToString:model.msgType]) {
            if ([model.info.personId isEqualToString:[YHTools sharedYHTools].masterPersion.personId] && model.info.confirmStatus) {
                [weakSelf getLastReport];
            }
        }else{
            if ([model.info.personId isEqualToString:[YHTools sharedYHTools].masterPersion.personId]) {
                [weakSelf getLastPosture];
            }
        }
        
        NSString *message = [NSString stringWithFormat:@"%@%@", model.info.personName, (([@"figure_result" isEqualToString:model.msgType])? (@"体形测量") : (@"体态测量"))];
        
        vc = [PCAlertViewController alertControllerWithTitle:@"测量" message:message];
        [vc addActionWithTitle:@"取消" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
            
        }];
        
        [vc addActionWithTitle:@"查看" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            
            
            
            
            if (![@"figure_result" isEqualToString:model.msgType]) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [weakSelf changUserByPersonId:model.info.personId mode:@(YES)];
//                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
//                PCPostureDetailController *controller = [board instantiateViewControllerWithIdentifier:@"PCPostureDetailController"];
//                controller.model = model;
//                controller.isNews = YES;
//                [self.navigationController pushViewController:controller animated:YES];
                return;
            }
            
            
            PCHistoryContentView *contentVC = [PCHistoryContentView new];
            contentVC.models = [@[model]mutableCopy];
            contentVC.index = 0;
            contentVC.isNews = YES;
            [weakSelf.navigationController pushViewController:contentVC animated:YES];
        }];
    }
    [self presentViewController:vc animated:NO completion:nil];
    
    
}


#pragma mark - 3d人型

-(void)loadWeb3D{
    //    NSString * zipFile = [[NSBundle mainBundle] pathForResource:@"web" ofType:@"zip"];
    
    //    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //    NSString *cachePath = NSHomeDirectory();
    //    NSString *destination = [cachePath stringByAppendingPathComponent:@"/Documents"];
    //解压
    //    BOOL isSuccess = [SSZipArchive unzipFileAtPath:zipFile toDestination:destination];
    
    //如果解压成功则获取解压后文件列表
    //    if (isSuccess)
    {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *destination = [bundle resourcePath];
        NSString *html = [destination stringByAppendingPathComponent:@"index.html"];
        [self loadWeb3D:html];
    }
}



//加载3d人型
- (void)loadWeb3D:(NSString*)html{
    
#if TARGET_IPHONE_SIMULATOR
        return;
#else
#endif
    if (self.webView) {
        return;
    }
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    configuration.userContentController = userController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20 + 44, self.view.frame.size.width, self.view.frame.size.height - 20) configuration:configuration];
    webView.hidden = YES;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [userController addScriptMessageHandler:self name:@"h5ToApp"];
    //    if (@available(iOS 11.0, *)) {
    //        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    } else {
    //        // Fallback on earlier versions
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
    self.webView = webView;
    
    NSString *filePath = html ;
    [webView.configuration.preferences setValue:@(YES) forKey:@"allowFileAccessFromFileURLs"];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:filePath]]];
    [self.view insertSubview:webView aboveSubview:self.homeB];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self performSelector:@selector(showWeb) withObject:nil afterDelay:1.2];
}

- (void)showWeb{
    self.webView.hidden = NO;
}

-(void)pushUriModel:(NSString*)data{
    YHLog(@"%d", data.length);
    if (!data) {
        return;
    }
    DebugTime
    //    [self appToH5:@{@"dsd" : [data substringWithRange:NSMakeRange(data.length - 100, 100)]}];
    NSMutableDictionary *parm = [@{
        @"ply" : data,
        //                                   [self appToH5:@{@"uriUser" : @{@"ply" : [data substringToIndex:200],
        @"id" : [self.recordModel objectForKey:@"figureRecordId"]
    } mutableCopy];
    [parm addEntriesFromDictionary:self.recordModel];
    [self appToH5:@{@"uriUser" : parm
    }];
}
//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"h5ToApp"]) {
        NSDictionary *body = message.body;
        NSString *part = [body objectForKey:@"part"];
        NSString *file = [body objectForKey:@"file"];
        NSString *scale = [body objectForKey:@"scale"];
        NSString *finnish = [body objectForKey:@"finnish"];
        if (finnish) {
            DebugTime
            return;
        }
        YHLog(@"当前的body为： %@", body);
        if (part) {
            //            for (YHCellItem *item  in self.tableModels) {
            for (YHCellItem *item  in self.reportModels) {
                
                if ([[item bodyParts] isEqualToString:part]) {
                    [self checkPart:item];
                    break;
                }
            }
        }else if(file){
            [self loadFile:file];
        } else if(scale){
            PCPartCheckModel model = PCPartCheckModelMiddle;
            if([scale hasSuffix:@"up"]){
                model = PCPartCheckModelUp;
            }else  if([scale hasSuffix:@"down"]){
                model = PCPartCheckModelDown;
            }
            [self.chartCtr partCheckModel:model];
        }
        
    }
}

//加载文件n提供给h5
-(void)loadFile:(NSString*)file{
}

- (void)load3d:(NSNotification*)notice{
    NSDictionary *info = notice.userInfo;
    NSNumber *model = [info objectForKey:@"model"];
    [self load3dModel:model.integerValue];
}

//重置3d
- (void)reset3d{
    [self appToH5:@{@"reset" : @"1"}];
}

//默认数据
- (void)default3d:(PCPersonModel *)masterPersion{
    [self appToH5:@{@"uriDefault" : @(masterPersion.sex)}];
    //    [self appToH5:@{@"uriDefault" : [YHTools sharedYHTools].masterPersion.sex ? @"1" : @"0"}];
}

//对比模式选择
- (void)completeMdeol:(PC3dModel)model{
    //    if (model == PC3dModelCancel) {
    //        [self reset3d];
    //        return;
    //    }
    NSArray *models = @[@"shapping", @"muscle", @"",@"cancel"];
    [self appToH5:@{@"model" : models[model]}];
}

//加载对应模型
- (void)load3dModel:(PC3dModel)model{
    YHLog(@"");
}

- (void)appToH5:(NSDictionary*)info{
    //    NSString *sciptStr = [NSString stringWithFormat:@"appToH5(\'%@\')",[YHTools URLEncodedString:[YHTools data2jsonString:info]]];
    if (self.webView.isLoading) {
        [self performSelector:@selector(appToH5:) withObject:info afterDelay:1];
        return;
    }
    NSString *sciptStr = [NSString stringWithFormat:@"appToH5(\'%@\')",[YHTools data2jsonString:info]];
    //文件不存在会自动创建，文件夹不存在则不会自动创建会报错
//    NSString *path = @"/Users/zhuwensheng/test_export.txt";
//    NSError *error;
//    [sciptStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if (error) {
//        YHLog(@"导出失败:%@",error);
//    }else{
//        YHLog(@"导出成功");
//    }
    [self.webView evaluateJavaScript:sciptStr completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        YHLog(@"alert %@", error);
    }];
    return;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //        [self appToH5:@{@"uriUser":@"models/obj/male"}];
    //    [self appToH5:@{@"uriUser":self.model1}];
    //    [self default3d];
}

@end
