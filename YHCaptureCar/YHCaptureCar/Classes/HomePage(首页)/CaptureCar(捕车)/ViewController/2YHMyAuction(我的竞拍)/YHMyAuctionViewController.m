//
//  YHMyAuctionViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/6.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHMyAuctionViewController.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "YHNetworkManager.h"
#import "YHCaptureCarCell0.h"
#import "YHCaptureCarCell1.h"
#import "YHCaptureCarCell2.h"
#import "YHCaptureCarCell3.h"
#import "YHCaptureCarCell5.h"
#import "YHAuctionDetailViewController.h"
#import "LYEmptyViewHeader.h"


@interface YHMyAuctionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;               //组头
@property (nonatomic, strong) UIView *optionView;               //选项View
@property (nonatomic, strong) UIButton *optionButton;           //选项button
@property (nonatomic, strong) UIButton *selectedButton;         //选中
@property (nonatomic, strong) UIButton *unSelectedButton;       //未选中
@property (nonatomic, strong) UIView *optionLineView;           //选项View
@property (nonatomic, strong) UIView *selectedLineView;         //选中
@property (nonatomic, strong) UIView *unSelectedLineView;       //未选中
@property (nonatomic, assign) NSInteger tag;                    //页面标识tag
@property (nonatomic, assign) NSInteger page1;                  //左界面页码
@property (nonatomic, assign) NSInteger page2;                  //右界面页码
@property (nonatomic, strong) NSMutableArray *dataArray1;       //左界面数据源
@property (nonatomic, strong) NSMutableArray *dataArray2;       //右界面数据源
@property (nonatomic, strong) NSString *succeedNumString;       //当日竞价成功的车辆数

@end

@implementation YHMyAuctionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载UI
    [self initUI];
    
    //加载数据
    [self initData];
    
    //添加通知
    [self initNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 加载UI
- (void)initUI
{
    self.title = @"我的竞价";
    
    self.tag = 1;
    
    //1.initCell
    [self initCell];
    
    //2.init手势
    [self initGesture];
}

#pragma mark - 1.initCell
- (void)initCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell0" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell0"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell1" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell2" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell3" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell5" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell5"];
}

#pragma mark - 2.init手势
- (void)initGesture
{
    //左滑动手势
    UISwipeGestureRecognizer *s1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clicks:)];
    s1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:s1];
    
    //右滑动手势
    UISwipeGestureRecognizer *s2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clicks:)];
    s2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:s2];
}

- (void)clicks:(UISwipeGestureRecognizer *)s
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
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    
    if ((self.dataArray1.count == 0) || (self.dataArray2.count == 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
}


- (void)loadNewData{
    self.page1 = 1;
    self.page2 = 1;
    [self queryData];

}

- (void)queryData
{
    if (self.tag == 1) {
        [[YHNetworkManager sharedYHNetworkManager] requestCarListWithMenuType:@"0" Type:@"0" page:[NSString stringWithFormat:@"%ld",self.page1] rows:CarInterval onComplete:^(NSDictionary *info) {

            NSLog(@"\n正在参与:\n%@",info);

            if ([info[@"retCode"] isEqualToString:@"0"]) {
                
                //下拉刷新,清除所有数据源,避免重复添加
                if (self.page1 == 1) {
                    [self.dataArray1 removeAllObjects];
                }
                
                //解析数据
                self.succeedNumString = info[@"result"][@"succeedNum"];//今日竞价成功数量
                NSArray *carListArray = info[@"result"][@"carList"];
                for (NSDictionary *dict in carListArray) {
                    YHCaptureCarModel0 *model = [YHCaptureCarModel0 mj_objectWithKeyValues:dict];
                    [self.dataArray1 addObject:model];
                }
                
                self.page1 += 1;
                
                [self.tableView.mj_header endRefreshing];//结束刷新
                [self.tableView.mj_footer endRefreshing];//结束刷新
                [self.tableView reloadData];//刷新列表
            } else {
                YHLogERROR(@"");
                [self showErrorInfo:info];
            }
            
        } onError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    } else {
        
        [[YHNetworkManager sharedYHNetworkManager] requestCarListWithMenuType:@"0" Type:@"1" page:[NSString stringWithFormat:@"%ld",self.page2] rows:CarInterval onComplete:^(NSDictionary *info) {

            NSLog(@"\n竞价意向:\n%@",info);

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
                
                //page+
                self.page2 += 1;
                
                //结束刷新
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
                //刷新列表
                [self.tableView reloadData];
                
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

#pragma mark - init通知
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDown:) name:@"我的竞价倒计时结束刷新" object:nil];
}

- (void)countDown:(NSNotification *)notification
{
    NSLog(@"====监听:%@====%@====",notification.object,notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    if (self.tag == 1) {
        if (self.dataArray1.count > 0) {
            //[self.dataArray1 removeObjectAtIndex:[dict[@"countDownRow"] integerValue]];
        }
    } else {
        if (self.dataArray2.count > 0) {
            [self.dataArray2 removeObjectAtIndex:[dict[@"countDownRow"] integerValue]];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 列表代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            return self.dataArray1.count+1;
        } else {
            return 2;
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
    YHCaptureCarCell0 *cell0 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell0"];
    YHCaptureCarCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell1"];
    YHCaptureCarCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell3"];
    YHCaptureCarCell5 *cell5 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell5"];
    WeakSelf;
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            if (indexPath.row < self.dataArray1.count) {
                [cell1 refreshUIWithModel:self.dataArray1[indexPath.row] WithTag:self.tag];
                return cell1;
            } else {
                cell3.remindLabel1.text = [NSString stringWithFormat:@"您可同时竞价三辆车，当前还可添加%ld辆。",(3-[self.succeedNumString integerValue])];
                cell3.remindLabel2.text = [NSString stringWithFormat:@"今日竞价成功%@辆，请到“竞价管理”页面查看。",self.succeedNumString];
                cell3.backgroundColor = YHBackgroundColor;
                [cell3 setBtnClickBlock:^(UIButton *button) {
                    [weakSelf.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionRulesViewController"] animated:YES];
                }];
                return cell3;
            }
        } else {
            if (indexPath.row == 0) {
                return cell5;
            } else {
                cell3.remindLabel1.text = [NSString stringWithFormat:@"您可同时竞价三辆车，当前还可添加%ld辆。",(3-[self.succeedNumString integerValue])];
                cell3.remindLabel2.text = [NSString stringWithFormat:@"今日竞价成功%@辆，请到“竞价管理”页面查看。",self.succeedNumString];
                cell3.backgroundColor = YHWhiteColor;
                [cell3 setBtnClickBlock:^(UIButton *button) {
                    [weakSelf.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionRulesViewController"] animated:YES];
                }];
                return cell3;
            }
        }
    } else {
        if (self.dataArray2.count != 0) {
            [cell0 refreshUIWithModel:self.dataArray2[indexPath.row] WithTag:self.tag WithRow:indexPath.row WithCode:1];
            return cell0;
        } else {
            return cell5;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            if (indexPath.row < self.dataArray1.count) {
                return 155;
            } else {
                return 100;
            }
        } else {
            if (indexPath.row == 0) {
                return self.tableView.frame.size.height-150;
            } else {
                return 100;
            }
        }
    } else {
        if (self.dataArray2.count != 0) {
            return 140;
        } else {
            return self.tableView.frame.size.height-50;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tag == 1) {
        if (self.dataArray1.count > 0) {
            YHAuctionDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionDetailViewController"];
            if (indexPath.row < self.dataArray1.count) {
                YHCaptureCarModel0 *model = self.dataArray1[indexPath.row];
                VC.auctionId = model.ID;
                VC.status = model.status;
                if (IsEmptyStr(model.topPrice)) {
                    VC.topPrice = model.bottomPrice;
                } else {
                    VC.topPrice = model.topPrice;
                }
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                NSLog(@"=======尾部cell========");
            }
        }
    } else {
        if (self.dataArray2.count > 0) {
            YHAuctionDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionDetailViewController"];
            YHCaptureCarModel0 *model = self.dataArray2[indexPath.row];
            VC.auctionId = model.ID;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat selectWidth = (screenWidth-1)/2;
    CGFloat selectHeight = 50;
    CGFloat underLineWidth = (screenWidth-1)/2;
    CGFloat underLineHeight = 2;
    NSArray *selectArray = @[@"正在参与",@"竞价意向"];
    
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
