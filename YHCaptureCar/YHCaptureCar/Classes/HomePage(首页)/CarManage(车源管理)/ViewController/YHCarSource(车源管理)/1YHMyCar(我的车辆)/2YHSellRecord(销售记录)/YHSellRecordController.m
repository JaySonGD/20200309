//
//  YHSellRecordController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHSellRecordController.h"
#import "YHSellRecordCell.h"
#import "YHHelpSellService.h"
#import "UIView+Frame.h"

#import <Masonry.h>
#import <MJRefresh.h>
#import <LYEmptyView/LYEmptyViewHeader.h>

#import "YHCommon.h"

#import "YHDetailViewController.h"

@interface YHSellRecordController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray <TTZCarModel *> *models;
@property (nonatomic, assign) NSInteger page;



@end

@implementation YHSellRecordController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.page = 1;
    [self loadData];
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upDataList:) name:@"kUpDataList" object:nil];
}


- (void)upDataList:(NSNotification *)noti{
    if(!self.models) return;
    NSInteger tag =  [[noti.userInfo valueForKey:@"tag"] integerValue];
    
    if (tag == 0) {
        self.page = 1;
        [self loadData];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 处理网络数据
- (void)loadData{
    
    
    [YHHelpSellService sellRecordListForPage:self.page onComplete:^(NSMutableArray<TTZCarModel *> *models) {
        
        [self.tableView.mj_header endRefreshing];
        if (self.page==1) {
            self.models = models;
            [self.tableView.mj_footer endRefreshing];
            //if(!models.count) [MBProgressHUD showSuccess:@"暂无数据" toView:self.view];
            
        }else{
            [self.models addObjectsFromArray:models];
            if (models.count < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        if(models.count) self.page ++;
        
        [self.tableView reloadData];
        
        
    } onError:^(NSError *error) {
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}
#pragma mark  -  UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHSellRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHSellRecordCell"];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.mj_footer.hidden = (self.models.count < kPageSize);
    return self.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetailViewController"];
    VC.carModel = self.models[indexPath.row];
    VC.jumpString = @"销售记录详情";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark  -  get/set 方法
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YHSellRecordCell" bundle:nil] forCellReuseIdentifier:@"YHSellRecordCell"];
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"icon_nodata"
                                                            titleStr:@"暂无数据"
                                                           detailStr:nil];
        
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf loadData];
        }];
        
        
        _tableView.rowHeight = 125;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YHBackgroundColor;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        footer.refreshingTitleHidden = YES;
        footer.height = 35.f;
        footer.stateLabel.font = [UIFont systemFontOfSize:12.0];
        footer.stateLabel.textColor =  YHColor0X(0x666666, 1.0);
        footer.backgroundColor = YHBackgroundColor;
        footer.triggerAutomaticallyRefreshPercent = 0.1f;
        [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
        
        _tableView.mj_footer = footer;
        _tableView.mj_footer.hidden = YES;
        
    }
    return _tableView;
}


@end
