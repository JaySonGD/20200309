//
//  YHExtrendBackListController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrendBackListController.h"
#import "YHExtrendBackCell.h"
#import "YHNetworkPHPManager.h"
#import "YHCommon.h"
#import "YHTools.h"

#import "YHExtrendBackDetailController.h"
extern NSString *const notificationBackSearch;
@interface YHExtrendBackListController ()
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)NSMutableArray *dataSourceWorks;
@property (strong, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *typeB1;
@property (weak, nonatomic) IBOutlet UIButton *typeB2;
@property (weak, nonatomic) IBOutlet UIButton *typeB3;
@property (weak, nonatomic) IBOutlet UIView *typeLine1;
@property (weak, nonatomic) IBOutlet UIView *typeLine2;
@property (weak, nonatomic) IBOutlet UIView *typeLine3;
@property (nonatomic)YHExtrendBackModel backModel;
@end

@implementation YHExtrendBackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationBackSearch:) name:notificationBackSearch object:nil];
    _backModel = YHExtrendBackModelUn;
    [self reupdataDatasource];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notificationBackSearch:(NSNotification*)notice{
    self.dataSource = nil;
    NSDictionary *userInfo = notice.userInfo;
    NSNumber *model = userInfo[@"state"];
    if (!model) {
        model = @0;
    }
    [self menuSwitch:model.integerValue];
    [self getList:model.integerValue keyword:userInfo[@"key"] warrantyName:userInfo[@"plan"]];
}

- (void)menuSwitch:(NSInteger)index{
    [@[_typeB1,_typeB2,_typeB3]enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            [button setTitleColor:YHNaviColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:YHCellColor forState:UIControlStateNormal];
        }
    }];
    [@[_typeLine1,_typeLine2,_typeLine3] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.hidden = !(index == idx);
    }];
}

- (IBAction)typeActions:(UIButton*)sender {
    _backModel = sender.tag;
    [self menuSwitch:_backModel];
    [self reupdataDatasource];
}


- (void)getList:(YHExtrendBackModel)type keyword:(NSString*)keyword warrantyName:(NSString*)warrantyName{
    self.dataSource = nil;
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     cashBackGetDetail:[YHTools getAccessToken]
     startDate:_fromDate
     endDate:_toDate
     type:@[@"1", @"2", @"3"][type]
     page:nil
     pagesize:nil
     keyword:keyword
     warrantyName:warrantyName
     selectShopOpenId:nil
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             weakSelf.dataSource = info[@"data"];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 [weakSelf showErrorInfo:info];
             }
         }
         [weakSelf.tableView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}


- (void)reupdataDatasource{
    self.dataSource = nil;
    [self getList:_backModel keyword:nil warrantyName:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHExtrendBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_dataSource[indexPath.row] model:_backModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHExtrendBackDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHExtrendBackDetailController"];
    controller.info = _dataSource[indexPath.row];
    controller.backModel = _backModel;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
