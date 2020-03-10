//
//  YHCarSourceController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCarSourceController.h"
#import "YHMyCarController.h"
#import "YHAuctionContentController.h"
#import "YHDiagnosisBaseVC.h"

#import "YHDetectionCenterVC.h"
#import "YHNewOrderController.h"
#import "YHHelpSellService.h"
#import <Masonry/Masonry.h>

#import "YHCommon.h"

#import "CCZTableButton.h"

@interface YHCarSourceController ()<UITabBarDelegate>

@property (nonatomic, strong) CCZTableButton *table;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) NSArray *menuStrs;
@end

@implementation YHCarSourceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkDealer];
    [self setUI];
}

/**
 判断捕车当前用户是否绑定了JNS站点:
 绑定了文字为: 代售检测
 没有绑定改为: 认证检测
 **/
- (void)checkDealer{
    WeakSelf;
    [YHHelpSellService checkDealerOnComplete:^(YHReservationModel *model) {
        weakSelf.menuStrs = @[@"认证检测",@"车商上传"];
    } onError:^(NSError *error) {
        weakSelf.menuStrs = @[@"认证检测",@"车商上传"];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

//FIXME:   -   UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    for (NSInteger i = 0; i < tabBar.items.count; i ++) {
        self.childViewControllers[i].view.hidden = (i !=  [tabBar.items indexOfObject:item]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpDataList" object:nil userInfo:@{@"tag" : @([tabBar.items indexOfObject:item])}];
}


//FIXME:  -  自定义方法
- (void)setUI
{
    self.navigationItem.title = @"ERP";//@"车源管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn setImage:[UIImage imageNamed:@"新增"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(addPush) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.searchBtn = searchBtn;
    
    YHMyCarController *carVC = [YHMyCarController new];
    carVC.view.hidden = NO;
    YHAuctionContentController *auctionVC = [YHAuctionContentController new];
    auctionVC.view.hidden = !carVC.view.isHidden;
    
    [self addChildViewController:carVC];
    [self addChildViewController:auctionVC];
    
    [self.view addSubview:carVC.view];
    [self.view addSubview:auctionVC.view];
    
    [carVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
        //make.bottom.equalTo(self.view).offset(-TabbarHeight);

    }];
    [auctionVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
        //make.bottom.equalTo(self.view).offset(-TabbarHeight);

    }];


    return;
    
    UITabBar *tabbarView = [[UITabBar alloc] init];
    
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"我的车辆" image:[UIImage imageNamed:@"我的车辆"] selectedImage:[UIImage imageNamed:@"我的车辆（点击）"]];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"竞价" image:[UIImage imageNamed:@"竞拍"] selectedImage:[UIImage imageNamed:@"竞拍（点击）"]];

    tabbarView.items = @[item0,item1];
    tabbarView.selectedItem = item0;
    tabbarView.delegate = self;
    
    [self.view addSubview:tabbarView];
    [tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TabbarHeight);
    }];
}

//FIXME:  -  事件监听
- (void)addPush
{
    
//    YHDetectionCenterVC *VC = [[UIStoryboard storyboardWithName:@"AMap" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetectionCenterVC"];
//    [self.navigationController pushViewController:VC animated:YES];
//
//    return;
    WeakSelf;
    self.table = [[CCZTableButton alloc] initWithFrame:CGRectMake(screenWidth-100, CGRectGetMaxY(self.navigationController.navigationBar.frame), 100, 0)];
    self.table.layer.borderWidth = 1;
    self.table.layer.borderColor = YHBackgroundColor.CGColor;
    [self.table addItems:self.menuStrs];
    [self.table selectedAtIndexHandle:^(NSUInteger index, NSString *itemName) {
        switch (index) {
            case 0:
            {
                YHDetectionCenterVC *VC = [[UIStoryboard storyboardWithName:@"AMap" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetectionCenterVC"];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 1:
            {
                YHNewOrderController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHNewOrderController"];
                VC.isCar = YES;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    [self.table show];
}

- (void)dealloc{
    NSLog(@"%s-----我靠靠靠", __func__);
}

@end
