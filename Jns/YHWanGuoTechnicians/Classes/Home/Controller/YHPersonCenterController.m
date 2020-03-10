//
//  YHPersonCenterController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/3.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHPersonCenterController.h"
#import "YHPersonPresenter.h"
#import "UIView+Frame.h"
#import "YHPersonNormalCell.h"
#import "YHPersonEspecialCell.h"
#import "YHWebFuncViewController.h"
#import "YHModifyPassWordController.h"
#import "YHNewNavigationBar.h"
#import "AppDelegate.h"
#import "YHNewLoginStationListController.h"
#import "YHNewLoginController.h"
#import "YHAppIntroduceController.h"
#import "YTBalanceController.h"
#import "YHStoreTool.h"
#import "YHCarPhotoService.h"
#import "TTZCheckViewController.h"
#import "YHPersonCenterHeaderView.h"
#import "YHPersonCenterVCView.h"

static int safeHight = 34;

@interface YHPersonCenterController ()<YHPersonPresenterDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)YHPersonPresenter *presenter;

@property (nonatomic, strong) NSMutableArray *personList;

@property (nonatomic, weak) UITableView *personTableView;

@property (nonatomic, weak) UIView *hunView;

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, strong) YHNewNavigationBar *navigationBar;

@property (nonatomic, strong) YHPersonCenterHeaderView *headerView;

@property (nonatomic, strong) YHPersonCenterVCView *headview;

@property (nonatomic, copy) NSString *userOpenId;

@property (nonatomic, strong) UIView *v1;//蒙版

@property (nonatomic, strong) UIView *v2;//蒙版

@end

@implementation YHPersonCenterController

-(void)loadView{
    self.headview = [[YHPersonCenterVCView alloc]init];
    self.headview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.view = self.headview;
}

- (void)test{
    
    NSString *bill_id = @"17209";
    NSString *bill_type = @"J005";
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] getJ005ItemBillId:bill_id success:^(NSMutableArray<TTZSYSModel *> *models, NSDictionary *baseInfo) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TTZCheckViewController *vc = [TTZCheckViewController new];
        vc.is_circuitry = YES;
        vc.sysModels = models;
        vc.title = @"深度诊断";
        vc.billId = bill_id;
        vc.billType = bill_type;
        vc.currentIndex = 0;
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        
    }];
    return;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [[YHPersonPresenter alloc] initWithDelegate:self];
    [self.presenter getPersonCenterData]; // 启动
    [self setUpUI];
    //    [self getPersonCenterMineInfo];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//白色
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.personTableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//黑色
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)setUpUI{
    
    CGFloat topMargin = IphoneX ? 44 : 20;
  
    self.headerView = [[NSBundle mainBundle]loadNibNamed:@"YHPersonCenterHeaderView" owner:nil options:nil].firstObject;
    [self.view addSubview:self.headerView];
    self.headview.headerV = self.headerView;
    self.headerView.backgroundColor = YHNaviColor;
    self.headerView.topLayout.constant = 40 + topMargin;
    self.headerView.NewBtn.hidden = YES;//[YHTools getPersonCenterNewService];//是否显示新功能
    
    UIButton *headerBtn = [[UIButton alloc]init];
    headerBtn.tag = 3;
    [headerBtn addTarget:self action:@selector(chickDown:) forControlEvents:UIControlEventTouchDown];
    [self.headerView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(self.headerView.NewBtn);
        make.top.equalTo(self.headerView.realNameLab);
        make.bottom.equalTo(self.headerView.orgNameLab);
    }];
    
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
//        make.height.equalTo(@(168 + topMargin + 44));
    }];
    YHNewNavigationBar *newNavigationBar = [[NSBundle mainBundle] loadNibNamed:@"YHNewNavigationBar" owner:nil options:nil].firstObject;
    newNavigationBar.backgroundColor = YHNaviColor;
    [self.view addSubview:newNavigationBar];
    self.navigationBar = newNavigationBar;
    [newNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.height.equalTo(@(44 + topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(chickDown:) forControlEvents:UIControlEventTouchDown];
    [self.headerView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(UIEdgeInsetsMake(0, 0, 12, 0));
        make.height.equalTo(@60);
        make.width.equalTo(@(self.headerView.width/2));
    }];
    
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(chickDown:) forControlEvents:UIControlEventTouchDown];
    [self.headerView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(UIEdgeInsetsMake(0, 0, 12, 0));
        make.height.equalTo(@60);
        make.width.equalTo(@(self.headerView.width/2));
    }];
    
    [newNavigationBar.middleBtn setTitle:@"我的" forState:UIControlStateNormal];
    [newNavigationBar.leftBtn setImage:[[UIImage imageNamed:@"left_login"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    //    newNavigationBar.leftBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 28);
    [newNavigationBar.rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [newNavigationBar.leftBtn addTarget:self action:@selector(leftBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [newNavigationBar.rightBtn addTarget:self action:@selector(rightBtnBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *personTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:personTableView];
    self.personTableView = personTableView;
    personTableView.backgroundColor = [UIColor clearColor];
    [personTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newNavigationBar.mas_bottom);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.bottom.equalTo(@0);
    }];
    personTableView.delegate = self;
    personTableView.dataSource = self;
    //    personTableView.scrollIndicatorInsets = UIEdgeInsetsMake(180,0,200,0);
    personTableView.showsVerticalScrollIndicator = NO;
    personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    personTableView.contentInset = UIEdgeInsetsMake(154, 0, 0, 0);
    [personTableView registerNib:[UINib nibWithNibName:@"YHPersonNormalCell" bundle:nil] forCellReuseIdentifier:@"YHPersonNormalCell"];
    [personTableView registerNib:[UINib nibWithNibName:@"YHPersonEspecialCell" bundle:nil] forCellReuseIdentifier:@"YHPersonEspecialCell"];
    
    
//    if(![YHTools getPersonCenterMask]){//显示蒙版
//
//        self.headview.isMask = YES;
//
//        UIView *v1 = [[UIView alloc]init];
//        self.v1 = v1;
//        v1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//        [self.view addSubview:v1];
//        [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(0);
//            make.bottom.equalTo(headerBtn.mas_top).mas_offset(-8);
//            make.width.offset(screenWidth);
//        }];
//
//
//        UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40 + topMargin)];
//        v2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//        [self.view addSubview:v2];
//        self.v2 = v2;
//        [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headerBtn.mas_bottom).mas_offset(8);
//            make.width.offset(screenWidth);
//            make.bottom.offset(0);
//        }];
//
//
//        UIImageView *imv = [[UIImageView alloc]init];
//        imv.image = [UIImage imageNamed:@"jiantou"];
//        [v2 addSubview:imv];
//        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(8);
//            make.centerX.equalTo(self.headerView.orgNameLab);
//        }];
//
//        UILabel *lb = [[UILabel alloc]init];
//        lb.numberOfLines = 2;
//        lb.textColor = [UIColor whiteColor];
//        lb.text = @"个人业绩/工单统计已经整合到这里面了\n点击即可进入查看";
//        [v2 addSubview:lb];
//        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(imv.mas_bottom).offset(8);
//            make.left.offset(12);
//
//        }];
//
//
//        UIButton *btn = [[UIButton alloc]init];
//        [btn setTitle:@"我知道了" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithHexString:@"#464646"] forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor whiteColor];
//        [v2 addSubview:btn];
//        btn.layer.cornerRadius = 8.0;
//        self.headview.btnMask = btn;
//        [btn addTarget:self action:@selector(chickMask) forControlEvents:UIControlEventTouchDown];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(12);
//            make.right.offset(-12);
//            make.height.offset(44);
//            make.bottom.offset(-24);
//        }];
//
//    }

}


-(void)chickMask{
    
    self.headview.isMask = NO;
    
    [self.v1 removeFromSuperview];
    
    [self.v2 removeFromSuperview];
    
    [YHTools setPersonCenterMask:@"1"];
    
}

-(void)viewDidLayoutSubviews{
   
    if(self.personTableView.frame.size.height < self.personTableView.contentSize.height + 12 + 20){
        self.personTableView.contentInset = UIEdgeInsetsMake(154, 0, 20, 0);
    }else{
        self.personTableView.contentInset = UIEdgeInsetsMake(154, 0, self.personTableView.frame.size.height - self.personTableView.contentSize.height - 12 - (IphoneX ? safeHight : 0), 0);
    }
}

-(void)chickDown:(UIButton*)btn{
    
    if(btn.tag == 1){
        YTBalanceController *vc = [[UIStoryboard storyboardWithName:@"Balance" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBalanceController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(btn.tag == 2){
        
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.title =  @"我的钱包";
        BOOL isFirst = [(AppDelegate*)[[UIApplication sharedApplication] delegate] isFirstLogin];
        if (isFirst) {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:NO];
        }
        controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&jnsAppStep=myWallet&status=ios#/appToH5",SERVER_PHP_URL_Statements_H5_Vue, [YHTools getAccessToken]];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if(btn.tag == 3){//跳转到新功能
        self.headerView.NewBtn.hidden = YES;
        [YHTools setPersonCenterNewService:@"1"];
        
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.title = @"个人统计";
        controller.urlStr =  [NSString stringWithFormat:@"%@/index.html?token=%@%@&jnsAppStep=workingStatistics&status=ios#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.userOpenId.length ? [NSString stringWithFormat:@"&userId=%@",self.userOpenId] : @""];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//scrollViewDelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat y = scrollView.contentOffset.y;
    
    if(y > -80){
        
        *targetContentOffset = CGPointMake(0, -12);
        
    }else{
        
        *targetContentOffset = CGPointMake(0, -154);
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f", fabs(y));//180-12
    CGFloat x = fabs(y);
    if(x > 54 && x <= 154 && y < 0){
        CGFloat f = (x - 54)/100.f;
        self.headerView.alpha = f;
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((-154 - y)/3);
        }];
        
        
        self.navigationBar.backgroundColor = YHColor((69 + (255 - 69) * (1- f)), (175 + (255 - 175) * (1- f)), (247 + (255 - 247) * (1- f)));
        // self.navigationBar.tintColor = YHColor(255 - 255 * fabs(y), 255 - 255 * fabs(y), 255 - 255 * fabs(y));
        
        [self.navigationBar.middleBtn setTitleColor:YHColor(255 * f, 255 * f, 255 * f) forState:UIControlStateNormal];
        [self.navigationBar.leftBtn setTintColor:YHColor(255 * f, 255 * f, 255 * f)];
        [self.navigationBar.rightBtn setTitleColor:YHColor(255 * f, 255 * f, 255 * f) forState:UIControlStateNormal];
        
        [UIApplication sharedApplication].statusBarStyle = x < 98 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;//黑色//白色
        
    }else if(y < 0){//防止快速滑动产生问题
        
        if(x < 54){
            
            self.headerView.alpha = 0;
            self.navigationBar.backgroundColor = YHColor(255, 255, 255);
            [self.navigationBar.middleBtn setTitleColor:YHColor(0, 0,0) forState:UIControlStateNormal];
            [self.navigationBar.leftBtn setTintColor:YHColor(0, 0, 0)];
            [self.navigationBar.rightBtn setTitleColor:YHColor(0, 0, 0) forState:UIControlStateNormal];
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-100);
            }];
             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];//设置状态栏字体为白色[[UIApplication sharedApplication]
        }
        
        if(x > 154){
            
            self.headerView.alpha = 1;
            self.navigationBar.backgroundColor = YHNaviColor;
            [self.navigationBar.middleBtn setTitleColor:YHColor(255, 255 , 255) forState:UIControlStateNormal];
             [self.navigationBar.leftBtn setTintColor:YHColor(255, 255, 255)];
            [self.navigationBar.rightBtn setTitleColor:YHColor(255, 255, 255) forState:UIControlStateNormal];
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//设置状态栏字体为白色[[UIApplication sharedApplication]
        }
    }
}

- (void)leftBtnClickEvent:(UIButton *)leftBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 更多 -----
- (void)rightBtnBtnClickEvent:(UIButton *)rightBtn{
    
    UIView *hunView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.hunView = hunView;
    hunView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:hunView];
    UIImageView *alertView = [[UIImageView alloc] init];
    alertView.image = [UIImage imageNamed:@"alertBackground"];
    alertView.userInteractionEnabled = YES;
    CGFloat Y = IphoneX ? 88 : 64;
    alertView.frame = CGRectMake(screenWidth - 124, Y, 112, 0);
    
    NSMutableArray *titleArr = [NSMutableArray array];
    
    if ([self.info[@"code"] intValue] == 30100) {
        [titleArr addObject:@"更换站点"];
    }
    
    [titleArr addObject:@"退出登录"];
    [titleArr addObject:@"修改密码"];
    //    [titleArr addObject:@"自定义布局"];
    
    for (int i = 0; i<titleArr.count; i++) {
        UILabel *item = [UILabel new];
        item.tag = i + 1000;
        [alertView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(13 + i*(20+16)));
            make.left.equalTo(@(15));
            make.right.equalTo(@(-15));
            make.height.equalTo(@(16));
        }];
        item.textColor = [UIColor colorWithHexString:@"#666666"];
        item.textAlignment = NSTextAlignmentLeft;
        item.font = [UIFont systemFontOfSize:15.0];
        item.text = titleArr[i];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [item addGestureRecognizer:tapGes];
        item.userInteractionEnabled = YES;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        alertView.frame = CGRectMake(screenWidth - 124, Y, 112, titleArr.count *16 + (titleArr.count - 1)*20 + 25);
    }];
    
    [hunView addSubview:alertView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.hunView) {
        [self.hunView removeFromSuperview];
    }
    
    //    [self test];
}

- (void)tapEvent:(UITapGestureRecognizer *)tapGes{
    
    [self.hunView removeFromSuperview];
    
    UIView *touchView = tapGes.view;
    NSInteger index = touchView.tag - 1000;
    void(^opreation)(void)  = [self getOpreation:index];
    if (opreation) {
        opreation();
    }
}

- (void(^)(void))getOpreation:(NSInteger)index{
    
    void(^replaceOpreation)() = ^{
        
        YHNewLoginStationListController *stationListVC = [[YHNewLoginStationListController alloc] init];
        stationListVC.stationListArr = self.info[@"data"][@"list"];
        stationListVC.userName = [YHTools getName];
        stationListVC.passWord = [YHTools getPassword];
        [self.navigationController pushViewController:stationListVC animated:YES];
        
        
    };
    void(^loginOutOpreation)() = ^{
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] LogoutOnComplete:^(NSDictionary *info) {
            
        } onError:^(NSError *error) {
            
        }];
        
        [YHTools setAccessToken:nil];
        
        YHNewLoginController *newLoginVc = [[YHNewLoginController alloc] init];
        [self.navigationController pushViewController:newLoginVc animated:YES];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.loginInfo = nil;
        
        
    };
    void(^madifyPwdOpreation)() = ^{
        
        YHModifyPassWordController *modifyViewController = [[YHModifyPassWordController alloc] init];
        [self.navigationController pushViewController:modifyViewController animated:YES];
        
    };
    //    // 自动布局
    //    void(^aotuLayOutOpreation)() = ^{
    //    };
    NSMutableArray *op = [NSMutableArray array];
    if ([self.info[@"code"] intValue] == 30100) {
        [op addObject:replaceOpreation];
    }
    [op addObject:loginOutOpreation];
    [op addObject:madifyPwdOpreation];
    
    return op[index];
    
}
#pragma mark -----YHPersonPresenterDelegate -------
- (void)setPersonCenterData:(NSMutableArray<YHPersonSectionModel *> *)personList with:(YHPersonHeaderModel *)headerModel{
    
    self.personList = personList;

    //    if (!self.isShowBookOrderTotal) {
    //
    //        [self.personList enumerateObjectsUsingBlock:^(YHPersonSectionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            __block YHPersonDetailModel *bookObj = nil;
    //            [obj.list enumerateObjectsUsingBlock:^(YHPersonDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                if ([obj.name_id isEqualToString:@"book"]) {
    //                  bookObj = obj;
    //                }
    //            }];
    //            if (bookObj) {
    //                [obj.list removeObject:bookObj];
    //            }
    //        }];
    //    }
    
    self.headerView.orgNameLab.text = headerModel.orgName;
    self.headerView.realNameLab.text = headerModel.realname;
    self.headerView.alreadyWithdrawLab.text = headerModel.orgPoints;
    self.headerView.availableCashbackLab.text = headerModel.availableCashback;
    self.userOpenId = headerModel.userOpenId;
    
    
    if([[YHTools getName] isEqualToString:@"13420192088"] || [[YHTools getName] isEqualToString:@"15013695607"]){
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"!(secondMenu.code CONTAINS 'mine_purchased_report')"];
        [self.personList filterUsingPredicate:pre];
    }
    
    [self.personTableView reloadData];
}

//获取我的页面头部数据
//-(void)getPersonCenterMineInfo{
//
//     [[YHNetworkPHPManager sharedYHNetworkPHPManager] userInfo:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
//
//         self.headerView.orgNameLab.text = info[@"data"][@"orgName"];
//         self.headerView.realNameLab.text = info[@"data"][@"realname"];
//         self.headerView.alreadyWithdrawLab.text = info[@"data"][@"alreadyWithdraw"];
//         self.headerView.availableCashbackLab.text = info[@"data"][@"availableCashback"];
//
//    } onError:^(NSError *error) {
//        YHLog(@"getServiceDetail eroror");
//    }];
//}


- (void)setPersonCenterStationList:(NSDictionary *)info error:(NSError *)error{
    
    self.info = info;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YHPersonNewModel *sectionModel = self.personList[section];
    return sectionModel.secondMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHPersonNewModel *sectionModel = self.personList[indexPath.section];
    YHPersonNewDetailModel *detailModel = sectionModel.secondMenu[indexPath.row];
    
    //    YHPersonNormalCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"YHPersonNormalCell"];
    //    if (!normalCell) {
    YHPersonNormalCell *normalCell = [[NSBundle mainBundle] loadNibNamed:@"YHPersonNormalCell" owner:nil options:nil].firstObject;
    //    }
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    normalCell.topicL.text = detailModel.title;
    normalCell.iconView.image = [UIImage imageNamed:detailModel.code];
    
    if([detailModel.code isEqualToString:@"mine_workload"]){//员工绩效
        normalCell.NewBtn.hidden = YES;//[YHTools getPersonCenterNewServiceCellTwo];
    }else if([detailModel.code isEqualToString:@"mine_workload1"]){//门店统计
        normalCell.NewBtn.hidden = YES;//[YHTools getPersonCenterNewServiceCellOne];
    }else if([detailModel.code isEqualToString:@"mine_trainee"]){//学员信息
        normalCell.NewBtn.hidden = YES;
    }else if([detailModel.code isEqualToString:@"dismantled_statistics"]){//拆装查询统计
        normalCell.NewBtn.hidden = [YHTools getPersonCenterNewServiceCellFour];
    }else{
        normalCell.NewBtn.hidden = YES;
    }
    
    return normalCell;
    
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YHPersonNewModel *sectionModel = self.personList[section];
    UIView *secHeadView = [UIView new];
    secHeadView.backgroundColor = [UIColor whiteColor];
    UILabel *secL = [UILabel new];
    [secHeadView addSubview:secL];
    [secL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(12));
        make.height.equalTo(@(20));
        make.left.equalTo(@(12));
    }];
    secL.text = sectionModel.title;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [secHeadView setRounded:secHeadView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8.0];
    });
    
    return secHeadView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 42.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 24.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 12)];
    v.backgroundColor = [UIColor whiteColor];
        
    [v setRounded:CGRectMake(0, 0, tableView.width, 12) corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8.0];
    
    return v;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHPersonNewModel *sectionModel = self.personList[indexPath.section];
    YHPersonNewDetailModel *detailModel = sectionModel.secondMenu[indexPath.row];
    
    NSString *url = nil;
    NSString *userID = nil;
    NSInteger type = 2;
    //mine_order_service  mine_order_service
    if([detailModel.code isEqualToString:@"mine_advance_order_statistics"]){//经营情况-预订单统计
        url = @"bookingOrder";
    }
    
    if([detailModel.code isEqualToString:@"mine_org_statistics"]){//经营情况-站点统计
        type = 1;
        url = @"bookingOrder";
    }
    
    if([detailModel.code isEqualToString:@"mine_workload1"]){//经营情况-门店统计
        url = @"employeeWorkload";
        [YHTools setPersonCenterNewServiceCellOne:@"100"];
    }
    
    if([detailModel.code isEqualToString:@"mine_workload"]){//经营情况-员工工作量
        url = @"employeeWorkload";
        [YHTools setPersonCenterNewServiceCellTwo:@"100"];
    }
    
    if([detailModel.code isEqualToString:@"mine_trainee"]){//经营情况-学员信息
           url = @"personalTrainee";
           [YHTools setPersonCenterNewServiceCellThree:@"100"];
       }
    
    if([detailModel.code isEqualToString:@"dismantled_statistics"]){//拆装查询统计
            [YHTools setPersonCenterNewServiceCellFour:@"100"];
            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios#/maintenance/maintenanceStatistics",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken]];
            controller.title = detailModel.title;
            controller.barHidden = YES;
            controller.isFeedBackPush = YES;
            [self.navigationController pushViewController:controller animated:YES];
        return;
      }
    
    if([detailModel.code isEqualToString:@"mine_bounty_statistics"]){//业绩奖励-奖励金统计
        type = 0;
        url = @"workingStatistics";
    }
    
    if([detailModel.code isEqualToString:@"mine_personal_statistics"]){//业绩奖励-个人统计
        url = @"workingStatistics";
        userID = self.userOpenId;
    }
    
    if([detailModel.code isEqualToString:@"mine_purchased_report"]){//订单服务-已购买报告
        url = @"boughtReport";
    }
    
    if([detailModel.code isEqualToString:@"mine_about"]){//系统设置-关于JNS
        YHAppIntroduceController *VC = [[UIStoryboard storyboardWithName:@"YHAppIntroduce" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAppIntroduceController"];
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    if([detailModel.code isEqualToString:@"mine_feedbacks"]){//系统设置-反馈建议
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@%@%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk,[NSString stringWithFormat:@"/suggestion.html?token=%@&appId=yh1XqnVMsZxJNrqAPs&status=ios",[YHTools getAccessToken]]];
        controller.title = detailModel.title;
        controller.barHidden = NO;
        controller.isFeedBackPush = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    if([detailModel.code isEqualToString:@"mine_contact_us"]){//系统设置-联系我们
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios#/personal/contactMe",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken]];
        controller.title = detailModel.title;
        controller.barHidden = YES;
        controller.isFeedBackPush = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.title =  detailModel.title;
    BOOL isFirst = [(AppDelegate*)[[UIApplication sharedApplication] delegate] isFirstLogin];
    if (isFirst) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:NO];
    }
    
    //workingStatistics
    controller.urlStr = type < 2 ? [NSString stringWithFormat:@"%@%@/wealth_copy.html?token=%@&status=ios&type=%ld",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken],(long)type] : [NSString stringWithFormat:@"%@/index.html?token=%@%@&jnsAppStep=%@&status=ios#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],userID.length ? [NSString stringWithFormat:@"&userId=%@",userID] : @"" ,url];
    //http://www.mhace.cn/jnsDev/index.html?token=adb383c94a7ce83aff0a1a378e8bcfb1&billId=25143&status=ios#/maintenance/maintenanceStatistics
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(NSString *)URLEncodedString:(NSString *)str{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
@end



