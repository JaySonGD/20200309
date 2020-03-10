//
//  YHAuctionSceneViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/6.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAuctionSceneViewController.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "CheckNetwork.h"
#import "YHNetworkManager.h"
#import "YHCaptureCarModel0.h"
#import "YHCaptureCarCell0.h"
#import "YHCaptureCarCell1.h"
#import "YHCaptureCarCell5.h"
#import "YHAuctionDetailViewController.h"
#import "LYEmptyViewHeader.h"

@interface YHAuctionSceneViewController ()<UITableViewDelegate,UITableViewDataSource>

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
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerHeightConstraint; //轮播图高度约束

@end

@implementation YHAuctionSceneViewController

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

#pragma mark - --------------------------------------加载UI------------------------------------------
- (void)initUI
{
    self.title = @"捕车信息";
    
    self.tag = 1;//关键
    
    //1.init表头
    [self initHeaderViewWithDict:nil];
    
    //2.initCell
    [self initCell];
    
    //3.init手势
    [self initGesture];
}

#pragma mark - 1.init表头
- (void)initHeaderViewWithDict:(NSDictionary*)info
{
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = YHNaviColor;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"icon_auctionSceneBanner"];
    self.bannerView.autoScrollTimeInterval = 4.;
    if (info) {
        NSArray *advArray = info[@"adv"];
        NSMutableArray *imagesStringsArray = [@[]mutableCopy];
        for (NSDictionary *item in advArray) {
            [imagesStringsArray addObject:item[@"imgUrl"]];
        }
        self.bannerView.imageURLStringsGroup = imagesStringsArray;
    } else {
        self.bannerView.localizationImageNamesGroup = @[@"icon_auctionSceneBanner", @"homeAd2"];
    }
    self.bannerView.frame = CGRectMake(0, 0, screenWidth, screenWidth*(320./750.0));
    self.tableView.tableHeaderView = self.bannerView;
}

#pragma mark - 2.initCell
- (void)initCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell0" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell0"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell1" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell5" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell5"];
}

#pragma mark - 3.init手势
- (void)initGesture
{
    //左滑动手势:
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
    [self.tableView reloadData];//刷新列表
}

#pragma mark - 加载数据
- (void)initData
{
    WeakSelf;

    //下拉刷新MJRefreshNormalHeader
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    //上拉加载更多MJRefreshAutoNormalFooter
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
        [[YHNetworkManager sharedYHNetworkManager] requestCarListWithMenuType:@"1" Type:@"2" page:[NSString stringWithFormat:@"%ld",self.page1] rows:CarInterval onComplete:^(NSDictionary *info) {

            NSLog(@"\n竞价中:\n%@",info);

            if ([info[@"retCode"] isEqualToString:@"0"]) {
                
                //下拉刷新,清除所有数据源,避免重复添加
                if (self.page1 == 1) {
                    [self.dataArray1 removeAllObjects];
                }
                
                //解析数据
                for (NSDictionary *dict in info[@"result"][@"carList"]) {
                    YHCaptureCarModel0 *model = [YHCaptureCarModel0 mj_objectWithKeyValues:dict];
                    [self.dataArray1 addObject:model];
                }
                
                self.page1 += 1;
                
                [self.tableView.mj_header endRefreshing];//结束刷新
                [self.tableView.mj_footer endRefreshing];//结束刷新
                [self.tableView reloadData];//刷新列表
                NSLog(@"================>删除前:%ld<====================",self.dataArray1.count);
            }else{
                YHLogERROR(@"");
                [self showErrorInfo:info];
            }
            
        } onError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    } else {
        NSLog(@"--------------当前页:%ld---------------",self.page2);
        
        [[YHNetworkManager sharedYHNetworkManager] requestCarListWithMenuType:@"1" Type:@"3" page:[NSString stringWithFormat:@"%ld",self.page2] rows:CarInterval onComplete:^(NSDictionary *info) {
            
            NSLog(@"\n即将开拍:\n%@",info);

            if ([info[@"retCode"] isEqualToString:@"0"]) {
                
                //1.下拉刷新,清除所有数据源,避免重复添加
                if (self.page2 == 1) {
                    [self.dataArray2 removeAllObjects];
                }
                
                //2.解析数据并模型化
                NSArray *carListArray = info[@"result"][@"carList"];
                for (NSDictionary *dict in carListArray) {
                    YHCaptureCarModel0 *model = [YHCaptureCarModel0 mj_objectWithKeyValues:dict];
                    [self.dataArray2 addObject:model];
                }
                
                //3.Page++
                self.page2 += 1;
                
                //4.停止刷新
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
                //5.刷新列表
                [self.tableView reloadData];
                
                NSLog(@"================>删除前:%ld<====================",self.dataArray2.count);
                
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDown:) name:@"竞价现场倒计时结束刷新" object:nil];
}

- (void)countDown:(NSNotification *)notification
{
    NSLog(@"====监听:%@====%@====",notification.object,notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    if (self.tag == 1) {
        if (self.dataArray1.count > 0) {
            [self.dataArray1 removeObjectAtIndex:[dict[@"countDownRow"] integerValue]];
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
    YHCaptureCarCell0 *cell0 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell0"];
    YHCaptureCarCell5 *cell5 = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell5"];
    if (self.tag == 1) {
        if (self.dataArray1.count != 0) {
            [cell0 refreshUIWithModel:self.dataArray1[indexPath.row] WithTag:self.tag WithRow:indexPath.row WithCode:1];
            return cell0;
        } else {
            return cell5;
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
            return 140;
        } else {
            return (self.tableView.frame.size.height-screenWidth*(320./750.0)-50);
        }
    } else {
        if (self.dataArray2.count != 0) {
            return 140;
        } else {
            return (self.tableView.frame.size.height-screenWidth*(320./750.0)-50);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHAuctionDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionDetailViewController"];
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
    NSArray *selectArray = @[@"竞价中",@"即将开拍"];
    
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
            [self.optionButton addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)clickSelectBtn:(UIButton *)selectedButton
{
    self.tag = selectedButton.tag; //关键
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
