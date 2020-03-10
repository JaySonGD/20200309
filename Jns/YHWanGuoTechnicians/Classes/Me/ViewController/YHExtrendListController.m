//
//  YHExtrendListController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/10/23.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrendListController.h"

#import "YHCommon.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "YHProjectCell.h"
#import "YHExtrendDetailController.h"
#import "MJRefresh.h"
#import "UIAlertController+Blocks.h"
extern NSString *const notificationOrderListChange;
@interface YHExtrendListController () <UIActionSheetDelegate>
@property (nonatomic)NSUInteger page;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateWidthLC;

@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)NSMutableArray *dataSourceShow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchKeyFT;
@property (weak, nonatomic) IBOutlet UITableView *searchKeyTableview;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateP;
@property (nonatomic)YHExtrendModel extrendModel;
- (IBAction)dateAction:(id)sender;
- (IBAction)termAction:(id)sender;
- (IBAction)examineAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *datePBox;
- (IBAction)dateComfirmAction:(id)sender;
- (IBAction)dateCancelAction:(id)sender;

@property (strong, nonatomic)NSString *date;
@property (strong, nonatomic)NSString *term;
@property (strong, nonatomic)NSString *state;
@property (strong, nonatomic)NSString *style;
@property (strong, nonatomic)NSString *dateStr;
@property (strong, nonatomic)NSString *termStr;
@property (strong, nonatomic)NSString *stateStr;
@property (strong, nonatomic)NSString *styleStr;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic)IBOutlet UIButton *dateB;
@property (weak, nonatomic)IBOutlet UIButton *termB;
@property (weak, nonatomic)IBOutlet UIButton *stateB;
@property (nonatomic)BOOL searchModel;
@property (weak, nonatomic) IBOutlet UIButton *classB;
@property (nonatomic)BOOL isTerm;//服务期限
@property (nonatomic)BOOL isState;//延长保修工单状态
@property (nonatomic)BOOL isStyle;//延长保修工单类型
@end

@implementation YHExtrendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationOrderListChange:) name:notificationOrderListChange object:nil];
    self.dataSource = [@[]mutableCopy];
    self.dataSourceShow = [@[]mutableCopy];
    _dateP.maximumDate = [NSDate date];
    _styleStr = @"待审核";
    _extrendModel = YHExtrendModelPendingAudit;
    __weak __typeof__(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf reupdataDatasource:NO];
        //结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    [self.tableView.mj_footer beginRefreshing];
//    [self reupdataDatasource];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notificationOrderListChange:(NSNotification*)notice{
    self.page = 1;
    [_dataSource removeAllObjects];
    [_dataSourceShow removeAllObjects];
    _searchModel = NO;
    [_tableView reloadData];
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer.hidden = NO;
    [self reupdataDatasource:NO];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _searchModel = YES;
    _tableTopLC.constant = 12;
    [_tableView reloadData];
}

- (IBAction)searchAction:(id)sender {
    _tableTopLC.constant = 71;
    [[self view] endEditing:YES];
    _searchModel = NO;
    [self updataList:YES];
}

- (void)updataList:(BOOL)isSeach {
    
    [_dataSource removeAllObjects];
    [_dataSourceShow removeAllObjects];
    [_tableView reloadData];
    self.page = 1;
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer.hidden = NO;
    [self reupdataDatasource:isSeach];
}

- (void)reupdataDatasource:(BOOL)search{
    _stateB.enabled = [_styleStr isEqualToString:@"待审核"];
//    [_stateB setBackgroundColor:(([_style isEqualToString:@"3"])? ([UIColor whiteColor]) : (YHLineColor))];
    if (_extrendModel == YHExtrendModelUnpay || _extrendModel == YHExtrendModelCanceled){
        _dateWidthLC.constant = screenWidth;
    }else if (_extrendModel == YHExtrendModelPendingAudit){
        _dateWidthLC.constant = screenWidth / 3;
    }else{
        _dateWidthLC.constant = screenWidth / 2;
    }
    __weak __typeof__(self) weakSelf = self;
    NSMutableArray *searchKeys = [[YHTools getExtendSearchKeys] mutableCopy];
    if (!searchKeys) {
        searchKeys = [@[]mutableCopy];
    }
    __block BOOL isExit = NO;
    [searchKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([key isEqualToString:weakSelf.searchKeyFT.text]) {
            isExit = YES;
        }
    }];
    if (!isExit && ![_searchKeyFT.text isEqualToString:@""]) {
        [searchKeys addObject:_searchKeyFT.text];
    }
    [YHTools setExtendSearchKeys:searchKeys];
    //    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *searchKey = _searchKeyFT.text;
    NSString *packageStr;
//    @[@"空调系统", @"发动机+变速箱+传动系统", @"空调系统+发动机+变速箱+传动系统", @"全车六大系统套餐"]
    if ([searchKey isEqualToString:@"空调系统"]
        || [searchKey isEqualToString:@"发动机+变速箱+传动系统"]
        || [searchKey isEqualToString:@"空调系统+发动机+变速箱+传动系统"]
        || [searchKey isEqualToString:@"全车六大系统套餐"]) {
        searchKey = nil;
        packageStr = _searchKeyFT.text;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     blockPolicy:[YHTools getAccessToken]
     status:_style
     searchText:((search)? searchKey : (nil))
     addTime:((!search)? (_date) : (nil))
     warrantyPackageTitle:packageStr
     validTimeName:((!search)? (_term) : (nil))
     page:[NSString stringWithFormat:@"%lu", (unsigned long)_page]
     pagesize:@"10000"
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             weakSelf.page += 1;
             NSArray *data = info[@"data"];
             [weakSelf.dataSource addObjectsFromArray:data];
             [weakSelf.dataSourceShow addObjectsFromArray:data];
             NSLog(@"----------------------%@",info);
             if (data.count < CarInterval.integerValue) {
                     // 隐藏当前的上拉刷新控件
                     weakSelf.tableView.mj_header.hidden = YES;
                     weakSelf.tableView.mj_footer.hidden = YES;
             }
         }else {
//             [weakSelf.dataSource removeAllObjects];
//             [weakSelf.dataSourceShow removeAllObjects];
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     [weakSelf showErrorInfo:info];
                     weakSelf.tableView.mj_header.hidden = YES;
                     weakSelf.tableView.mj_footer.hidden = YES;
                 }
             }
         }
         [weakSelf.tableView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchModel) {
        return [YHTools getExtendSearchKeys].count;
    }
    NSUInteger count = _dataSourceShow.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchModel) {
        YHProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSearch" forIndexPath:indexPath];
        [cell loadSearchKey:[YHTools getExtendSearchKeys][indexPath.row]];
        return cell;
    }else{
        YHProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell loadExtrendData:_dataSourceShow[indexPath.row] model:_extrendModel];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchModel) {
        _searchKeyFT.text = [YHTools getExtendSearchKeys][indexPath.row];
        [self searchAction:nil];
        return;
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHExtrendDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHExtrendDetailController"];
        NSDictionary *orderInfo = _dataSourceShow[indexPath.row];
        controller.extrendOrderInfo = orderInfo;
        controller.orderInfo = self.orderInfo;
        
        NSString *statusStr = [NSString stringWithFormat:@"%@",orderInfo[@"status"]];
        controller.status = statusStr;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchModel) {
        return 60;
    }else{
        return 135;
    }
}

- (IBAction)dateAction:(id)sender {
    _datePBox.hidden = NO;
}

- (IBAction)termAction:(UIButton *)sender {
    _isTerm = YES;
    _isState = NO;
    _isStyle = NO;
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"服务期限", @"3个月", @"6个月", @"1年", nil];
    
    // Show the sheet
    //[sheet showInView:self.view];
    
    
    //return;
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"服务期限", @"3个月", @"6个月", @"1年"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;

        NSArray *keys = @[@"", @"3个月", @"6个月", @"1年"];
        NSArray *keysStr =@[@"服务期限", @"3个月", @"6个月", @"1年"];
        if (keys.count > buttonIndex) {
            _term = keys[buttonIndex];
            _termStr = keysStr[buttonIndex];
            _termB.titleLabel.text = _termStr;
            [_termB setTitle:_termStr forState:UIControlStateNormal];
        }
        _isTerm = NO;
        _isState = NO;
        _isStyle = NO;
        
        //    [self searchAction:nil];
        [self updataList:NO];

    }];
}

#pragma mark - 头像上传
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_isTerm) {
        NSArray *keys = @[@"", @"3个月", @"6个月", @"1年"];
        NSArray *keysStr =@[@"服务期限", @"3个月", @"6个月", @"1年"];
        if (keys.count > buttonIndex) {
            _term = keys[buttonIndex];
            _termStr = keysStr[buttonIndex];
            _termB.titleLabel.text = _termStr;
            [_termB setTitle:_termStr forState:UIControlStateNormal];
        }
    }
    
    if (_isStyle) {
        NSArray *keys =@[@"-1", @"", @"2", @"1", @"9"];
        NSArray *keysStr =@[@"待支付", @"待审核", @"不通过", @"已审核", @"已取消"];
        if (keys.count > buttonIndex) {
            _style = keys[buttonIndex];
            _styleStr = keysStr[buttonIndex];
            _classB.titleLabel.text = _styleStr;
            [_classB setTitle:_styleStr forState:UIControlStateNormal];
            _extrendModel = buttonIndex;
            _dateB.titleLabel.text = ((_extrendModel == YHExtrendModelAudited) ? (@"生效时间") : (@"生成时间"));
            [_dateB setTitle:((_extrendModel == YHExtrendModelAudited) ? (@"生效时间") : (@"生成时间")) forState:UIControlStateNormal];
        }
        
        _stateB.enabled = (buttonIndex == 1);
    }
    
    if (_isState) {
        if (buttonIndex == 1) {
            [_dataSourceShow removeAllObjects];
            for (int i = 0; i < _dataSource.count; i++) {
                NSDictionary *item = _dataSource[i];
                if ([item[@"status"] isEqualToString:@"3"]) {
                    [_dataSourceShow addObject:item];
                }
            }
        }else if (buttonIndex == 2) {
            [_dataSourceShow removeAllObjects];
            for (int i = 0; i < _dataSource.count; i++) {
                NSDictionary *item = _dataSource[i];
                if ([item[@"status"] isEqualToString:@"0"]) {
                    [_dataSourceShow addObject:item];
                }
            }
        }else if (buttonIndex == 0){
            [_dataSourceShow removeAllObjects];
            [_dataSourceShow addObjectsFromArray:_dataSource];
        }
        
        _isState = NO;
        [_tableView reloadData];
        return;
    }
    
    
    _isTerm = NO;
    _isState = NO;
    _isStyle = NO;
    
//    [self searchAction:nil];
    [self updataList:NO];
}

- (IBAction)examineAction:(UIButton *)sender {
    _isState = YES;
    _isTerm = NO;
    _isStyle = NO;
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles: @"请选择状态", @"已提交审核", @"未提交审核",  nil];
    
    // Show the sheet
    //[sheet showInView:self.view];
//    return;
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"请选择状态", @"已提交审核", @"未提交审核"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 1) {
            [_dataSourceShow removeAllObjects];
            [sender setTitle:@"已提交审核" forState:UIControlStateNormal];
            for (int i = 0; i < _dataSource.count; i++) {
                NSDictionary *item = _dataSource[i];
                if ([item[@"status"] isEqualToString:@"3"]) {
                    [_dataSourceShow addObject:item];
                }
            }
        }else if (buttonIndex == 2) {
            [sender setTitle:@"未提交审核" forState:UIControlStateNormal];
            [_dataSourceShow removeAllObjects];
            for (int i = 0; i < _dataSource.count; i++) {
                NSDictionary *item = _dataSource[i];
                if ([item[@"status"] isEqualToString:@"0"]) {
                    [_dataSourceShow addObject:item];
                }
            }
        }else if (buttonIndex == 0){
            [sender setTitle:@"请选择状态" forState:UIControlStateNormal];
            [_dataSourceShow removeAllObjects];
            [_dataSourceShow addObjectsFromArray:_dataSource];
        }
        
        _isState = NO;
        [_tableView reloadData];

    }];

}

- (IBAction)classAction:(UIButton *)sender {
    _isState = NO;
    _isTerm = NO;
    _isStyle = YES;
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles: @"待支付", @"待审核", @"不通过", @"已审核", @"已取消",  nil];
    
    
    // Show the sheet
    //[sheet showInView:self.view];
    
    //    return;
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"待支付", @"待审核", @"不通过", @"已审核", @"已取消"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        NSArray *keys =@[@"-1", @"", @"2", @"1", @"9"];
        NSArray *keysStr =@[@"待支付", @"待审核", @"不通过", @"已审核", @"已取消"];
        if (keys.count > buttonIndex) {
            _style = keys[buttonIndex];
            _styleStr = keysStr[buttonIndex];
            _classB.titleLabel.text = _styleStr;
            [_classB setTitle:_styleStr forState:UIControlStateNormal];
            _extrendModel = buttonIndex;
            _dateB.titleLabel.text = ((_extrendModel == YHExtrendModelAudited) ? (@"生效时间") : (@"生成时间"));
            [_dateB setTitle:((_extrendModel == YHExtrendModelAudited) ? (@"生效时间") : (@"生成时间")) forState:UIControlStateNormal];
        }
        
        _stateB.enabled = (buttonIndex == 1);

        _isTerm = NO;
        _isState = NO;
        _isStyle = NO;
        
        //    [self searchAction:nil];
        [self updataList:NO];

    }];

}

- (IBAction)dateComfirmAction:(id)sender {
    _datePBox.hidden = YES;
    self.date = [YHTools stringFromDate:_dateP.date byFormatter:@"yyyy-MM-dd"];
    _dateStr = self.date;
    _dateB.titleLabel.text = _dateStr;
    [_dateB setTitle:_dateStr forState:UIControlStateNormal];
    [self updataList:NO];
}

- (IBAction)dateCancelAction:(id)sender {
    _datePBox.hidden = YES;
}
@end
