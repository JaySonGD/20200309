//
//  YHBrandSeriesController.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/22.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBrandSeriesController.h"
#import "YHNetworkPHPManager.h"

#import "YHBrandSeriesCell.h"
#import "YHInquiriesController.h"
NSString *const notificationBrand = @"YHNotificationBrand";
@interface YHBrandSeriesController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic)NSArray *dataSource;
@end

@implementation YHBrandSeriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _brandInfo[@"brandName"];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getCarLineList:_brandInfo[@"id"] onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view];
        if (((NSNumber*)info[@"code"]).integerValue == 20000) {
            weakSelf.dataSource = info[@"data"];
            [weakSelf.tableView reloadData];
        }else{
            if(![weakSelf networkServiceCenter:info[@"code"]]){
                YHLog(@"getCarBrandList Error");
            }
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHBrandSeriesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_dataSource[indexPath.row] isSel:(indexPath.row == 0)];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = _dataSource[indexPath.row];
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationBrand
     object:Nil
     userInfo:@{
                @"carBrandName" : _brandInfo[@"brandName"],
                @"carBrandLogo" : _brandInfo[@"icoName"],
                @"carBrandId" : _brandInfo[@"id"],
                @"carLineId" : item[@"id"],
                @"carLineName" : item[@"lineName"]
                }];
    
    __weak __typeof__(self) weakSelf = self;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHInquiriesController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}
@end
