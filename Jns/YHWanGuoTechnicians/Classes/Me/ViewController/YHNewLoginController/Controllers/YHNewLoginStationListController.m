//
//  YHNewLoginStationListController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHNewLoginStationListController.h"
#import "YHLoginStationCell.h"
#import "AppDelegate.h"
#import "YHCommon.h"
#import "YHStoreTool.h"

@interface YHNewLoginStationListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *stationListTableView;

@end

@implementation YHNewLoginStationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    [self initNewLoginStationListControllerView];
    
}
- (void)initBase{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topMargin = iPhoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"left_login"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    CGFloat backY = topMargin;
    backBtn.frame = CGRectMake(10, backY, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initNewLoginStationListControllerView{
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    CGFloat bottomMargin = iPhoneX ? 34 : 0;
    UITableView *stationListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    stationListTableView.tableFooterView = [[UIView alloc] init];
    stationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    stationListTableView.delegate = self;
    stationListTableView.dataSource = self;
    self.stationListTableView = stationListTableView;
    [self.view addSubview:stationListTableView];
    [stationListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(topMargin));
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 0, 90);
    
    UILabel *titleL = [[UILabel alloc] init];
    [headerView addSubview:titleL];
    titleL.text = @"选择门店登录";
    titleL.font = [UIFont boldSystemFontOfSize:26];
    titleL.textColor = [UIColor blackColor];
    [titleL sizeToFit];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@25);
    }];
    stationListTableView.tableHeaderView = headerView;
    
}
- (void)setStationListArr:(NSArray *)stationListArr{
    _stationListArr = stationListArr;
    [self.stationListTableView reloadData];
}
#pragma mark - UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stationListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHLoginStationCell *loginStation = [YHLoginStationCell createLoginStationCelltableView:tableView reuseIdentifier:@"YHLoginStationCellID"];
    loginStation.info = self.stationListArr[indexPath.row];
    return loginStation;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0;
}

#pragma mark - UITableViewDelegate ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.stationListArr[indexPath.row];
    [self selectStationAdressToLogin:info[@"org_id"]];
}

- (void)selectStationAdressToLogin:(NSString *)org_id{
    
    if(!IsEmptyStr([YHTools getAccessToken])){
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] LogoutOnComplete:^(NSDictionary *info) {
        
    } onError:^(NSError *error) {
        
    }];
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] newLoginUserName:self.userName passWord:[YHTools md5:self.passWord] org_id:org_id confirm_bind:NO onComplete:^(NSDictionary *info) {
        
        NSLog(@"----------------->>>>2.😁:%@<<<<----------------",info);

        int code = [info[@"code"] intValue];
        [MBProgressHUD hideHUDForView:self.view];
        
        // 登录成功绑定一家店铺
        if (code == 20000) {
            NSDictionary *data = info[@"data"];
            [[YHStoreTool ShareStoreTool] setOrg_id:data[@"org_id"]];
            [YHTools setAccessToken:data[@"token"]];
            [YHTools setName:self.userName];
            [YHTools setPassword:self.passWord];
            [YHTools setServiceCode:data[@"url_code"]];
            
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:YES];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsManualLogin:YES];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        if(![self networkServiceCenter:info[@"code"]]){
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

@end
