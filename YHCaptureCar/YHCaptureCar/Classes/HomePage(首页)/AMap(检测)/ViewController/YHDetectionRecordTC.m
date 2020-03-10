//
//  YHDetectionRecordTC.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHDetectionRecordTC.h"
#import "YHCaptureCarCell0.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "YHDetectionRecordModel.h"
#import "LYEmptyViewHeader.h"

#import "YHAuctionDetailViewController.h"
#import "YHDetailViewController.h"

extern NSString *const notificationCarListChange;
static NSString *cellID = @"recordID";
@interface YHDetectionRecordTC ()

@property (nonatomic,assign)NSInteger page;

/**
检测列表数组
 */
@property (nonatomic,strong)NSMutableArray *detectionListArr;

@end

@implementation YHDetectionRecordTC

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationCarListChange:) name:notificationCarListChange object:nil];
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
    self.tableView.rowHeight = 117;
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell0" bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - 加载数据
- (void)initData{
    WeakSelf;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf testRecordsListData];
        [self autoPullRefresh];
    }];
    //上拉加载更多
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf testRecordsListData];
    }];
    //自动刷新
    if (self.detectionListArr.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)autoPullRefresh{
    WeakSelf;
    weakSelf.page = 1;
    [weakSelf testRecordsListData];
}

-(void)notificationCarListChange:(NSNotification*)notice{
    [self.tableView.mj_header beginRefreshing];
}
/**
 检测记录网络数据请求
 */
-(void)testRecordsListData{
    [[YHNetworkManager sharedYHNetworkManager]testRecordListWithToken:[YHTools getAccessToken] pageNo:self.page pageSize:10 onComplete:^(NSDictionary *info) {

        YHLog(@"info   ===   %@",info);
        
        //下拉刷新,清除所有数据源,避免重复添加
        if (self.page == 1) {
            [self.detectionListArr removeAllObjects];
        }
        
        //数据解析
        NSArray *detecListArr = info[@"result"][@"detecList"];
        for (NSDictionary *dict in detecListArr) {
            YHDetectionRecordModel *model = [YHDetectionRecordModel mj_objectWithKeyValues:dict];
            [self.detectionListArr addObject:model];
        }
        
        self.page += 1;
        [self.tableView.mj_header endRefreshing];//结束刷新
        [self.tableView.mj_footer endRefreshing];//结束刷新
        [self.tableView reloadData];//刷新列表
    } onError:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.detectionListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHCaptureCarCell0 *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.remainingTimeLabel.hidden = YES;
    cell.timeHeight.constant = 0;
    cell.model = self.detectionListArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHAuctionDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHCaptureCar" bundle:nil] instantiateViewControllerWithIdentifier:@"YHAuctionDetailViewController"];
    VC.isAppointment = YES;
    YHDetectionRecordModel *model = self.detectionListArr[indexPath.row];
    VC.auctionId = [NSString stringWithFormat:@"%ld", model.ID];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)detectionListArr
{
    if (!_detectionListArr) {
        _detectionListArr = [[NSMutableArray alloc]init];
    }
    return _detectionListArr;
}

@end
