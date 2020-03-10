//
//  YHAuctionManagementViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/6.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAuctionManagementViewController.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "YHNetworkManager.h"
#import "YHCaptureCarCell2.h"
#import "YHCaptureCarCell5.h"
#import "YHAuctionDetailViewController.h"
#import "LYEmptyViewHeader.h"


@interface YHAuctionManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;               //组头
@property (nonatomic, strong) UIView *optionView;               //选项View
@property (nonatomic, strong) UIButton *optionButton;           //选项button
@property    UIButton *selectedButton;         //选中
@property (nonatomic, strong) UIButton *unSelectedButton;       //未选中
@property (nonatomic, strong) UIView *optionLineView;           //选项View
@property (nonatomic, strong) UIView *selectedLineView;         //选中
@property (nonatomic, strong) UIView *unSelectedLineView;       //未选中
@property (nonatomic, assign) NSInteger tag;                  //页面标识tag
@property (nonatomic, assign) NSInteger page1;                //左界面页码
@property (nonatomic, assign) NSInteger page2;                //右界面页码
@property (nonatomic, strong) NSMutableArray *dataArray1;     //左界面数据源
@property (nonatomic, strong) NSMutableArray *dataArray2;     //右界面数据源

@end

@implementation YHAuctionManagementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载UI
    [self initUI];
    
    //加载数据
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 加载UI
- (void)initUI
{
    self.title = @"竞价管理";
    
    self.tag = 1;
    
    //1.initCell
    [self initCell];

    //2.init手势
    [self initGesture];
}

#pragma mark - 1.initCell
- (void)initCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell2" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell5" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell5"];
}

#pragma mark - 2.init手势
- (void)initGesture
{
    //左滑动手势
    UISwipeGestureRecognizer *s1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickS:)];
    s1.direction = UISwipeGestureRecognizerDirectionLeft;//滑动方向
    [self.tableView addGestureRecognizer:s1];
    
    //右滑动手势
    UISwipeGestureRecognizer *s2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickS:)];
    s2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:s2];
}

- (void)clickS:(UISwipeGestureRecognizer *)s
{
    if (s.direction == UISwipeGestureRecognizerDirectionRight){
        self.tag = 1;//关键
        [UIView animateWithDuration:1.0 animations:^{
            [self.selectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = NO;
            self.unSelectedLineView.hidden = YES;
        }];
    } else if (s.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.tag = 2;//关键
        [UIView animateWithDuration:1.0 animations:^{
            [self.selectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = YES;
            self.unSelectedLineView.hidden = NO;
        }];
    }

    [self loadNewData];
    [self.tableView reloadData]; //刷新列表
}

#pragma mark - 加载数据
- (void)initData
{
    WeakSelf;

    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    //上拉加载更多
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    
    if ((self.dataArray1.count == 0) || (self.dataArray2.count == 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)loadNewData
{
    self.page1 = 1;
    self.page2 = 1;
    [self queryData];
}

- (void)queryData
{
    if (self.tag == 1) {
        [[YHNetworkManager sharedYHNetworkManager] requestCarListWithMenuType:@"0" Type:@"4" page:[NSString stringWithFormat:@"%ld",self.page1] rows:CarInterval onComplete:^(NSDictionary *info) {
            NSLog(@"\n竞价成功:\n%@",info);
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                
                //下拉刷新,清除所有数据源,避免重复添加
                if (self.page1 == 1) {
                    [self.dataArray1 removeAllObjects];
                }
                
                //解析数据
                NSArray *carListArray = info[@"result"][@"carList"];
                for (NSDictionary *dict in carListArray) {
                    YHCaptureCarModel0 *model = [YHCaptureCarModel0 mj_objectWithKeyValues:dict];
                    [self.dataArray1 addObject:model];
                }
                
                self.page1 += 1;
                
                [self.tableView.mj_header endRefreshing];//结束刷新
                [self.tableView.mj_footer endRefreshing];//结束刷新
                [self.tableView reloadData];//刷新列表
            }else{
                YHLogERROR(@"");
                [self showErrorInfo:info];
            }

        } onError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    } else {
        [[YHNetworkManager sharedYHNetworkManager] requestCarListWithMenuType:@"0" Type:@"5" page:[NSString stringWithFormat:@"%ld",self.page2] rows:CarInterval onComplete:^(NSDictionary *info) {
            NSLog(@"\n竞价记录:\n%@",info);
            if ([info[@"retCode"] isEqualToString:@"0"]) {
                
                //下拉刷新,清除所有数据源,避免重复添加
                if (self.page2 == 1) {
                    [self.dataArray2 removeAllObjects];
                }
                
                //解析数据
                NSArray *carListArray = info[@"result"][@"carList"];
                for (NSDictionary *dict in carListArray) {
                    YHCaptureCarModel0 *model = [YHCaptureCarModel0 mj_objectWithKeyValues:dict];
                    [self.dataArray2 addObject:model];
                }
                
                self.page2 += 1;
                
                [self.tableView.mj_header endRefreshing];//结束刷新
                [self.tableView.mj_footer endRefreshing];//结束刷新
                [self.tableView reloadData];//刷新列表

            }else{
                YHLogERROR(@"");
                [self showErrorInfo:info];
            }

        } onError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - 列表代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            return self.dataArray1.count;
        } else {
            return 1;
        }
    } else {
        if (self.dataArray2.count != 0) {
            return self.dataArray2.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCaptureCarCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell2"];
    YHCaptureCarCell5 *cell5 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell5"];
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            [cell2 refreshUIWithModel:self.dataArray1[indexPath.row] WithTag:self.tag];
            return cell2;
        } else {
            return cell5;
        }
    } else {
        if (self.dataArray2.count != 0) {
            [cell2 refreshUIWithModel:self.dataArray2[indexPath.row] WithTag:self.tag];
            return cell2;
        } else {
            return cell5;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            return 140;
        } else {
            return (self.tableView.frame.size.height-50);
        }
    } else {
        if (self.dataArray2.count != 0) {
            return 140;
        } else {
            return (self.tableView.frame.size.height-50);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHAuctionDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionDetailViewController"];
    VC.jumpString = @"竞价管理跳转";
    if (self.tag == 1) {
        if (self.dataArray1.count > 0) {
            YHCaptureCarModel0 *model = self.dataArray1[indexPath.row];
            VC.auctionId = model.ID;
            VC.status = model.status;
        }
    } else {
        if (self.dataArray2.count > 0) {
            YHCaptureCarModel0 *model = self.dataArray2[indexPath.row];
            VC.auctionId = model.ID;
            VC.status = model.status;
        }
    }
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat selectWidth = (screenWidth-1)/2;
    CGFloat selectHeight = 50;
    CGFloat underLineWidth = (screenWidth-1)/2;
    CGFloat underLineHeight = 2;
    NSArray *selectArray = @[@"竞价成功",@"竞价记录"];
    
    //整个组头视图
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, selectHeight)];
        self.headerView.backgroundColor = YHWhiteColor;
        
        //选项view
        for (int i = 0; i < 2; i++) {
            self.optionView = [[UIView alloc]initWithFrame:CGRectMake((screenWidth/2)*i, 0, selectWidth, selectHeight)];
            [self.headerView addSubview:self.optionView];
            
            //1.选项button
            self.optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.optionButton.tag = i+1;
            self.optionButton.frame = CGRectMake(0, 0, selectWidth, selectHeight-underLineHeight);
            [self.optionButton setTitle:selectArray[i] forState:UIControlStateNormal];
            if (i == 0) {
                [self.optionButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
                self.selectedButton = self.optionButton;
            } else {
                [self.optionButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
                self.unSelectedButton = self.optionButton;
            }
            [self.optionButton addTarget:self action:@selector(clickaSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.optionView addSubview:self.optionButton];
            
            //2.下划线
            self.optionLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.optionButton.frame), underLineWidth, underLineHeight)];
            self.optionLineView.backgroundColor = YHNaviColor;
            if (i == 0) {
                self.optionLineView.hidden = NO;
                self.selectedLineView = self.optionLineView;
            } else {
                self.optionLineView.hidden = YES;
                self.unSelectedLineView = self.optionLineView;
            }
            [self.optionView addSubview:self.optionLineView];
        }
    }
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - 选择按钮点击事件
- (void)clickaSelectBtn:(UIButton *)selectedButton
{
    self.tag = selectedButton.tag;

    switch (selectedButton.tag) {
        case 1:
            [self.selectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = NO;
            self.unSelectedLineView.hidden = YES;
            break;
        case 2:
            [self.selectedButton setTitleColor:YHBlackColor forState:UIControlStateNormal];
            [self.unSelectedButton setTitleColor:YHNaviColor forState:UIControlStateNormal];
            self.selectedLineView.hidden = YES;
            self.unSelectedLineView.hidden = NO;
            break;
        default:
            break;
    }
//    [self initData];
    [self loadNewData];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray1
{
    if (!_dataArray1) {
        _dataArray1 = [[NSMutableArray alloc]init];
    }
    return _dataArray1;
}

- (NSMutableArray *)dataArray2
{
    if (!_dataArray2) {
        _dataArray2 = [[NSMutableArray alloc]init];
    }
    return _dataArray2;
}

@end
