//
//  YHMyCarController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHMyCarController.h"

#import "YHInventoryController.h"
#import "YHSellRecordController.h"

#import <Masonry.h>

#import "YHCommon.h"
#import "UIView+Frame.h"


@interface YHMyCarController ()
<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, strong) NSArray <UIButton *> *tags;
@property (nonatomic, weak) UIView *buttomView;

@end

@implementation YHMyCarController

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpDataList" object:nil userInfo:@{@"tag" : @(0)}];

    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpDataList" object:nil userInfo:@{@"tag" : @(0)}];

}


#pragma mark  -  自定义方法
- (void)setUI{

    self.view.backgroundColor = [UIColor whiteColor];
    

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
        make.height.mas_equalTo(55);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"在库车辆" forState:UIControlStateNormal];
    [leftBtn setTitleColor:YHNaviColor forState:UIControlStateSelected];
    [leftBtn setTitleColor:YHColor(48, 49, 50) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    leftBtn.tag = 0;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YHColor(204, 205, 206);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"销售记录" forState:UIControlStateNormal];
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
        make.top.equalTo(titleView.mas_bottom);
    }];
    
    YHInventoryController *vc1 = [YHInventoryController new];
    UIView *view1 = vc1.view;
    [contentView addSubview:view1];
    [self addChildViewController:vc1];
    
    YHSellRecordController *vc2 = [YHSellRecordController new];
    UIView *view2 = vc2.view;
    [contentView addSubview:view2];
    [self addChildViewController:vc2];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(contentView);
        make.right.equalTo(contentView.mas_right).offset(-screenWidth);
        make.width.mas_equalTo(screenWidth);
        make.height.equalTo(contentView.mas_height);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(contentView);
        make.left.equalTo(contentView.mas_left).offset(screenWidth);
        make.width.mas_equalTo(screenWidth);
        make.height.equalTo(contentView.mas_height);
        
    }];
    
}

@end
