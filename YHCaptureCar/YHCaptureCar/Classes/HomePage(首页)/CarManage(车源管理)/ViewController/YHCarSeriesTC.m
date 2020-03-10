//
//  YHCarSeriesTC.m


//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarSeriesTC.h"
#import "YHNetworkPHPManager.h"
#import "MBProgressHUD+MJ.h"
#import "YHBrandSeriesModel.h"
#import <MJExtension.h>
#import "YHDiagnosisBaseVC.h"
#import "YHHelpCkeckInputController.h"

static NSString *cellID = @"brandSeriesID";
@interface YHCarSeriesTC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *brandSeriesArr;//品牌数组

@end

@implementation YHCarSeriesTC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"车型选择";
    [self loadData];  //请求网络数据
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    //cell线左边显示
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableFooterView =  [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)loadData{
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]queryCarSeriesTableWithBrandId:self.brandId onComplete:^(NSDictionary *info) {
        
        if ([info[@"code"]longLongValue] == 20000) {//进行字典转模型
            for (NSDictionary *dict in info[@"data"]) {
                YHBrandSeriesModel *model = [YHBrandSeriesModel mj_objectWithKeyValues:dict];
                [self.brandSeriesArr addObject:model];
            }
            
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    
    } onError:^(NSError *error) {
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.brandSeriesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    YHBrandSeriesModel *model = self.brandSeriesArr[indexPath.row];
    cell.textLabel.text = model.lineName;
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

/**
选择那一行
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHBrandSeriesModel *model = self.brandSeriesArr[indexPath.row];
    
    //方法1
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:NSClassFromString(@"YHDiagnosisBaseTC")]) {
            //            YHDiagnosisBaseVC *vc = (YHDiagnosisBaseVC*)controller;
            //model.lineName   发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"brandName" object:nil userInfo:@{@"brandName":self.brandName, @"brandId" : self.brandId, @"lineName" : model.lineName, @"lineId" : model.lineId}];
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[YHDiagnosisBaseVC class]]) {
//            YHDiagnosisBaseVC *vc = (YHDiagnosisBaseVC*)controller;
            //model.lineName   发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"brandName" object:nil userInfo:@{@"brandName":self.brandName, @"brandId" : self.brandId, @"lineName" : model.lineName, @"lineId" : model.lineId}];
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[YHHelpCkeckInputController class]]) {
            YHHelpCkeckInputController *vc = (YHHelpCkeckInputController*)controller;
            //model.lineName   发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"brandName" object:nil userInfo:@{@"brandName":self.brandName, @"brandId" : self.brandId, @"lineName" : model.lineName, @"lineId" : model.lineId}];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }

    }
}



- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


/**
车系数组
 */
-(NSMutableArray *)brandSeriesArr{
    if (_brandSeriesArr == nil) {
        _brandSeriesArr = [NSMutableArray array];
    }
    return _brandSeriesArr;
}
@end
