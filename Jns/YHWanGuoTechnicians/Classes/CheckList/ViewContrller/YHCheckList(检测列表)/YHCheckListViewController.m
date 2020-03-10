//
//  YHCheckListViewController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckListViewController.h"
#import "AppDelegate.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>

#import "CheckNetwork.h"
#import "YHNetworkPHPManager.h"
#import "YHCheckListModel0.h"
#import "YHBalanceView.h"
#import "YHNoDataCell.h"
#import "YHCheckListCell0.h"
#import "YHCheckListDetailViewController.h"

@interface YHCheckListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelWidth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *functionView;            //功能视图
@property (nonatomic, weak) YHBalanceView *balanceView;        //结算金额视图

@property (nonatomic, assign) int tempPage;                    //临时页码
@property (nonatomic, assign) int page;                        //常态页码
@property (nonatomic, assign) int searchPage;                  //搜索页码
@property (nonatomic, assign) NSInteger visibleRows;           //记录列表停留时可见行的起始行

@property (nonatomic, strong) YHCheckListModel0 *model0;
@property (nonatomic, strong) NSMutableArray *dataArray;       //数据源
@property (nonatomic, strong) NSMutableArray *searchArray;     //搜索结果数据源

@property (nonatomic, assign) BOOL isBalanceed;                //结算权限
@property (nonatomic, assign) BOOL isSearch;                   //是否搜索状态
@property (nonatomic, copy) NSString *keyword;                 //搜索关键字

@end

@implementation YHCheckListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
    
    //初始化数据
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - --------------------------------------初始化变量------------------------------------------
- (void)initVar
{
    //设置搜索初始状态为NO
    self.isSearch = NO;
    
    //设置常态页码
    self.page = 1;
    
    //设置搜索页码
    self.searchPage = 1;
}

#pragma mark - --------------------------------------初始化UI------------------------------------------
- (void)initUI
{
    //1.initSearchBar
    [self initSearchBar];
    
    //2.initCell
    [self initCell];
    
}

#pragma mark - 1.initSearchBar
- (void)initSearchBar
{
    self.searchView.layer.cornerRadius = 5;
    self.searchView.layer.masksToBounds = YES;
    self.cancelWidth.constant = 0;//“取消按钮”默认隐藏
}

#pragma mark - 2.initCell
- (void)initCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YHNoDataCell" bundle:nil] forCellReuseIdentifier:@"YHNoDataCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCheckListCell0" bundle:nil] forCellReuseIdentifier:@"YHCheckListCell0"];
}

#pragma mark - -------------------------------------初始化数据------------------------------------------
- (void)initData
{
    //1.initBalanceData
    [self initBalanceData];
    
    //2.initNormalData
    [self initNormalData];
}

#pragma mark - 1.initBalanceData
- (void)initBalanceData
{
    NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
    NSDictionary *data = userInfo[@"data"];
    NSArray *menuListArray = data[@"menuList"];
    for (NSDictionary *menuItemDict in menuListArray) {
        if ([menuItemDict[@"rejectList"] rangeOfString:@"Bill_Undisposed_saveEndBill"].location == NSNotFound) {
            self.isBalanceed = YES;
        } else {
            self.isBalanceed = NO;
            return;
        }
    }
}

#pragma mark - 2.initNormalData
- (void)initNormalData
{
    WeakSelf;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.isSearch == NO) {
            [weakSelf loadNormalNewData];
        } else {
            [weakSelf loadSearchNewData];
        }
    }];
    
    //上拉加载更多
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    
    //一开始就刷新
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 1
- (void)loadNormalNewData
{
    self.page = 1;
    [self queryData];
}

#pragma mark - 2
- (void)loadSearchNewData
{
    self.searchPage = 1;
    [self queryData];
}

#pragma mark - 3
- (void)queryData
{
    //搜索框处于未搜索状态
    if (self.isSearch == NO) {
        self.tempPage = self.page;
        self.keyword = @"";
        //搜索框处于搜索状态
    } else {
        self.tempPage = self.searchPage;
        self.keyword = self.searchTF.text;
    }
    NSLog(@"-----------=====页码标识:%d===搜索的关键字为:%@=====------------",self.tempPage,self.keyword);
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] queryCheckListWithToken:[YHTools getAccessToken]
                                                                 WithKeyword:self.keyword
                                                                    WithSort:@""
                                                                    WithPage:self.tempPage
                                                                WithPageSize:20
                                                                        type:self.type
                                                                  onComplete:^(NSDictionary *info)
    {
        NSLog(@"\n检测列表:\n%@,%@,%@",info,info[@"msg"],info[@"code"]);
        if (([info[@"code"] longLongValue] == 20000) || ([info[@"code"] longLongValue] == 20400)) {
            //1.下拉刷新,清除所有数据源,避免重复添加
            if (self.isSearch == NO) {
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                }
            } else {
                if (self.searchPage == 1) {
                    [self.searchArray removeAllObjects];
                }
            }
            
            //2.解析数据并模型化
            for (NSDictionary *dict in info[@"data"][@"list"]) {
                YHCheckListModel0 *model = [YHCheckListModel0 mj_objectWithKeyValues:dict];
                if (self.isSearch == NO) {
                    [self.dataArray addObject:model];
                } else {
                    [self.searchArray addObject:model];
                }
            }
            
            //3.Page++
            if (self.isSearch == NO) {
                if (self.page < [info[@"total"] intValue]) {
                    self.page += 1;
                }
            } else {
                if (self.searchPage < [info[@"total"] intValue]) {
                    self.searchPage += 1;
                }
            }
            
            //4.停止刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            //5.刷新列表
            [self.tableView reloadData];
            
            //6.隐藏Loading
            [MBProgressHUD hideHUDForView:self.view];
        }else{
            YHLogERROR(@"");
            [MBProgressHUD hideHUDForView:self.view];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - ----------------------------------UITextField代理方法----------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.searchTF) {
        //用户触控键盘时，“取消按钮”出现
        self.cancelWidth.constant = 40;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTF) {
        //记录列表停留时可见行的起始行
        if (self.isSearch == NO) {
            NSArray *indexPathArray = self.tableView.indexPathsForVisibleRows;
            NSIndexPath *indexPath = indexPathArray[0];
            self.visibleRows = indexPath.row;
            NSLog(@"----记录可见行起始行：%ld----",self.visibleRows);
        } else {
            NSLog(@"不是第一次由普通状态转为搜索状态");
        }
        
        //1.发起搜索
        if (!IsEmptyStr(self.searchTF.text)) {
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            //设置为搜索状态
            self.isSearch = YES;
            
            //发起搜索
            [self loadSearchNewData];
        } else {
            [MBProgressHUD showError:@"请输入搜索内容"];
        }
    }
    
    //2.键盘收起
    return [textField resignFirstResponder];
}

- (IBAction)cancel:(UIButton *)sender
{
    //1.设置为未搜索状态
    self.isSearch = NO;
    
    //2.清空输入框内容
    self.searchTF.text = @"";
    
    //3.“取消按钮”隐藏
    self.cancelWidth.constant = 0;
    
    //4.键盘收起
    [self.searchTF resignFirstResponder];
    
    //5.刷新列表
    [self.tableView reloadData];
    
    //6.回到搜索前的位置
    if (self.dataArray.count == 0) {
        [self loadNormalNewData];
    } else {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.visibleRows inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - --------------------------------tableView代理方法--------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //搜索框处于未搜索状态
    if (self.isSearch == NO) {
        if (self.dataArray.count != 0) {
            return self.dataArray.count;
        } else {
            return 1;
        }
    //搜索框处于搜索状态
    } else {
        if (self.searchArray.count != 0) {
            return self.searchArray.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    //搜索框处于未搜索状态
    if (self.isSearch == NO) {
        if (self.dataArray.count != 0) {
            YHCheckListCell0 *cell0 = [tableView dequeueReusableCellWithIdentifier:@"YHCheckListCell0"];
            [cell0 refreshUIWithModel:self.dataArray[indexPath.row] WithBalanceed:self.isBalanceed];
            [cell0 setBtnClickBlock:^(UIButton *button) {
                switch (button.tag) {
                    case 1:
                    {
                        //[self.dataArray removeObjectAtIndex:indexPath.row];
                        //[self.tableView reloadData];
                    }
                        break;
                    case 2:
                        [weakSelf showBalanceViewWithRow:indexPath.row WithCell:cell0];
                        break;
                    default:
                        break;
                }
            }];
            return cell0;
        } else {
            YHNoDataCell *NoDataCell = [tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
            NoDataCell.remindL.text = @"暂无检测单";
            return NoDataCell;
        }
        //搜索框处于搜索状态
    } else {
        if (self.searchArray.count != 0) {
            YHCheckListCell0 *cell0 = [tableView dequeueReusableCellWithIdentifier:@"YHCheckListCell0"];
            [cell0 refreshUIWithModel:self.searchArray[indexPath.row] WithBalanceed:self.isBalanceed];
            [cell0 setBtnClickBlock:^(UIButton *button) {
                switch (button.tag) {
                    case 1:
                    {
                        //[self.searchArray removeObjectAtIndex:indexPath.row];
                        //[self.tableView reloadData];
                    }
                        break;
                    case 2:
                        [weakSelf showBalanceViewWithRow:indexPath.row WithCell:cell0];
                        break;
                    default:
                        break;
                }
            }];
            return cell0;
        } else {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            YHNoDataCell *NoDataCell = [tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
            NoDataCell.remindL.text = @"暂无搜索到相应检测单";
            return NoDataCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //搜索框处于未搜索状态
    if (self.isSearch == NO) {
        if (self.dataArray.count != 0) {
            return 216;
        } else {
            return self.tableView.frame.size.height;
        }
    //搜索框处于搜索状态
    } else {
        if (self.searchArray.count != 0) {
            return 216;
        } else {
            return self.tableView.frame.size.height;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCheckListDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHCheckList" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCheckListDetailViewController"];
    YHCheckListModel0 *model;
    if (self.isSearch == NO) {
        model = self.dataArray[indexPath.row];
    } else {
        model = self.searchArray[indexPath.row];
    }
    VC.partnerId = model.ID;
    VC.carDealerName = model.carDealerName;
    VC.type = self.type;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - -----------------------------------功能模块代码----------------------------------------
#pragma mark - 1.展示结算金额视图
- (void)showBalanceViewWithRow:(NSInteger)row WithCell:(YHCheckListCell0 *)cell
{
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    self.functionView.layer.cornerRadius = 15;
    self.functionView.layer.masksToBounds = YES;
    [self.view addSubview:self.functionView];
    
    if (!self.balanceView) {
        self.balanceView = [[NSBundle mainBundle]loadNibNamed:@"YHBalanceView" owner:self options:nil][0];
        self.balanceView.frame = CGRectMake(30, (screenHeight-180)/2 - 100, screenWidth-60, 180);
        self.balanceView.layer.cornerRadius = 5;
        self.balanceView.layer.masksToBounds = YES;
        self.balanceView.balanceTF.delegate = self;
        self.balanceView.smallBalanceView.layer.borderWidth = 1;
        self.balanceView.smallBalanceView.layer.borderColor = [YHBackgroundColor CGColor];
        [self.functionView addSubview:self.balanceView];
    }
    
    //点击事件
    self.balanceView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://取消
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://确定
            {
                if (![self.balanceView.balanceTF.text isEqualToString:@""]) {
                    weakSelf.model0 = self.dataArray[row];
                    [[YHNetworkPHPManager sharedYHNetworkPHPManager] balanceAmountWithToken:[YHTools getAccessToken]
                                                                                WithBucheId:weakSelf.model0.ID
                                                                                 WithAmount:[weakSelf.balanceView.balanceTF.text floatValue]
                                                                                 onComplete:^(NSDictionary *info)
                    {
                        NSLog(@"\n结算接口:\n%@",info);
                        if ([info[@"code"] longLongValue] == 20000) {
                            [MBProgressHUD showSuccess:info[@"msg"]];
                            weakSelf.model0.amount = [NSString stringWithFormat:@"%@%@",self.balanceView.balanceTF.text,@".00"];
                            weakSelf.model0.status = @"1";
                            [weakSelf.tableView reloadData];
                            [weakSelf.functionView removeFromSuperview];
                        }
                    } onError:^(NSError *error) {
                    
                    }];
                } else {
                    [MBProgressHUD showError:@"请输入结算金额"];
                }
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - --------------------------------------懒加载--------------------------------------------
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc]init];
    }
    return _searchArray;
}

@end
