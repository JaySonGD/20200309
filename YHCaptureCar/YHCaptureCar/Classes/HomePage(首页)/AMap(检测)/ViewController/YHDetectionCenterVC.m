//
//  YHDetectionCenterVC.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/29.
//  Copyright © 2018年 YH. All rights reserved.
// 检测中心控制器

#import "YHDetectionCenterVC.h"
#import "YHToBeDetectionTC.h"
#import "YHDetectionRecordTC.h"
#import "SGPagingView.h"
#import "UIColor+ColorChange.h"

#import "YHNetworkManager.h"
#import "YHCommon.h"

//#import "FL_Button.h"

#import <Masonry.h>
#import "YHMapViewController.h"
#import "FL_Button.h"
#import "YHReservationNewVC.h"

#import "YHHelpSellService.h"

#import "YHHelpCheckMapController.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface YHDetectionCenterVC ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

///**
//新增检测车辆按钮
// */
//@property (nonatomic, weak) FL_Button *btn;
/**
 新增检测车辆按钮
 */
@property (nonatomic, weak) FL_Button *btn;

/**
 选中的索引值
 */
@property (nonatomic, assign)NSInteger selectedIndex;

/**
 待检测控制器
 */
@property (nonatomic, weak)YHToBeDetectionTC * detectionTC;

/**
 检测记录控制器
 */
@property (nonatomic, weak)YHDetectionRecordTC *detectionCenterTC;

@end

@implementation YHDetectionCenterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = 0;
    
    //设置导航栏
    [self setNavgationBar];
    
    //设置底部新增检测车辆按钮
    [self setupPageView];
    
//    //添加底部按钮
//    [self addDetectionVehiclesBtn];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setNavgationBar{
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.title = @"检测中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    //右边
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"menu1"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(alertAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:button];
}

//提醒事件

-(void)alertAction{
}

////新增检测车
//-(void)addDetectionVehiclesBtn{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 64-SafeAreaBottomHeight, kScreenWidth, 64)];
//    [self.view addSubview:view];
//
//    FL_Button *btn = [FL_Button buttonWithType:UIButtonTypeCustom];
//    self.btn = btn;
//    btn.status = FLAlignmentStatusCenter;
//    btn.fl_padding = 10;
//    btn.backgroundColor = [UIColor whiteColor];
//    [view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(@7);
//        make.bottom.mas_equalTo(@-7);
//        make.left.mas_equalTo(@20);
//        make.right.mas_equalTo(@-20);
//    }];
//    [btn setTitle:@"新增检测车辆" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    //设置图像渲染方式  设置图片不被渲染
//    [btn setImage:[UIImage imageNamed:@"新增"] forState:UIControlStateNormal];
//    [btn setBackgroundColor:YHNaviColor];
//    [btn addTarget:self action:@selector(addTestingVehicles) forControlEvents:UIControlEventTouchUpInside];
//    btn.layer.cornerRadius = 8;
//    btn.layer.masksToBounds = YES;
//}
//
////新增检测车辆
//-(void)addTestingVehicles{
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"AMap" bundle:nil];
//    YHMapViewController *mapVC = [board instantiateViewControllerWithIdentifier:@"YHMapViewController"];
//
//    [self.navigationController pushViewController:mapVC animated:YES];
//}

- (void)setupPageView {
//    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
//    CGFloat pageTitleViewY = 0;
//    if (statusHeight == 20.0) {
//        pageTitleViewY = 64;
//    } else {
//        pageTitleViewY = 88;
//    }
    NSArray *titleArr = @[@"待检测", @"检测记录"];
    titleArr = @[@"待检测"];

    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = [UIColor blackColor];
    configure.titleSelectedColor = YHNaviColor;
    configure.indicatorColor = YHNaviColor;
    configure.titleFont = [UIFont systemFontOfSize:17];
    configure.indicatorAdditionalWidth = 100; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView  顶部切换视图
    CGFloat pageTitleViewY = NavbarHeight;
    //self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 50) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 0) delegate:self titleNames:titleArr configure:configure];

    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
    
    //子控制器
    YHToBeDetectionTC * detectionTC = [[YHToBeDetectionTC alloc]init];
    self.detectionTC = detectionTC;
    YHDetectionRecordTC *detectionCenterTC = [[YHDetectionRecordTC alloc]init];
    self.detectionCenterTC = detectionCenterTC;
    NSArray *childArr = @[detectionTC, detectionCenterTC];

    childArr = @[detectionTC];

    /// pageContentView   内容视图
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    self.pageContentView.backgroundColor = [UIColor redColor];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    [self addDetectionVehiclesBtn];
}


//新增检测车
-(void)addDetectionVehiclesBtn{
    //UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 178-SafeAreaBottomHeight, kScreenWidth, 64)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 64-SafeAreaBottomHeight, kScreenWidth, 64)];

    [self.view addSubview:view];
    
    FL_Button *btn = [FL_Button buttonWithType:UIButtonTypeCustom];
    self.btn = btn;
    btn.status = FLAlignmentStatusCenter;
    btn.fl_padding = 10;
    btn.backgroundColor = [UIColor whiteColor];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@7);
        make.bottom.mas_equalTo(@-7);
        make.left.mas_equalTo(@20);
        make.right.mas_equalTo(@-20);
    }];
    [btn setTitle:@"新增检测车辆" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置图像渲染方式  设置图片不被渲染
    [btn setImage:[UIImage imageNamed:@"新增"] forState:UIControlStateNormal];
    [btn setBackgroundColor:YHNaviColor];
    [btn addTarget:self action:@selector(addTestingVehicles) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
}

//新增检测车辆
-(void)addTestingVehicles{
    
    //7、捕车与JNS有关联的修理厂用户，进行认证检测预约时，前端页面直接提示预约成功，后端生成相应预约单下到JNS。（检测数量填1，地址、手机直接读取机构信息）
     __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService checkDealerOnComplete:^(YHReservationModel *model) {
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"AMap" bundle:nil];
        YHReservationNewVC *newResVC = [YHReservationNewVC new];
        newResVC.reservationM = model;  //跳转过去的时候将对应的模型数据传入
        newResVC.isFirst = YES;
        [weakSelf.navigationController pushViewController:newResVC animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } onError:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"AMap" bundle:nil];
        YHMapViewController *mapVC = [board instantiateViewControllerWithIdentifier:@"YHMapViewController"];
        [weakSelf.navigationController pushViewController:mapVC animated:YES];
        
//        YHHelpCheckMapController *VC = [[YHHelpCheckMapController alloc]init];
//        [weakSelf.navigationController pushViewController:VC animated:YES];
    }];
}


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    self.selectedIndex = selectedIndex;
    
    self.btn.alpha = !selectedIndex ;
    
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
    //点击的时候进行强制刷新数据
    if (selectedIndex ==0) { //待检测
        [self.detectionTC pullRefresh];
    }else{ //检测记录
        [self.detectionCenterTC autoPullRefresh];
    }
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    progress = targetIndex? -progress : progress;
    self.btn.alpha = targetIndex + progress;//((BOOL)progress) && (BOOL)targetIndex;
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

@end
