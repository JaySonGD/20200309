//
//  YHSolutionListViewController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSolutionListViewController.h"
#import "YHSolutionListCell.h"
#import "YHNoDataCell.h"
#import "YHSolutionListModel.h"
#import "YHBillTypeDataModel.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIViewController+OrderDetail.h"
#import "YJProgressHUD.H"

@interface YHSolutionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *unFinishedBtn;
@property (weak, nonatomic) IBOutlet UIView *unFinishedView;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
@property (weak, nonatomic) IBOutlet UIView *finishedView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *pageDataArray;
@property (nonatomic, strong) YHSolutionListModel *solutionListModel;

@end

@implementation YHSolutionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
    
    //初始化数据
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOrderListChange) name:@"YHNotificationOrderListChange" object:nil];
}

- (void)notificationOrderListChange {
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - ------------------------------------初始化变量----------------------------------------
- (void)initVar {
    if (self.isSolution == YES) {
        self.tag = 1;
        self.title = @"工单列表";
    } else {
        self.tag = 3;
        self.title = @"我的订单";
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YHSolutionListCell" bundle:nil] forCellReuseIdentifier:@"YHSolutionListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHNoDataCell" bundle:nil] forCellReuseIdentifier:@"YHNoDataCell"];
}

#pragma mark - -------------------------------------初始化UI------------------------------------------
- (void)initUI {
    [self.unFinishedBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
    [self.finishedBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
    self.unFinishedView.hidden = NO;
    self.finishedView.hidden = YES;
}

- (void)initData {
    if (self.tag != 2) {
        [self queryData];
    } else {
        WeakSelf;
        
        self.page = 1;

        //下拉刷新MJRefreshNormalHeader
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf queryData];
        }];
        
        //上拉加载更多MJRefreshAutoNormalFooter
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf queryData];
        }];
        
        if (self.page == 1) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - ------------------------------------初始化数据------------------------------------------
- (void)queryData {
    
    if (self.tag != 2) {
        self.page = 1;
    }

    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getSolutionListOrDemanderWithToken:[YHTools getAccessToken]
                                                                                   page:[NSString stringWithFormat:@"%d",self.page]
                                                                               pagesize:@"10"
                                                                                    tag:self.tag
                                                                             onComplete:^(NSDictionary *info)
    {
        NSLog(@"\n解决方案:\n%ld====%@",(long)self.tag,info);

        [MBProgressHUD hideHUDForView:self.view];
        self.unFinishedBtn.userInteractionEnabled = YES;
        self.finishedBtn.userInteractionEnabled = YES;
        
        if ([[info[@"code"]stringValue] isEqualToString:@"20000"]) {
            //解决方案未完成
            //需求方未完成、已完成
            if (self.tag != 2) {
                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in info[@"data"][@"list"]) {
                    self.solutionListModel = [YHSolutionListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:self.solutionListModel];
                }
            //解决方案已完成
            } else {
                if (self.page == 1) {
                    [self.pageDataArray removeAllObjects];
                }
                
                for (NSDictionary *dict in info[@"data"][@"list"]) {
                    YHSolutionListModel *model = [YHSolutionListModel mj_objectWithKeyValues:dict];
                    [self.pageDataArray addObject:model];
                }
                
                self.page += 1;
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        } else {
            YHLogERROR(@"");
        }
    } onError:^(NSError *error) {
        self.unFinishedBtn.userInteractionEnabled = YES;
        self.finishedBtn.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - ---------------------------------tableView代理方法--------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tag != 2) {
        if (self.dataArray.count != 0) {
            return self.dataArray.count;
        } else {
            return 1;
        }
    } else {
        if (self.pageDataArray.count != 0) {
            return self.pageDataArray.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag != 2) {
        if (self.dataArray.count != 0) {
            YHSolutionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHSolutionListCell"];
            [cell refreshUIWithModel:self.dataArray[indexPath.row] Tag:self.tag];
            return cell;
        } else {
            YHNoDataCell *NoDataCell = [tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
            NoDataCell.remindL.text = @"暂无数据";
            return NoDataCell;
        }
    } else {
        if (self.pageDataArray.count != 0) {
            YHSolutionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHSolutionListCell"];
            [cell refreshUIWithModel:self.pageDataArray[indexPath.row] Tag:self.tag];
            return cell;
        } else {
            YHNoDataCell *NoDataCell = [tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
            NoDataCell.remindL.text = @"暂无数据";
            return NoDataCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag != 2) {
        if (self.dataArray.count != 0) {
            return 125;
        } else {
            return self.tableView.frame.size.height;
        }
    } else {
        if (self.pageDataArray.count != 0) {
            return 125;
        } else {
            return self.tableView.frame.size.height;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YHSolutionListModel *solutionListModel;
    if (self.tag != 2) {
        solutionListModel = self.dataArray[indexPath.row];
    } else {
        solutionListModel = self.pageDataArray[indexPath.row];
    }
    
    NSMutableDictionary *dict;
    YHBillTypeDataModel *billTypeDataModel;

    if (solutionListModel.billTypeData.count > 0) {
        
        billTypeDataModel = solutionListModel.billTypeData[0];
        
        if ((solutionListModel.billTypeData.count == 1) && ![billTypeDataModel.billType isEqualToString:@"G"]) {
            dict = [billTypeDataModel mj_JSONObject];
        } else {
            dict = [solutionListModel mj_JSONObject];
        }
    } else {
        dict = [solutionListModel mj_JSONObject];
    }
    dict = dict.mutableCopy;
    dict[@"isSolution"] = @(self.isSolution);
    
    if ((self.isSolution == NO) && [billTypeDataModel.billType isEqualToString:@"G"] && [billTypeDataModel.nextStatusCode isEqualToString:@"consulting"]) {
        [MBProgressHUD showError:@"技术接单中"];
        return;
    } else {
        [self orderDetailNavi:dict code:YHFunctionIdNewWorkOrder];
    }
}

#pragma mark - -------------------------------------点击事件--------------------------------------------
- (IBAction)switchTabBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
          {
              if (self.isSolution == YES) {
                  self.tag = 1;
                  self.tableView.mj_header.hidden = YES;
                  self.tableView.mj_footer.hidden = YES;
              } else {
                  self.tag = 3;
                  self.tableView.mj_header.hidden = YES;
                  self.tableView.mj_footer.hidden = YES;
              }
              
              self.unFinishedBtn.userInteractionEnabled = NO;

              [self.unFinishedBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
              [self.finishedBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
              self.unFinishedView.hidden = NO;
              self.finishedView.hidden = YES;
          }
            break;
        case 2:
           {
               if (self.isSolution == YES) {
                   self.tag = 2;
                   self.tableView.mj_header.hidden = NO;
                   self.tableView.mj_footer.hidden = NO;
               } else {
                   self.tag = 4;
                   self.tableView.mj_header.hidden = YES;
                   self.tableView.mj_footer.hidden = YES;
               }
               
               self.finishedBtn.userInteractionEnabled = NO;

               [self.unFinishedBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
               [self.finishedBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
               self.unFinishedView.hidden = YES;
               self.finishedView.hidden = NO;
           }
            break;
        default:
            break;
    }
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - --------------------------------------懒加载--------------------------------------------
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableArray *)pageDataArray
{
    if (!_pageDataArray) {
        _pageDataArray = [[NSMutableArray alloc]init];
    }
    return _pageDataArray;
}


@end
