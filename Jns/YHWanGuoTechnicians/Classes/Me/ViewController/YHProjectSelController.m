//
//  YHProjectSelController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/10.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHProjectSelController.h"
#import "YHProjectCell.h"
#import "YHCommon.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "YHAddProjectController.h"
NSString *const notificationProjectAdd = @"YHNotificationProjectAdd";
extern NSString *const notificationOptionSel;
@interface YHProjectSelController () <UITextFieldDelegate>

@property (strong, nonatomic)NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIButton *comfireB;
@property (weak, nonatomic) IBOutlet UITextField *searchKeyFT;
- (IBAction)comfireAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchKeyTableview;
@property (weak, nonatomic) IBOutlet UIButton *rightB;
@property (nonatomic) NSInteger selIndex;
@end

@implementation YHProjectSelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationOptionSel:) name:notificationOptionSel object:nil];
    _selIndex = -1;
    self.title = @[@"新增细检项目",@"新增维修项目", @"新增配件耗材",@""][_model];
    _rightB.hidden = _isRepairPrice || ([self.orderInfo[@"nextStatusCode"] isEqualToString:@"cloudMakeDepth"]);
}

//- (void)viewWillAppear:(BOOL)animated{
//    if (_dataSource) {
////        [self reupdataDatasource];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)notificationOptionSel:(NSNotification*)notice{
    NSNumber *index = notice.userInfo[@"index"];
    NSMutableDictionary *item =  _dataSource[_selIndex];
    [item setObject:index forKey:@"sel"];
    [self comfireBReload];
    [_tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    YHAddProjectController *controller = segue.destinationViewController;
    controller.model = _model;
    controller.orderInfo = self.orderInfo;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _searchKeyTableview.hidden = NO;
    [_searchKeyTableview reloadData];
}

- (IBAction)searchAction:(id)sender {
    _searchKeyTableview.hidden = YES;
    [[self view] endEditing:YES];
    [self reupdataDatasource];
}


- (void)reupdataDatasource{
    
    __weak __typeof__(self) weakSelf = self;
    NSMutableArray *searchKeys = [[YHTools getSearchKeys] mutableCopy];
    if (!searchKeys) {
        searchKeys = [@[]mutableCopy];
    }
    __block BOOL isExit = NO;
    [searchKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([key isEqualToString:weakSelf.searchKeyFT.text]) {
            isExit = YES;
        }
    }];
    if (!isExit) {
        [searchKeys addObject:_searchKeyFT.text];
    }
    [YHTools setSearchKeys:searchKeys];
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    if (_model != YHAddProjectDepth) {
        if(_model == YHAddProjectRepairItem){
            
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             searchPartClass:[YHTools getAccessToken]
             page:@"1"
             billId:self.orderInfo[@"id"]
             partsClassName:_searchKeyFT.text
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     NSDictionary *data = info[@"data"];
                     NSArray *partsList = data[@"partsClass"];
                     if (!partsList) {
                         partsList = data[@"partsListData"];
                     }
                     NSMutableArray *temp = [@[]mutableCopy];
                     for (NSDictionary *item in partsList) {
                         [temp addObject:[item mutableCopy]];
                     }
                     
                     if (temp.count == 0) {
                         [MBProgressHUD showError:@"无此类数据"];
                     }
                     weakSelf.dataSource = temp;
                     [weakSelf.tableView reloadData];
                     
                 }else {
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLog(@"");
                         if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                             [weakSelf showErrorInfo:info];
                         }
                     }
                 }
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }else{
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             searchPartInfo:[YHTools getAccessToken]
             keys:@{
                    @"partsName" : _searchKeyFT.text}
             billId:self.orderInfo[@"id"]
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     NSDictionary *data = info[@"data"];
                     NSArray *partsList = data[@"partsClass"];
                     if (!partsList) {
                         partsList = data[@"partsNameList"];
                     }
                     NSMutableArray *temp = [@[]mutableCopy];
                     for (NSDictionary *item in partsList) {
                         [temp addObject:[item mutableCopy]];
                     }
                     
                     if (temp.count == 0) {
                         [MBProgressHUD showError:@"无此类数据"];
                     }
                     weakSelf.dataSource = temp;
                     [weakSelf.tableView reloadData];
                     
                 }else {
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLog(@"");
                         if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                             [weakSelf showErrorInfo:info];
                         }
                     }
                 }
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
        }
    }else{
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         getDepthItemToCloudForSysId:[YHTools getAccessToken]
         projectName:_searchKeyFT.text
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 NSDictionary *data = info[@"data"];
                 NSArray *depthCheckProject = data[@"depthCheckProject"];
                 NSMutableArray *temp = [@[]mutableCopy];
                 for (NSDictionary *item in depthCheckProject) {
                     [temp addObject:[item mutableCopy]];
                 }
                 if (temp.count == 0) {
                     [MBProgressHUD showError:@"无此类数据"];
                 }
                 weakSelf.dataSource = temp;
                 [weakSelf.tableView reloadData];
             }else if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                 [MBProgressHUD showError:@"没有对应细检项目"];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLog(@"");
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];
         }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchKeyTableview == tableView) {
        return [YHTools getSearchKeys].count;
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_searchKeyTableview == tableView) {
        [cell loadSearchKey:[YHTools getSearchKeys][indexPath.row]];
        return cell;
    }
    [cell loadData:_dataSource[indexPath.row] isRepair:NO];
    cell.repairActionData = _repairActionData;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    [[NSNotificationCenter
    //      defaultCenter]postNotificationName:notificationProjectSel
    //     object:Nil
    //     userInfo:nil];
    //    [self popViewController:nil];
    _selIndex = indexPath.row;
    if (_searchKeyTableview == tableView) {
        _searchKeyFT.text = [YHTools getSearchKeys][indexPath.row];
        [self searchAction:nil];
        return;
    }
//    if (_model == YHAddProjectRepairItem) {
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        YHAddProjectController *controller = [board instantiateViewControllerWithIdentifier:@"YHAddProjectController"];
////        controller.isRepair = _isRepair;
////        controller.isRepairOption = YES;
////        controller.isRepairModel = _isRepairModel;
//        
//        controller.model = YHAddProjectActionSel;
//        controller.repairActionData = self.repairActionData;
//        [self.navigationController pushViewController:controller animated:YES];
//    }else{
        NSMutableDictionary *item = _dataSource[indexPath.row];
        NSNumber *sel = item[@"sel"];
        [item setObject:[NSNumber numberWithBool:!sel.boolValue] forKey:@"sel"];
        [self comfireBReload];
        [_tableView reloadData];
//    }
}

- (NSArray*)isSel{
    NSMutableArray *temp = [@[]mutableCopy];
    if (_model == YHAddProjectPart || _model == YHAddProjectDepth || _model == YHAddProjectRepairItem) {
        for (NSDictionary *item in _dataSource) {
            NSNumber *sel = item[@"sel"];
            if (sel.boolValue) {
                [temp addObject:item];
            }
        }
    }else{
        for (NSDictionary *item in _dataSource) {
            NSNumber *sel = item[@"sel"];
            if (sel) {
                [temp addObject:item];
            }
        }
    }
    return temp;
}
- (void)comfireBReload{
    _comfireB.backgroundColor = (([self isSel].count)? (YHNaviColor) : (YHLineColor));
}

- (IBAction)comfireAction:(id)sender {
    NSArray *items = [self isSel];
    if (items.count == 0) {
        return;
    }
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationProjectAdd
     object:Nil
     userInfo:@{@"value" : items}];
    [self popViewController:nil];
    
}
@end
