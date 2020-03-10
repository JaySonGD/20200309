//
//  YHReportListViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/9/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHReportListViewController.h"
#import "YHReportListModel.h"
#import "YHReportListCell.h"
#import "YHCaptureCarCell5.h"
#import "YHWebFuncViewController.h"

#import "YHTools.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "YHNetworkManager.h"

#import "YHReportDetailModel.h"

@interface YHReportListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign)int page;

@end

@implementation YHReportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
    
    //初始化数据
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - ------------------------------------初始化变量----------------------------------------
- (void)initVar {
    [self.tableView registerNib:[UINib nibWithNibName:@"YHReportListCell" bundle:nil] forCellReuseIdentifier:@"YHReportListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell5" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell5"];
}

#pragma mark - -------------------------------------初始化UI------------------------------------------
- (void)initUI {
    
}

#pragma mark - ------------------------------------初始化数据------------------------------------------
- (void)initData {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self queryData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self queryData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)queryData{
    [[YHNetworkManager sharedYHNetworkManager]rptListWithToken:[YHTools getAccessToken]
                                                           vin:self.vin
                                                        pageNo:[NSString stringWithFormat:@"%d",self.page]
                                                      pageSize:[NSString stringWithFormat:@"%d",10]
                                                    onComplete:^(NSDictionary *info)
     {
         NSLog(@"----------->>>>%@<<<<-----------",info);
         if ([info[@"retCode"] isEqualToString:@"0"]) {
             //1.下拉刷新,清除所有数据源,避免重复添加
             if (self.page == 1) {
                 [self.dataArray removeAllObjects];
             }
             
             //2.解析数据并且模型化
             for (NSDictionary *dict in info[@"result"][@"rptList"]) {
                 YHReportListModel *model = [YHReportListModel mj_objectWithKeyValues:dict];
                 [self.dataArray addObject:model];
             }
             
             //3.Page++
             self.page += 1;
             
             //4.头尾停止刷新
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
             
             //5.刷新列表
             [self.tableView reloadData];
         }else{
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
         }
     } onError:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];
}

#pragma mark - ---------------------------------tableView代理方法--------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count != 0) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        YHReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHReportListCell"];
        [cell refreshUIWithModel:self.dataArray[indexPath.row]];
        return cell;
    } else {
        YHCaptureCarCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell5"];
        cell.remindLabel.text = @"该车架号暂无报告列表";
        return cell;
    }
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        return 105;
    } else {
        return self.tableView.frame.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (self.dataArray.count == 0) {return;}
    YHReportListModel *rlModel = self.dataArray[indexPath.row];
    YHWebFuncViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    VC.urlStr = rlModel.rptUrl;
    //VC.urlStr = @"http://www.baidu.com";
    VC.title = rlModel.billTypeName;

    [self.navigationController pushViewController:VC animated:YES];

    return;
    [[YHNetworkManager sharedYHNetworkManager]rptDetailWithToken:[YHTools getAccessToken]
                                                      reportCode:rlModel.reportCode
                                                        billType:rlModel.billType
                                                      billNumber:rlModel.billNumber
                                                    creationTime:rlModel.creationTime
                                                      onComplete:^(NSDictionary *info)
     {
         if ([info[@"retCode"] isEqualToString:@"0"]) {
             YHReportDetailModel *rdModel = [YHReportDetailModel mj_objectWithKeyValues:info[@"result"]];
             
             YHWebFuncViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
             
             VC.rlModel = rlModel;
             VC.rdModel = rdModel;
             VC.barHidden = NO;
             VC.title = rlModel.billTypeName;
             VC.isPushByReportList = YES;

             //二手车
             if ([rlModel.billType isEqualToString:@"S"] || [rlModel.billType isEqualToString:@"E001"]) {
                 //0-待支付
                 if ([rdModel.payStatus isEqualToString:@"0"]) {
                     VC.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/secondCar.html?code=%@", rlModel.reportCode];
                 //1-支付完成
                 } else if ([rdModel.payStatus isEqualToString:@"1"]) {
                     VC.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/secondCar.html?code=%@&%@", rlModel.reportCode,rdModel.rptUrl];
                 }
            //安检
             } else if ([rlModel.billType isEqualToString:@"J002"]){
                 //0-待支付
                 if ([rdModel.payStatus isEqualToString:@"0"]) {
                     VC.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/carReport.html?code=%@", rlModel.reportCode];
                 //1-支付完成
                 } else if ([rdModel.payStatus isEqualToString:@"1"]) {
                     VC.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/carReport.html?code=%@&%@", rlModel.reportCode,rdModel.rptUrl];
                 }
             }
             [weakSelf.navigationController pushViewController:VC animated:YES];
         } else {

         }
     } onError:^(NSError *error) {
         
     }];
}

#pragma mark - --------------------------------------懒加载--------------------------------------------
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
