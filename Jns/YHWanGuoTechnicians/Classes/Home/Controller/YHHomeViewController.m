//
//  YHHomeViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/1.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
//#import <LvModelWindow/LvModelWindow.h>
#import "YHHomeViewController.h"
#import "UIViewController+OrderDetail.h"
#import "UIAlertView+Block.h"
#import "YHWebViewController.h"
#import "YHCommon.h"
#import "YHLoginViewController.h"
#import "YHTools.h"
#import "AppDelegate.h"
#import "YHNetworkManager.h"
#import "YHNetworkManager.h"
//#import "MBProgressHUD+MJ.h"
#import "YHCommon.h"
#import "YHJspathAndVersionManager.h"

#import "YHNetworkPHPManager.h"
#import "YHHomeFunctionCell.h"
#import "YHFunctionsEditerController.h"
#import "YHNewOrderController.h"
#import "YHHomeHeaderCell.h"
#import "YHNetworkWeiXinManager.h"
#import "Masonry.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "WXApiManager.h"
#import "YHInquiriesController.h"
#import "YHOrderListController.h"
#import "YHExtrendListController.h"
#import "YHScreeningConditionsController.h"
#import "ALPlayerViewSDKViewController.h"
#import "YHWorkboardListController.h"
#import "YHCheckListViewController.h"//捕车检测单
#import "UILabel+YBAttributeTextTapAction.h"

#import <CoreTelephony/CTCellularData.h>

#import "YHHomeModel.h"

#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "YHMeInfoViewController.h"

#import "YHNewOrderController.h"
#import "YHNewLoginController.h"
#import "YHHomeLastCell.h"
#import "YHStoreBookingViewController.h"

#ifdef YHDebugData
#import "SmartOCRCameraViewController.h"
#endif

#import "YHStoreTool.h"

#import "NewBillViewController.h"
#import "YHAppointmentOrderController.h"

#import "YHPersonCenterController.h"
#import "YHOrderListCell.h"

NSString *const notificationFunction = @"YHNotificationFunction";
extern NSString *const notificationReloadLoginInfo;
extern NSString *const notificationLocationChange;
extern NSString *const notificationLocationFail;
extern NSString *const notificationLogout;
extern NSString *const notificationUpdataUserinfo;
extern NSString *const notificationLocationChange;

@interface YHHomeViewController () < YHLoginDelegate, WXApiManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic)NSDictionary *serviceInfo;
@property(weak, nonatomic)YHHomeHeaderCell *headerCell;
- (IBAction)callAction:(id)sender;
@property (strong, nonatomic)NSDictionary *weixinUserInfo;
@property (strong, nonatomic)NSString *state;
@property (weak, nonatomic) IBOutlet UILabel *distenceL;
@property (weak, nonatomic) IBOutlet UIView *titleBox;
@property (strong, nonatomic) IBOutlet UIView *tableViewHeaderV;
- (IBAction)tableHeaderAction:(id)sender;
@property (strong, nonatomic)NSArray *dataSourceWorks;
- (IBAction)workbordAction:(id)sender;
@property (nonatomic, strong) UIView *sheetView;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *homeArray;

/** 行数 */
@property (nonatomic, assign) NSInteger rows;

@property (nonatomic, assign) CGFloat homeHeaderCellHeight;
@property (nonatomic, assign) CGFloat homeFunctionCellHeight;

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIImageView *titleImgView;
@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, strong) NSString *techSupportDesc;

@property (nonatomic, weak) YHHomeLastCell *lastCell;

@property (nonatomic, weak) YHHomeLastCell *bottomView;

@property (nonatomic, weak) UIView *redPointV;

@property (nonatomic, assign) BOOL isShowBookOrderTotal;

@property (nonatomic, copy) NSString *bookOrderName;

@property (nonatomic , copy)NSString *unfinished_bill_num;// 未完成工单数

@end

@implementation YHHomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initVar];
    
//    [self initUI];
    
    [self initNot];
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGFloat height = IphoneX ? 88 : 64;
    if (self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.frame.size.height - self.tableView.contentSize.height - height > 50) {
        self.bottomView.hidden = NO;
        self.lastCell.hidden = YES;
    }else{
        self.bottomView.hidden = YES;
        self.lastCell.hidden = NO;
    }
}

- (void)initVar{
//    [self.tableView registerNib:[UINib nibWithNibName:@"YHHomeLastCell" bundle:nil] forCellReuseIdentifier:@"YHHomeLastCell"];
}

- (void)initUI{
    
//    self.title = EnvTitle;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    CGRect frame = _titleBox.frame;
    frame.size.width = screenWidth - 80;
    _titleBox.frame = frame;
    
    
    if(!self.redPointV){
    //左
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.backgroundColor = [UIColor blueColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"personInfo"] forState:UIControlStateNormal];
    self.leftBtn.frame = CGRectMake(0, 0, 44, 44);
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    self.leftBtn.backgroundColor = [UIColor clearColor];
    
    UIView *redPointV = [UIView new];
    self.redPointV = redPointV;
    redPointV.frame = CGRectMake(15, 12, 6, 6);
    redPointV.backgroundColor = [UIColor redColor];
    redPointV.layer.cornerRadius = 3.0;
    self.redPointV.hidden = YES;
    [self.leftBtn addSubview:redPointV];
        
    [self isShowRedPoint:NO];
    
    [self.leftBtn addTarget:self action:@selector(pushPersonalCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // newWorkBoard
    [self.rightBtn setImage:[UIImage imageNamed:@"workBoard"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(screenWidth-40, 0, 44, 44);
    self.rightBtn.backgroundColor = [UIColor clearColor];
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
    [self.rightBtn addTarget:self action:@selector(pushWorkVersion) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    }
    
    
    YHHomeLastCell *lastCell = [[NSBundle mainBundle] loadNibNamed:@"YHHomeLastCell" owner:nil options:nil].firstObject;
    lastCell.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 50);
    lastCell.comPanyNameL.text = self.techSupportDesc;
    self.lastCell = lastCell;
    self.tableView.tableFooterView = lastCell;
    
    [self bottomView];
}

- (YHHomeLastCell *)bottomView{
    if (!_bottomView) {
        YHHomeLastCell *bottomView = [[NSBundle mainBundle] loadNibNamed:@"YHHomeLastCell" owner:nil options:nil].firstObject;
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 50, self.tableView.bounds.size.width, 50);
        bottomView.comPanyNameL.text = self.techSupportDesc;
        _bottomView = bottomView;
         [self.view addSubview:bottomView];
    }
    return _bottomView;
}

#pragma mark - pushPersonalCenter ------
- (void)pushPersonalCenter{
    
    [self isShowRedPoint:YES];
    
    YHPersonCenterController *personCenterVc = [[YHPersonCenterController alloc] init];
     personCenterVc.bookOrderName = self.bookOrderName;
     personCenterVc.isShowBookOrderTotal = self.isShowBookOrderTotal;
    [self.navigationController pushViewController:personCenterVc animated:YES];
}

#pragma mark - pushWorkVersion
- (void)pushWorkVersion{
  
    YHWorkboardListController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWorkboardListController"];
    controller.homeArray = self.homeArray;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - initNot
- (void)initNot{
    
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(functionAction:) name:notificationFunction object:nil];
    [center addObserver:self selector:@selector(logoutDelegate:) name:notificationLogout object:nil];
    [center addObserver:self selector:@selector(reloginAction:) name:notificationReloadLoginInfo object:nil];
    [center addObserver:self selector:@selector(locationChange:) name:notificationLocationChange object:nil];
    [center addObserver:self selector:@selector(autoLogin:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView reloadData];
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);

    if (app.isFirstLogin && !app.loginInfo) {
        [self autoLogin:nil];
    }
    //    else {
    //        [self reupdataDatasource];
    //    }
    [self reupdataDatasource];
    [self getUnfinishedBillNum];
    [self getJnsChildMenuList];
    if (_sheetView) {
        [self showSheet:YES];
    }
    [self initUI];
    
//    NSString *orgPointsStatus = [[YHStoreTool ShareStoreTool] orgPointsStatus];
//    if ([orgPointsStatus isEqualToString:@"0"]) {
//        self.redPointV.hidden = YES;
//    }else{
//        BOOL isHideRedPoint = [[YHStoreTool ShareStoreTool] isHideRedPoint];
//        if (isHideRedPoint) {
//            self.redPointV.hidden = YES;
//        }else{
//            self.redPointV.hidden = !self.isShowBookOrderTotal;
//        }
//    }
    
}

- (void)isShowRedPoint:(BOOL)isCheck{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *mydefault = [NSUserDefaults standardUserDefaults];
    NSString *strPoint = [mydefault objectForKey:@"valueRedPoint"];
    strPoint = strPoint.length ? strPoint : @"1";
    NSArray *arrPoint = @[@"3.4.36"];
    

    if([strPoint isEqualToString:@"1"]){
    
        if(isCheck){
            self.redPointV.hidden = YES;
            [mydefault setObject:@"0" forKey:@"valueRedPoint"];
            [mydefault synchronize];
        }else{
            for (NSString *V in arrPoint) {
                if([V isEqualToString:version]){
                     self.redPointV.hidden = NO;
                }
            }
        }
    
    };
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showSheet:NO];
    self.titleView.hidden = YES;
}

- (void)setTechSupportDesc:(NSString *)techSupportDesc{
    _techSupportDesc = techSupportDesc;
    self.lastCell.comPanyNameL.text = techSupportDesc;
    self.bottomView.comPanyNameL.text = techSupportDesc;
}
#pragma mark - 刷新清单 ----
- (void)menuReload
{
    NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
    NSDictionary *data = userInfo[@"data"];
    NSString *type = data[@"type"];// 0 万国 1中心站 2维修厂 4代理商 5 6 大区和渠道商
    NSArray *menuList = data[@"menuList"];
    NSMutableArray *menusArray = [[NSMutableArray alloc]init];
    
    //4代理商 5 6 大区和渠道商 只显示培训和财富
    if ([type isEqualToString:@"4"] || [type isEqualToString:@"5"] || [type isEqualToString:@"6"]) {
        menusArray = [@[[NSNumber numberWithInt:YHFunctionIdTrain],
                        [NSNumber numberWithInt:YHFunctionIdWealth]] mutableCopy];
    }else{        
        for (YHHomeModel *model in self.homeArray) {
            if ([YHHomeViewController getHomePageNumberWithKey:model.code] != nil) {
                [menusArray addObject:[YHHomeViewController getHomePageNumberWithKey:model.code]];
            }
        }
                 
        NSArray *meunKeys = @[
                              //@{@"key" : @"402881fb5acf7dc4015acfa8c04d0007", @"value" : @[[NSNumber numberWithInt:YHFunctionIdCreateWorkOrder]]},
                              //@{@"key" : @"402881fb5acf7dc4015acfa855390006", @"value" : @[[NSNumber numberWithInt:YHFunctionIdNewWorkOrder], [NSNumber numberWithInt:YHFunctionIdUnfinishedWorkOrder]]},
                              //@{@"key" : @"402881fb5acf7dc4015acfa90f800008", @"value" : @[[NSNumber numberWithInt:YHFunctionIdHistoryWorkOrder]]},
                              //@{@"key" : @"402881fb5ad08a98015ad09528400002", @"value" : @[[NSNumber numberWithInt:YHFunctionIdUnprocessedOrder]]},
                              //@{@"key" : @"402881fb5ad08a98015ad095b4530003", @"value" : @[[NSNumber numberWithInt:YHFunctionIdHistoryOrder]]},
                              //@{@"key" : @"2c9180825f0e72de015f14481286006c", @"value" : @[[NSNumber numberWithInt:YHFunctionIdWarranty]]},
                              @{@"key" : @"2c918082604966090160499d41de01f8", @"value" : @[[NSNumber numberWithInt:YHFunctionIdExtrendBack]]},
                              //@{@"key" : @"402881fb5ad08a98015ad0b2c3070027", @"value" : @[[NSNumber numberWithInt:YHFunctionIdFinancialStatements]]},
                              //@{@"key" : @"2c9180865d720dcb015d73d9c5fe0207", @"value" : @[[NSNumber numberWithInt:YHFunctionIdIncomeExpenses]]},
                              ];
        for (NSDictionary *menuInfo in meunKeys) {
            for (NSDictionary *menuItem in menuList) {
                if([menuItem[@"id"] isEqualToString:menuInfo[@"key"]]){
                    [menusArray addObjectsFromArray:menuInfo[@"value"]];
                }
            }
        }
    }
    
    [YHTools setFunctions:menusArray];
    [self.tableView reloadData];
    [self showSheet:YES];
}

- (UIView *)sheetView{
    if (!_sheetView) {
        UIButton * sheetView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
        sheetView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.view addSubview:sheetView];
        //[[UIApplication sharedApplication].keyWindow addSubview:sheetView];
        _sheetView = sheetView;

        UILabel *tip = [[UILabel alloc] init];
        tip.backgroundColor = [UIColor clearColor];
        tip.numberOfLines = 2;
        
        NSString *text = @"你正在使用体验账号，若需要使用全部功能，敬请申请JNS官方授权账号";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:15.0]
                        range:NSMakeRange(0, text.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, text.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor yellowColor]
                        range:[text rangeOfString:@"JNS官方授权账号"]];
        tip.attributedText = attrStr;
        
        [sheetView addTarget:self action:@selector(tableHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
        [sheetView addSubview:tip];
        
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboult"]];
        [sheetView addSubview:leftView];
        leftView.userInteractionEnabled = NO;
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sheetView.mas_centerY).offset(-kTabbarSafeBottomMargin * 0.5);
            make.width.mas_equalTo(39);
            make.height.mas_equalTo(39);
            make.right.mas_equalTo(tip.mas_left).offset(-5);
        }];
        
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setImage:[UIImage imageNamed:@"close_w"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [sheetView addSubview:close];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sheetView.mas_top).offset(-5);
            make.right.mas_equalTo(sheetView.mas_right).offset(5);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(35);
        }];
        
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(sheetView.mas_centerX).offset(20);
            make.centerY.mas_equalTo(leftView.mas_centerY);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(45);
        }];
    }
    return _sheetView;
}

- (void)close{
    [self showSheet:NO];
    self.sheetView.tag = NSIntegerMax;
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    app.isManualLogin = NO;
}

- (void)showSheet:(BOOL)isShow
{
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    BOOL is_experience = [[[app.loginInfo valueForKey:@"data"] valueForKey:@"is_experience"] boolValue];
    if(!is_experience) return;
    
    if(self.sheetView.tag == NSIntegerMax && !app.isManualLogin) {
        return;
    };
    
    //if ([[YHTools getName] isEqualToString:@"12233333333"] && [[YHTools getServiceCode] isEqualToString:@"aib6m"])
    {
        CGFloat y = isShow ? 0 : -15*kStatusBarAndNavigationBarHeight;
        //CGFloat y = isShow ? screenHeight - 80 - kTabbarSafeBottomMargin : screenHeight;
        [UIView animateWithDuration:1.0 animations:^{
            self.sheetView.frame = CGRectMake(0, y, screenWidth, 80);
        }];
    }
}

#pragma mark - 导航栏左边点击事件
- (IBAction)scanAction:(id)sender
{
}
#pragma mark - 加载数据源
- (void)reupdataDatasource
{
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    //获取工作板列表
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getWorkboardList:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        NSLog(@"-----======1.获取工作板列表:%@======-----",info);
        [MBProgressHUD hideHUDForView:self.view];
        
        if (((NSNumber*)info[@"code"]).integerValue == 20000) {
            NSDictionary *data =  [info objectForKey:@"data"];
            weakSelf.dataSourceWorks = [data objectForKey:@"list"];
            [weakSelf refreshNav];
            
            [_headerCell loadDatasourceWorkbord:weakSelf.dataSourceWorks profit:[(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo] sourceInfo:_serviceInfo];
        } else {
            
            [_headerCell loadDatasourceWorkbord:weakSelf.dataSourceWorks profit:[(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo] sourceInfo:_serviceInfo];
            
            weakSelf.dataSourceWorks = @[];
            [weakSelf refreshNav];
            
            if(![weakSelf networkServiceCenter:info[@"code"]]){
                YHLog(@"");
                if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                    //[weakSelf showErrorInfo:info];
                }
            }
        }
        [weakSelf.tableView reloadData];
    } onError:^(NSError *error) {
        weakSelf.dataSourceWorks = @[];
        [weakSelf refreshNav];
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
    //获取店铺信息
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] myShopDetail:[YHTools getServiceCode] onComplete:^(NSDictionary *info) {
        
        NSLog(@"-----======2.获取店铺信息:%@======-----",info);
        NSLog(@"-----======2.获取店铺信息:%@======-----",info[@"data"][@"brandName"]);
        NSLog(@"-----======2.获取店铺信息:%@======-----",info[@"data"][@"descs"]);
        //[[YHNetworkPHPManager sharedYHNetworkPHPManager] getServiceDetail:@"a9b82def52a44bf35a0313fd823017f8" onComplete:^(NSDictionary *info) {
        
        if (((NSNumber*)info[@"code"]).integerValue == 20000) {
        weakSelf.serviceInfo = info[@"data"];
        
        weakSelf.techSupportDesc = info[@"data"][@"techSupportDesc"];
        
        [_headerCell loadDatasourceWorkbord:weakSelf.dataSourceWorks profit:[(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo] sourceInfo:_serviceInfo];
        
        [weakSelf refreshNavUI];

        }else{
            
        if(![weakSelf networkServiceCenter:info[@"code"]]){
            YHLogERROR(@"");
        }
            
        }
        
        [weakSelf.tableView reloadData];
        
    } onError:^(NSError *error) {
        YHLog(@"getServiceDetail eroror");
    }];
}

#pragma mark -  未完成工单数
- (void)getUnfinishedBillNum
{
    // 未完成工单数
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getUnfinishedBillNum:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        self.unfinished_bill_num = info[@"data"][@"unfinished_bill_num"];
    
    } onError:^(NSError *error) {
        
    }];
     
}

#pragma mark  获取JNS下级菜单列表

- (void)getJnsChildMenuList
{
    // 获取JNS下级菜单列表
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getJnsChildMenuList:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        
        [self.homeArray removeAllObjects];
        for (NSDictionary *dict in info[@"data"][@"list"]) {
            YHHomeModel *model = [YHHomeModel mj_objectWithKeyValues:dict];
            [_homeArray addObject:model];
        }
        
         [self.tableView reloadData];
    
    } onError:^(NSError *error) {
        
    }];
     
}


- (void)refreshNavUI {
    //中
//    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 28)];
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
    self.titleView = middleView;
    self.navigationItem.titleView = self.titleView;
    
    //1.有图片
    if (!IsEmptyStr(self.serviceInfo[@"brandLogo"])) {
//        self.titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        UIImageView *titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        self.titleImgView = titleImgView;
        [self.titleImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_JAVA_NavTitle_IMAGE_URL,self.serviceInfo[@"brandLogo"]]]];
        NSLog(@"------%@-------",[NSString stringWithFormat:@"%@%@",SERVER_JAVA_NavTitle_IMAGE_URL,self.serviceInfo[@"brandLogo"]]);
        [self.titleView addSubview:self.titleImgView];
        
//        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImgView.frame) + 8, 0, self.titleView.frame.size.width - self.titleImgView.frame.size.width, self.titleView.frame.size.height)];
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImgView.frame) + 8, 0, self.titleView.frame.size.width - self.titleImgView.frame.size.width, self.titleView.frame.size.height)];
        self.titleLbl = titleLbl;
         [self.titleView addSubview:self.titleLbl];
    //2.无图片
    } else {
//        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.titleView.frame.size.width - self.titleImgView.frame.size.width, self.titleView.frame.size.height)];
       UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.titleView.frame.size.width - self.titleImgView.frame.size.width, self.titleView.frame.size.height)];
        self.titleLbl = titleLbl;
         [self.titleView addSubview:self.titleLbl];
    }
    
    if (!IsEmptyStr(self.serviceInfo[@"brandName"])) {
        self.titleLbl.text = [NSString stringWithFormat:@"%@%@",self.serviceInfo[@"brandName"],NavEnvTitle];
    } else {
        self.titleLbl.text = EnvTitle;
    }
    self.titleLbl.textColor = [UIColor blackColor];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.font = [UIFont systemFontOfSize:20];
    [self.titleLbl sizeToFit];

    //修改titleView的frame
    if (!IsEmptyStr(self.serviceInfo[@"brandLogo"])) {
        self.titleView.frame = CGRectMake(0, 0, self.titleImgView.frame.size.width+self.titleLbl.frame.size.width, self.titleLbl.frame.size.height);
        self.titleImgView.frame = CGRectMake(0, 0, self.titleLbl.frame.size.height, self.titleLbl.frame.size.height);
    } else {
        self.titleView.frame = CGRectMake(0, 0, self.titleLbl.frame.size.width, self.titleLbl.frame.size.height);
    }
}

- (void)refreshNav{
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    BOOL is_experience = [[[app.loginInfo valueForKey:@"data"] valueForKey:@"is_experience"] boolValue];
        // 如果不是体验账号
//    if (is_experience == NO)
//    {
        if (self.dataSourceWorks.count != 0) {
            [self.rightBtn setImage:[UIImage imageNamed:@"newWorkBoard"] forState:UIControlStateNormal];
            self.rightBtn.hidden = NO;
        } else {
            [self.rightBtn setImage:[UIImage imageNamed:@"workBoard"] forState:UIControlStateNormal];
            self.rightBtn.hidden = NO;
        }
        // 如果是体验账号
//    }
//    else
//    {
        // self.rightBtn.hidden = YES;
//    }
    NSString *type = [[app.loginInfo valueForKey:@"data"] valueForKey:@"type"];//0万国 1中心站 2维修厂 4代理商 5 6 大区和渠道商
    //4代理商 5 6 大区和渠道商 体验账号 不显示工作板
    self.rightBtn.hidden = ([type isEqualToString:@"4"] || [type isEqualToString:@"5"] || [type isEqualToString:@"6"] || is_experience);
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    
    if ([identifier isEqualToString:@"map"] || [identifier isEqualToString:@"detail"]) {
        if (![(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo]) {
            [self autoLogin:nil];
            [MBProgressHUD showError:@"请检查网络！"];
            return NO;
        }
    }
    
    if ([identifier isEqualToString:@"me"]) {
        if (![YHTools getAccessToken]) {
            [self reloginAction:nil];
            return NO;
        }
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)locationChange:(NSNotification*)notice
{
    [_headerCell loadDatasourceWorkbord:self.dataSourceWorks profit:[(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo] sourceInfo:_serviceInfo];
}

#pragma mark - 自动登录(梅文峰)
- (void)autoLogin:(NSString*)code
{
//    [self.homeArray removeAllObjects];
    
#ifdef LearnVersion
    
    YHWebFuncViewController *webFuncVc = (YHWebFuncViewController *)self.navigationController.visibleViewController;
    
#ifdef YHProduction
    NSString *needLoadUrl = [NSString stringWithFormat:@"https://s.laijingedu.cn/eduWeb/#/?orgId=%@",OrgId];
    webFuncVc.urlStr = [NSString stringWithFormat:@"https://s.laijingedu.cn/eduWeb/#/?orgId=%@",OrgId];
    
#else
    webFuncVc.urlStr = @"http://192.168.1.200/eduWeb";
    NSString *needLoadUrl = @"http://192.168.1.200/eduWeb";
#endif
    webFuncVc.barHidden = YES;
    
    [webFuncVc loadWebPageWithString:needLoadUrl];
    [self.navigationController popToRootViewControllerAnimated:YES];
#else
    //用户登录过
    if ([YHTools getAccessToken]) {
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] userInfo:[YHTools getAccessToken]
                                                       onComplete:^(NSDictionary *info)
         {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:[info mutableCopy]];
    
                 [weakSelf refreshNav];
                 NSArray * indexMenuArray = info[@"data"][@"indexMenu"];
                 NSArray *menuListArr;
                 NSString *orgPoints = info[@"data"][@"orgPoints"];
                 NSString *orgPointsStatus = info[@"data"][@"orgPointsStatus"];
                 NSString *orgName = info[@"data"][@"orgName"];
                 NSString *realname = info[@"data"][@"realname"];
                 [[YHStoreTool ShareStoreTool] setOrgPoints:orgPoints];
                 [[YHStoreTool ShareStoreTool] setOrgPointsStatus:orgPointsStatus];
                 
                 [[YHStoreTool ShareStoreTool] setOrgName:orgName];
                 [[YHStoreTool ShareStoreTool] setRealname:realname];
                 
                __block BOOL isShowBookTotal = NO;
                 __block NSString *name = nil;
                 [menuListArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj[@"id"] isEqualToString:@"2c91808268ee9dbe016900066efc0517"]) {
                         *stop = YES;
                         isShowBookTotal = YES;
                         name = obj[@"name"];
                     }
                 }];
                 self.isShowBookOrderTotal = isShowBookTotal;
                 self.bookOrderName = name;
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLogERROR(@"");
                 }
             }
             
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
        
        [self reupdataDatasource];
        //用户没有登录过
    }else{
        NSArray *controllers = self.navigationController.viewControllers;
        for (NSUInteger i = 0; i < controllers.count; i++) {
            if ([controllers[i] isKindOfClass:[YHNewLoginController class]]) {
                return;
            }
        }
        //  YHLoginViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
        // [self.navigationController pushViewController:controller animated:NO];
        
        YHNewLoginController *newLoginVc = [[YHNewLoginController alloc] init];
        if([code isKindOfClass:[NSString class]] && [code isEqualToString:@"登录超时，请重新登录"]) {
            newLoginVc.errorMsg = code;
        }
        [self.navigationController pushViewController:newLoginVc animated:NO];
    }
#endif
    //检测用户网络权限
    [self networkStatusLimitStatus];
}

#pragma mark - CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题获取网络权限状态
- (void)networkStatusLimitStatus {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10) {
        return;
    }
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    // 此函数会在网络权限改变时再次调用
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
                // 权限关闭的情况下 再次请求网络数据会弹出设置网络提示
            {
                NSLog(@"用户已经关闭网络访问权限拒绝");
                [self alertPromptToSystemNetwort:@"应用JNS的无线网络权限已关闭"];
            }
                break;
            case kCTCellularDataNotRestricted:
                //  已经开启网络权限 监听网络状态
            {
                NSLog(@"已开启网络权限");
            }
                break;
            case kCTCellularDataRestrictedStateUnknown:
                //未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
            {
                NSLog(@"未知情况");
                [self alertPromptToSystemNetwort:@"应用JNS的无线网络权限未知"];
            }
                break;
                
            default:
                break;
        }
    };
}

#pragma mark - 跳转到系统蜂窝网络界面 ----
- (void)alertPromptToSystemNetwort:(NSString *)promptText{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        return;
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:promptText message:@"请前往系统：设置->蜂窝移动网络->使用无线局域网与蜂窝移动的应用中设置，否则会影响应用的正常使用" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳转到系统设置蜂窝网络
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}
- (void)logoutDelegate:(NSNotification*)notice{
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] LogoutOnComplete:^(NSDictionary *info) {
        
    } onError:^(NSError *error) {
        
    }];
    [YHTools setAccessToken:nil];
    //  [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:nil];
}

- (void)reloginAction:(NSNotification*)notice{
    [YHTools setAccessToken:nil];
    [self autoLogin:@"登录超时，请重新登录"];
}
#pragma mark --首页小虎联盟点击item跳转监听 ---
- (void)functionAction:(NSNotification*)obj{
    
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//     YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
//    [controller depthDiagnose:nil billType:nil];
//    [self.navigationController pushViewController:controller animated:YES];
//
#ifdef YHDebugData
    SmartOCRCameraViewController *controller = [[SmartOCRCameraViewController alloc] init];
    // 竖屏
    controller.recogOrientation = RecogInVerticalScreen;
    controller.isLocation = NO;
    [self.navigationController pushViewController:controller animated:YES];
    return;
#endif
    
    NSNumber *functionK = obj.object;
    YHHomeModel *model = ((YHHomeModel *)obj.userInfo);
    NSString *encodeTitle = [YHTools encodeString:model.title];
//    NSString *encodeTitle = [YHTools encodeString:@"预订单统计"];
    if (![model.status isEqualToString:@"1"]) {
            [self showImageByCode:model.code hasNeedBuy:!model.buyStatus with:YES];
        // [self shwoImage:@"https://images.mhace.cn/cloudImg/intro/1.png"];
    }else{
        
        //http://www.mhace.cn/jnsDev/index.html?token=4cb138e8039b05a0e1fae0727214e5c5&status=ios&menuCode=menu_bill#/menu
//        NSString * urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios&menuCode=%@#/menu",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],model.code];
         NSString * urlStr = [[model.route_h5 stringByReplacingOccurrencesOfString:@"_TOKEN_" withString:[YHTools getAccessToken]] stringByReplacingOccurrencesOfString:@"_APP_" withString:@"ios"];
        urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlStr,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));

        if (functionK.integerValue == YHFunctionIdAll) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHFunctionsEditerController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdDiagnosis || functionK.integerValue == YHFunctionIdFinancialStatements){
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            if (functionK.integerValue == YHFunctionIdFinancialStatements) {
                controller.title = @"财务统计";
                controller.barHidden = YES;
            }else{
                
                controller.title = @"工单";
                controller.barHidden = YES;
            }
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
            
            // UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            // YHInquiriesController *controller = [board instantiateViewControllerWithIdentifier:@"YHInquiriesController"];
            // [self.navigationController pushViewController:controller animated:YES];
        }else  if(functionK.integerValue == YHFunctionIdIncomeExpenses ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"其他收支";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdNewWorkOrder
                 || functionK.integerValue == YHFunctionIdHistoryWorkOrder
                 || functionK.integerValue == YHFunctionIdUnfinishedWorkOrder
                 || functionK.integerValue == YHFunctionIdUnprocessedOrder
                 || functionK.integerValue == YHFunctionIdHistoryOrder){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHOrderListController *controller = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
            controller.functionKey = functionK.integerValue;
            [self.navigationController pushViewController:controller animated:YES];
        } else  if(functionK.integerValue == YHFunctionIdExtrendBack ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"返现管理";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdWarranty){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            YHExtrendListController *controller = [board instantiateViewControllerWithIdentifier:@"YHExtrendListController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdWorkshop
//                 || functionK.integerValue == YHFunctionIdHelper
                 || functionK.integerValue == YHFunctionIdTrain
                 || functionK.integerValue == YHFunctionIdWealth
                 || functionK.integerValue == YHFunctionIdSecondCar){
            
            NSString *urlTruckStr =   @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"billimenu.html?menuId=3&",@"menu.html?",@"technicalAssistant/index.html?",@"wealth.html?",@"oldCar.html?",@""][functionK.integerValue];
#warning 工单管理 ---
            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title =  model.title;
            controller.functionK = functionK.integerValue;
            BOOL isFirst = [(AppDelegate*)[[UIApplication sharedApplication] delegate] isFirstLogin];
            if (((functionK.integerValue == YHFunctionIdWealth) && (isFirst))) {
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:NO];
            }
            controller.barHidden = !(functionK.integerValue == YHFunctionIdTrain);
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdSecondCarCheck){//二手车检测
            YHCheckListViewController *VC = [[UIStoryboard storyboardWithName:@"YHCheckList" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCheckListViewController"];
            [self.navigationController pushViewController:VC animated:YES];
        }else  if(functionK.integerValue == YHFunctionIdGoodFor ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"优供";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdGood ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"优供";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdCarCondition ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"车况";
            controller.barHidden = NO;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdSecurityInspection ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"安全检测";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdExtendTheWarranty ){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"延长质保";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
            //预约订单(MWF)
        }else if(functionK.integerValue == YHFunctionIdReservationOrder ){
            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
            //智能解决方案(MWF)
        }else if(functionK.integerValue == YHFunctionIdIntelligentSolution ){
            
            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            //  controller.urlStr = [NSString stringWithFormat:@"http://192.168.1.245:8014/resolveSolution/index.html?token=%@&status=ios#/", [YHTools getAccessToken]];
            //http://static.demo.com/app/resolveSolution/?token=ca6408299b8703a31ca65991e607e668&status=ios#/vin
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdProfessionExamine ){
            // 专项检测
            // http://static.demo.com/app/index.html?token=ed8cd9ec3b54ddeefdd9698acfa007d1&dedicatedType=J003&status=ios/
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"专项检测";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if(functionK.integerValue == YHFunctionIdSecondHandBussinesman ){
            // 二手车商
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"二手车商";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if(functionK.integerValue == YHFunctionIdValueAddedProject ){
            //增值项目(MWF)
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"增值项目";
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(functionK.integerValue == YHFunctionIdHelper){
            NSString *urlTruckStr =   @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"menu",@"training",@"technicalAssistant/index",@"wealth",@"oldCar",@""][functionK.integerValue];
            BOOL isFirst = [(AppDelegate*)[[UIApplication sharedApplication] delegate] isFirstLogin];

            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
            NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
            controller.type = YYNewBillStyleHelpHelper;
            controller.imageByCode = model.code;
            controller.isShowImageBtn = YES;
            controller.webURLString = [NSString stringWithFormat:@"%@%@/%@.html?token=%@&status=ios%@&menuCode=%@&menuName=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, urlTruckStr, [YHTools getAccessToken], (((functionK.integerValue == YHFunctionIdWealth) && (isFirst))? (@"&first=1") : (@"")),model.code,encodeTitle];
            [controller setControllerTitle:@"智能保养"];
            controller.webURLString = urlStr;
            [self.navigationController pushViewController:controller animated:YES];

        }else if (functionK) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.barHidden = YES;
            controller.urlStr = urlStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self notImplementedViewController:nil];
        }
    }
}

#pragma mark - SendAuthResp
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
    
    __block typeof(self) weakSelf = self;
    if (response.errCode == 0 && [_state isEqualToString:response.state]) {
        
        //[YHTools setWeixinCode:response.code];
        [weakSelf autoLogin:response.code];
        /*
         [[YHNetworkWeiXinManager sharedYHNetworkWeiXinManager]getAccessTokenByCode:response.code onComplete:^(NSDictionary *info) {
         [YHTools setWeixinAccessInfo:info];
         [weakSelf getWeixinUserInfo];
         [weakSelf autoLogin];
         } onError:^(NSError *error) {
         YHLog(@"AccessToken 获取失败");
         }];
         */
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"授权失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 2;
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
        //    NSArray *functions = [YHTools getFunctions];
        NSUInteger acount = self.homeArray.count;
        NSInteger rows = acount / 3 + ((acount % 3) ? (1) : (0)) + 2;
        self.rows = rows;
        return rows;
//    } else {
//        return 1;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YHHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellHeader" forIndexPath:indexPath];
            self.headerCell = cell;
            [_headerCell loadDatasourceWorkbord:self.dataSourceWorks profit:[(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo] sourceInfo:_serviceInfo];
            return cell;
        }else if(indexPath.row >= 2){
            YHHomeFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMenu" forIndexPath:indexPath];
            NSArray *cellAr = [NSArray array];
            NSInteger row = ceil(self.homeArray.count / 3);
            if(row == indexPath.row - 1){//最后一行
                cellAr = [self.homeArray subarrayWithRange:NSMakeRange((indexPath.row - 2) * 3, self.homeArray.count % 3 ?: 3)];
            }else{
                cellAr = [self.homeArray subarrayWithRange:NSMakeRange((indexPath.row - 2) * 3, 3)];
            }
            [cell loadDatasource:cellAr];
            cell.rows = self.rows;
            cell.indexPath = indexPath;
            return cell;
        }
    
    YHOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellList" forIndexPath:indexPath];
    cell.numLb.text = [NSString stringWithFormat:@"%@单进行中",self.unfinished_bill_num];
    cell.numLb.hidden = !self.unfinished_bill_num.integerValue;
    return cell;
//    } else {
//        YHHomeLastCell *lastCell = [tableView dequeueReusableCellWithIdentifier:@"YHHomeLastCell"];
//        lastCell.comPanyNameL.text = self.techSupportDesc;
//        return lastCell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSDictionary *profit = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
            NSDictionary *data = profit[@"data"];
            NSString *availableCashback = data[@"availableCashback"];
            NSString *currentMonthIncome = data[@"currentMonthIncome"];
            NSString *alreadyWithdraw = data[@"alreadyWithdraw"];
            float bottomHeight = 80;
            
            
            BOOL h_earning_status = [data[@"h_earning_status"] boolValue];// 首页收入模块显示状态: 1-显示，0-隐藏
            if (!h_earning_status) {
            //if (availableCashback.floatValue == 0. && currentMonthIncome.floatValue == 0. && alreadyWithdraw.floatValue == 0. && (!_dataSourceWorks || _dataSourceWorks.count == 0)){
                bottomHeight -= 80;
            }
            
            float h = screenWidth * 425 / 750;
            self.homeHeaderCellHeight = h + bottomHeight;
            return self.homeHeaderCellHeight;
        } else if(indexPath.row >= 2){
            self.homeFunctionCellHeight = 10 + (screenWidth - 10 - 9 -9 - 11) / 3;
            return self.homeFunctionCellHeight;
        } else{
            return 56;
        }
//    } else {
//        NSUInteger acount = self.homeArray.count;
//        NSInteger count = acount / 3 + ((acount % 3) ? (1) : (0));
//        if (self.tableView.frame.size.height > (self.homeHeaderCellHeight + self.homeFunctionCellHeight * count)) {
//            if (IphoneX) {
//                return (self.tableView.frame.size.height - (self.homeHeaderCellHeight + self.homeFunctionCellHeight * count) - NavbarHeight);
//            } else {
//                return (self.tableView.frame.size.height - (self.homeHeaderCellHeight + self.homeFunctionCellHeight * count) - 30);
//            }
//        } else {
//            return 50;
//        }
//    }
}
/**
 仅限体验账号登录后显示：
 站点编码：aib6m
 账号：12233333333
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    [YHTools setName:@"12233333333"];
    //    [YHTools setServiceCode:@"aib6m"];
    //    if ([[YHTools getName] isEqualToString:@"12233333333"] && [[YHTools getServiceCode] isEqualToString:@"aib6m"]) {
    //        return 40;
    //    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _tableViewHeaderV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    //controller.urlStr = [NSString stringWithFormat:@"%@%@/detection/index.html?token=%@&status=ios&menuCode=menu_bill&billType=all#/Check",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken]];
    controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios&billType=all#/bill/reportCheckList",SERVER_PHP_URL_Statements_H5_Vue, [YHTools getAccessToken]];
    //http://www.mhace.cn/jnsDev/index.html?token=abae9992f79db148c2c6ee88c2dc62d2&status=ios&billType=all#/bill/reportCheckList

    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
                   
                   
}

- (IBAction)callAction:(id)sender {
    if (![(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo]) {
        [self autoLogin:nil];
        [MBProgressHUD showError:@"请检查网络！"];
        return;
    }
    
    NSString * phoneNum = _serviceInfo[@"tel"];
    if ([phoneNum hasPrefix:@"("]) {
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@"-"];
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",phoneNum];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 工作板跳转
- (IBAction)workbordAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHWorkboardListController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkboardListController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tableHeaderAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.title = @"申请正式账号";
    controller.urlStr = [NSString stringWithFormat:@"%@%@/applyAccount/apply.html?token=%@&status=ios",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken]];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)homeArray
{
    if (!_homeArray) {
        _homeArray = [[NSMutableArray alloc]init];
    }
    return _homeArray;
}

#pragma mark - 获取首页key
+ (NSNumber *)getHomePageNumberWithKey:(NSString *)key{
    NSDictionary *valus = @{@"menu_safe_check" : @(YHFunctionIdSecurityInspection),// 安全检测
                            @"menu_block_policy" : @(YHFunctionIdExtendTheWarranty),// 延长质保==>延长保修
                            @"menu_bill" : @(YHFunctionIdWorkshop),//车间 （工单管理）==>门店自营
                            @"menu_project_training" : @(YHFunctionIdTrain),//培训 （项目培训)==>门店运营
                            @"menu_division" : @(YHFunctionIdWealth),//财富 （项目分成）
                            @"menu_help" : @(YHFunctionIdHelper),//帮手 （技术帮手）
                            @"menu_recruitment" : @(YHFunctionIdGood),//（优才） （人才优配）
                            @"menu_quality_merchant" : @(YHFunctionIdGoodFor),//（优供） （优供商城）
                            @"menu_quality_merchant" : @(YHFunctionIdCarCondition),//（车况） （车况查询）
                            @"bill_car_maintain" : @(YHFunctionIdReservationOrder),//预约订单(MWF)
                            @"menu_solution" : @(YHFunctionIdIntelligentSolution),//智能解决方案(MWF)
                            @"specialCheck" : @(YHFunctionIdProfessionExamine), // 专项检测
                            @"usedCarDealer": @(YHFunctionIdSecondHandBussinesman), // 二手车商
                            @"increment_item": @(YHFunctionIdValueAddedProject),//增值项目(MWF)
                            
//menu_solution -> 汽修百科
//menu_project_training -> 智慧门店
//menu_bill -> 智能安检
//menu_safe_check -> 智能诊断
//menu_help_sell -> 估值帮卖
//menu_block_policy -> 质保风控
//menu_m_gas -> M站尾气
//menu_cold -> AI制冷
//menu_quality_merchant -> 查供应商
                            @"menu_help_sell": @(YHFunctionIdHelpSell),//增值项目(MWF)
                            @"menu_m_gas": @(YHFunctionIdMGas),//增值项目(MWF)
                            @"menu_cold": @(YHFunctionIdCold),//增值项目(MWF)

                            
                            };
    return valus[key];
}


@end
