//
//  YHToBeDetectionTC.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHToBeDetectionTC.h"
#import "YHDetectionCell.h"
#import "YHToBeDetectionModel.h"

#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "LYEmptyViewHeader.h"

#import <Masonry.h>
#import "YHMapViewController.h"
#import "FL_Button.h"
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
static NSString *cellID = @"detection";
@interface YHToBeDetectionTC ()

@property (nonatomic,assign)NSInteger page;

/**
 待检测数组
 */
@property (nonatomic,strong)NSMutableArray *beDetectionArr;

/**
 新增检测车辆按钮
 */
@property (nonatomic, weak) FL_Button *btn;

@end

@implementation YHToBeDetectionTC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //请求网络数据
    [self initData];
    
    //设置空视图
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"icon_nodata"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    //emptyView内容上的点击事件监听
    __weak typeof(self)weakSelf = self;
    [self.tableView.ly_emptyView setTapContentViewBlock:^{
        [weakSelf initData];
    }];

    //修改tableView大小
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    
    //设置tableView
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 117-28;
    [self.tableView registerNib:[UINib nibWithNibName:@"YHDetectionCell" bundle:nil] forCellReuseIdentifier:cellID];
    //监听 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullRefresh) name:PopToBeDetectionVCNotification object:nil];
    
    //添加底部按钮
    //[self addDetectionVehiclesBtn];
}

//新增检测车
-(void)addDetectionVehiclesBtn{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 178-SafeAreaBottomHeight, kScreenWidth, 64)];
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
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"AMap" bundle:nil];
    YHMapViewController *mapVC = [board instantiateViewControllerWithIdentifier:@"YHMapViewController"];
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

/**
移除通知  在接收通知的那个去进行通知的移除
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 加载数据
- (void)initData
{
    WeakSelf;
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf toBeDetectedListData];
        [weakSelf pullRefresh];
    }];
    
    //上拉加载更多
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf toBeDetectedListData];
    }];
    
    if (self.beDetectionArr.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

/**
 下拉刷新
 */
-(void)pullRefresh{
    WeakSelf;
    //下拉刷新
        weakSelf.page = 1;
        [weakSelf toBeDetectedListData];
}

//待检测
-(void)toBeDetectedListData
{
    [[YHNetworkManager sharedYHNetworkManager]toBeDetectedlistWithToken:[YHTools getAccessToken] pageNo:self.page pageSize:10 onComplete:^(NSDictionary *info) {
        
        //下拉刷新,清除所有数据源,避免重复添加
        if (self.page == 1) {
            [self.beDetectionArr removeAllObjects];
        }

        //数据解析
        NSArray *bookListArr = info[@"result"][@"bookList"];

        for (NSDictionary *dict in bookListArr) {
            YHToBeDetectionModel *model = [YHToBeDetectionModel mj_objectWithKeyValues:dict];
            [self.beDetectionArr addObject:model];
        }
        YHLog(@"待检测原始数据数组-----%@ ----info=%@",bookListArr,info);
        
        self.page += 1;
        [self.tableView.mj_header endRefreshing];//结束刷新
        [self.tableView.mj_footer endRefreshing];//结束刷新
        [self.tableView reloadData];//刷新列表

    } onError:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beDetectionArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHDetectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.beDetectionArr[indexPath.row];
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)beDetectionArr
{
    if (!_beDetectionArr) {
        _beDetectionArr = [[NSMutableArray alloc]init];
    }
    return _beDetectionArr;
}

@end
