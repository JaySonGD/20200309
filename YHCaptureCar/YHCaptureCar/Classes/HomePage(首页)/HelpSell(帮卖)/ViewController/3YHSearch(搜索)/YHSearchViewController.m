//
//  YHSearchViewController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/22.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHSearchViewController.h"

#import "YHCollectCell.h"

#import "YHCommon.h"
//#import "YHSVProgressHUD.h"
#import "MBProgressHUD+MJ.h"

#import "YHHelpSellService.h"
#import "UIView+Frame.h"

#import <Masonry.h>
#import <LYEmptyView/LYEmptyViewHeader.h>
#import <MJRefresh.h>

#import "YHDetailViewController.h"
#import "YTDetailViewController.h"

@interface YHSearchViewController ()
<
UITextFieldDelegate,UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, weak) UITextField *searchBar ;
@property (nonatomic, strong) NSMutableArray <NSString *> *historyDatas;
@property (nonatomic, strong)  NSMutableArray <TTZCarModel *> *models;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *historyView;
@property (nonatomic, assign) NSInteger page;
@end

@implementation YHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

- (void)dealloc{
    NSLog(@"%s---我挂了", __func__);
}

#pragma mark 处理网络数据
- (void)loadData{
    
    if (!self.searchBar.text.length) {
        [MBProgressHUD showError:@"请你输入你要搜索的关键字" toView:self.view];
        return;
    }
    
    if(self.page == 1) [MBProgressHUD showMessage:nil toView:self.view];//[YHSVProgressHUD showYH];
    [self.tableView ly_startLoading];

    [YHHelpSellService searchEntrustTradeForPage:self.page searchContent:self.searchBar.text carType:self.isHelpSell?2:5 onComplete:^(NSMutableArray<TTZCarModel *> *models) {
        
        if (self.page==1) {
            [MBProgressHUD hideHUDForView:self.view];//[YHSVProgressHUD dismiss];
            self.models = models;
            //if(!models.count) [MBProgressHUD showSuccess:@"暂无收藏数据" toView:self.view];
            
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.models addObjectsFromArray:models];
            if (models.count < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        if(models.count) self.page ++;
        
        [self.tableView reloadData];
        [self.tableView ly_endLoading];

        ///////
//        if(self.page == 1) [YHSVProgressHUD dismiss];
//        self.models = models;
//        [self.tableView reloadData];
//        [self.tableView ly_endLoading];
//
//
//
//        if(models.count >= kPageSize) {
//            self.page ++;
//            [self.tableView.mj_footer endRefreshing];
//        }
//        else{
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//
//        if(!models.count && self.page==1) {
//            [MBProgressHUD showSuccess:@"暂无搜索结果" toView:self.view];
//        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
    }];
}



#pragma mark  -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.tableView]) {
        
        tableView.mj_footer.hidden = (self.models.count < kPageSize);
        return self.models.count;
    }
    
    tableView.tableFooterView.hidden = !self.historyDatas.count;
    return self.historyDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableView]) {
        YHCollectCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"YHCollectCell"];
        cell.model = self.models[indexPath.row];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.historyDatas[indexPath.row];
    cell.textLabel.textColor = YHColor(195, 195, 195);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.historyView isEqual:tableView]) {
        
        self.searchBar.text = self.historyDatas[indexPath.row];
        [self searchAction];
        [self textChange:self.searchBar];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetailViewController"];
    VC.jumpString = @"详情";
    VC.carModel = self.models[indexPath.row];
    if (VC.carModel.carStatus == 5) {
        VC.title = @"详情";
        if (self.models[indexPath.row].flag) {
            
            YTDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YTDetailViewController"];
            VC.carModel = self.models[indexPath.row];
            VC.title = @"详情";
            VC.bottomStyle = YTDetailBottomStyleHelpSellAuth;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }

    }

    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark  -  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    
    [self saveData];
    [self loadData];
    return YES;
}

#pragma mark  -  事件监听
- (void)searchAction{
    [self saveData];
    [self loadData];
}
- (void)textChange:(UITextField *)sender{
   
    self.historyView.hidden = sender.hasText;
    self.tableView.hidden = !sender.hasText;
    if(!self.historyView.isHidden) [self.historyView reloadData];
}

- (void)clean{
    [self.historyDatas removeAllObjects];
    [self.historyView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDatas forKey:@"historyData"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark  -  自定义方法

- (void)saveData{
    
    self.page = 1;
    
    NSString *text = self.searchBar.text;
    
    if(!text.length) return;
    [self.searchBar resignFirstResponder];
    
    if([self.historyDatas containsObject:text]) [self.historyDatas removeObject:text];
    
    [self.historyDatas insertObject:text atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDatas forKey:@"historyData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 110 , 34)];
    titleView.backgroundColor = [UIColor whiteColor];
    YHViewRadius(titleView, 5);
    
    UITextField *searchBar = [[UITextField alloc] init];
    [titleView addSubview:searchBar];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 34)];
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [leftView addSubview:logoIV];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(leftView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    searchBar.leftView = leftView;//
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.placeholder = @"请输入品牌 如:保时捷";
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    searchBar.enablesReturnKeyAutomatically = YES;
    searchBar.tintColor = YHBlackColor;
    [searchBar addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

    _searchBar = searchBar;
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(0);
        make.left.equalTo(titleView).offset(5);
        make.bottom.equalTo(titleView).offset(0);
        make.right.equalTo(titleView).offset(-5);
        make.width.mas_equalTo(screenWidth - 120);
        make.height.mas_equalTo(34);
    }];
    
    self.navigationItem.titleView = titleView;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(searchAction)];
    
    [self.view addSubview:self.historyView];
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(NavbarHeight);
    }];

}

#pragma mark  -  get/set 方法

- (NSMutableArray<NSString *> *)historyDatas
{
    if (!_historyDatas) {
        
        NSMutableArray *datas = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"historyData"];
        if (datas.count) {
            _historyDatas = datas.mutableCopy;
        }else{
            _historyDatas = [NSMutableArray array];
        }
    }
    return _historyDatas;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YHCollectCell" bundle:nil] forCellReuseIdentifier:@"YHCollectCell"];

        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

        //_tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0 );
        //_tableView.contentOffset = CGPointMake(0, 0);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"icon_nodata"
                                                              titleStr:@"暂无搜索数据"
                                                             detailStr:nil];

        
        
        
        _tableView.rowHeight = 135;//UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YHBackgroundColor;
        _tableView.hidden = YES;
        
        
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

- (UITableView *)historyView
{
    if (!_historyView) {
        _historyView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_historyView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [_historyView setSeparatorInset:UIEdgeInsetsZero];
        [_historyView setLayoutMargins:UIEdgeInsetsZero];
        _historyView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

        
        _historyView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _historyView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        
        _historyView.sectionFooterHeight = 0;
        _historyView.estimatedSectionFooterHeight = 0;
        
        _historyView.rowHeight = 35;
        _historyView.dataSource = self;
        _historyView.delegate = self;
        _historyView.backgroundColor = YHBackgroundColor;
        
        //设置空视图
        _historyView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"icon_nodata"
                                                                titleStr:@"暂无搜索记录"
                                                               detailStr:nil];

        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 54.5)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
        line.backgroundColor = YHBackgroundColor;

        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        deleteBtn.frame = CGRectMake(0, 0.5, screenWidth, 54);
        [deleteBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [deleteBtn setTitle:@"清空搜索记录" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:line];
        [footerView addSubview:deleteBtn];
        
        _historyView.tableFooterView = footerView;
        
    }
    return _historyView;
}



@end
