//
//  YHInventoryController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/29.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHInventoryController.h"
#import "YHNetworkManager.h"

#import "YHInventoryListCell.h"
#import "YHHelpSellService.h"
#import "UIView+Frame.h"

#import <Masonry.h>
#import <MJRefresh.h>
#import <LYEmptyView/LYEmptyViewHeader.h>

#import "YHCommon.h"

#import "YHDetailViewController.h"

#import "YHFailReasonView.h"
#import "YHTools.h"

#import "YTDetailViewController.h"


@interface YHInventoryController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray <TTZCarModel *> *models;
@property (nonatomic, assign) NSInteger page;

//功能视图
@property (nonatomic, strong) UIView *functionView;

//失败原因视图
@property (nonatomic, weak) YHFailReasonView *failReasonView;
@end

@implementation YHInventoryController


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
    
    
    [YHHelpSellService inventoryListForPage:self.page onComplete:^(NSMutableArray<TTZCarModel *> *models) {
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    YHInventoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHInventoryListCell"];
    cell.model = self.models[indexPath.row];
    
    [cell setBtnClickBlock:^(UIButton *button) {
        [weakSelf showReasonViewWithModel:self.models[indexPath.row]];
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.mj_footer.hidden = (self.models.count < kPageSize);
    return self.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTZCarModel *model = self.models[indexPath.row];
    if (model.flag) {
        
        YTDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YTDetailViewController"];
        VC.carModel = model;
        VC.title = @"详情";
        
        
        

        VC.bottomStyle = YTDetailBottomStyleERPAuth;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    YHDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetailViewController"];
    VC.carModel = model;
    VC.jumpString = @"在库车辆详情";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark  -  get/set 方法
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YHInventoryListCell" bundle:nil] forCellReuseIdentifier:@"YHInventoryListCell"];
        
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
        
        
        _tableView.rowHeight = 135;
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

#pragma mark - --------------------------------------五、功能模块代码------------------------------------------
#pragma mark - 1.失败原因
- (void)showReasonViewWithModel:(TTZCarModel *)model
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.failReasonView) {
        self.failReasonView = [[NSBundle mainBundle]loadNibNamed:@"YHFailReasonView" owner:self options:nil][0];
        self.failReasonView.frame = CGRectMake(30, (screenHeight-220)/2-60, screenWidth-60, 220);
        self.failReasonView.layer.cornerRadius = 5;
        self.failReasonView.layer.masksToBounds = YES;
        [self.functionView addSubview:self.failReasonView];
    }
    
    self.failReasonView.titleLabel.text = @"拒绝/下架原因";
    self.failReasonView.textView.text = model.remark;
    
    self.failReasonView.btnClickBlock = ^(UIButton *button) {
        [weakSelf.functionView removeFromSuperview];
    };
}

@end
