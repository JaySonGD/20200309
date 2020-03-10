//
//  YHHelpSellController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHHelpSellController.h"
#import "YHEntrustTradeController.h"
#import "YHMyCollectController.h"
#import "YHSearchViewController.h"
#import "YHHelpBuyController.h"
//#import "YHHelpCkeckInputController.h"
//#import "YHNewOrderController.h"

#import <Masonry.h>

#import "YHCommon.h"
#import "UIView+Frame.h"

@interface YHHelpSellController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, strong) NSArray <UIButton *> *tags;
@property (nonatomic, weak) UIView *buttomView;
@end

@implementation YHHelpSellController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIScrollViewDelegate
/**
 scrollView完全停止滚动
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScroll];
}

/**
 scrollView带降速停止滚动
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {  // scrollView完全停止滚动
        [self scrollViewDidEndScroll];
    }
}

/**
 scrollView停止滚动
 */
- (void)scrollViewDidEndScroll {
    // 1. 计算偏移量
    NSInteger page = (NSInteger)(self.contentView.contentOffset.x / self.contentView.bounds.size.width + 0.5);
    
    for (NSInteger i = 0; i < self.tags.count; i ++) {
        self.tags[i].selected = (i == page);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.buttomView.centerX = self.tags[page].centerX;
    }];

}

#pragma mark  -  事件监听
- (void)tagClick:(UIButton *)sender{
    for (NSInteger i = 0; i < self.tags.count; i ++) {
        self.tags[i].selected = (i == sender.tag);
    }
    [self.contentView setContentOffset:CGPointMake(screenWidth * sender.tag, 0) animated:YES];

    
    [UIView animateWithDuration:0.25 animations:^{
        self.buttomView.centerX = self.tags[sender.tag].centerX;
    }];
}

- (void)tapClick{
    UIView *alertView = [[UIView alloc] initWithFrame:self.view.bounds];
    alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    UIImageView *adView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    [alertView addSubview:adView];
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(301);
        make.height.mas_equalTo(260);
        make.center.equalTo(alertView);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"shut_down"] forState:UIControlStateNormal];
    [alertView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];

    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        make.right.equalTo(adView).offset(-5);
        make.top.equalTo(adView).offset(5);

    }];

    [self.view.window addSubview:alertView];

    alertView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)closeClick:(UIButton*)sender{
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [sender.superview removeFromSuperview];
    }];

}

- (void)searchClick{
    
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    YHNewOrderController *controller = [board instantiateViewControllerWithIdentifier:@"YHNewOrderController"];
//    controller.isCar = YES;
//    controller.isHelpCheck = YES;
//    [self.navigationController pushViewController:controller animated:YES];
//
//    return;
//    [self.navigationController pushViewController:[YHHelpCkeckInputController new] animated:YES];
//
//    return;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    YHSearchViewController *vc = [YHSearchViewController new];
    vc.isHelpSell = ![self isKindOfClass:[YHHelpBuyController class]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  -  自定义方法
- (void)setUI{
    self.navigationItem.title = @"质保车源";//@"帮卖";
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn setImage:[UIImage imageNamed:@"searc_white"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
//            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//
//        } else {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(NavbarHeight);

//        }
        make.height.mas_equalTo(0);
//        make.height.mas_equalTo(55);

    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"捕车" forState:UIControlStateNormal];
    [leftBtn setTitleColor:YHNaviColor forState:UIControlStateSelected];
    [leftBtn setTitleColor:YHColor(48, 49, 50) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    leftBtn.tag = 0;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YHColor(204, 205, 206);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [rightBtn setTitleColor:YHNaviColor forState:UIControlStateSelected];
    [rightBtn setTitleColor:YHColor(48, 49, 50) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 1;

    self.tags = @[leftBtn,rightBtn];
    
    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 55-3, 120, 3)];
    buttomLine.backgroundColor = YHNaviColor;
    buttomLine.centerX = (screenWidth - 0.5) * 0.25;
    [titleView addSubview:buttomLine];
    _buttomView = buttomLine;

    [titleView addSubview:leftBtn];
    [titleView addSubview:line];
    [titleView addSubview:rightBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(titleView);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(titleView);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(titleView);
        make.left.mas_equalTo(line.mas_right);
        make.width.mas_equalTo(leftBtn.mas_width);
    }];
    
    
    UIImageView *banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ggTop"]];
    [self.view addSubview:banner];
    banner.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [banner addGestureRecognizer:tap];
    
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(![self isKindOfClass:[YHHelpBuyController class]]?70:0);
    }];
    
    UIImageView *carClick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carClick"]];
    [banner addSubview:carClick];
    
    [carClick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(banner).offset(-4);
        make.centerY.equalTo(banner.mas_centerY).offset(10);
        make.height.mas_equalTo(47);
        make.width.mas_equalTo(47);

    }];


    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor orangeColor];
    contentView.pagingEnabled = YES;
    contentView.bounces = NO;
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(banner.mas_bottom);
    }];
    
    YHEntrustTradeController *vc1 = [YHEntrustTradeController new];
    UIView *view1 = vc1.view;
    vc1.isHelpSell = ![self isKindOfClass:[YHHelpBuyController class]];
    [contentView addSubview:view1];
    [self addChildViewController:vc1];

//    YHMyCollectController *vc2 = [YHMyCollectController new];
//    UIView *view2 = vc2.view;
//    [contentView addSubview:view2];
//    [self addChildViewController:vc2];

    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(contentView);
        make.right.equalTo(contentView.mas_right).offset(-screenWidth);
        make.width.mas_equalTo(screenWidth);
        make.height.equalTo(contentView.mas_height);
    }];
    
    contentView.scrollEnabled = NO;

//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.bottom.equalTo(contentView);
//        make.left.equalTo(contentView.mas_left).offset(screenWidth);
//        make.width.mas_equalTo(screenWidth);
//        make.height.equalTo(contentView.mas_height);
//
//    }];


//    [self tagClick:leftBtn];
//    contentView.contentSize = CGSizeMake(2 * screenWidth, 0);


}

@end
