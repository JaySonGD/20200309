//
//  PCPostureController.m
//  penco
//
//  Created by Jay on 11/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <MJRefresh.h>
#import "UIViewController+RESideMenu.h"
#import "PCPostureController.h"

#import "YHNetworkManager.h"
#import "YHTools.h"
#import "PCAlertViewController.h"
#import "PCPersonModel.h"
#import "PCMessageModel.h"
#import "PCPostureModel.h"
#import "PCPostureDetailController.h"
#import "MBProgressHUD+MJ.h"
#import "PCSurveyController.h"
#import "PCBluetoothManager.h"
#import "PCBlutoothController.h"
#import "YHPersonInfoController.h"
extern NSString *const notificationRecordListToHomeDetail;
@interface PCPostureController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<PCPostureModel *> *models;
@end

@implementation PCPostureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView = [UIView new];
//    [self getPosturesList];
     WeakSelf
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getPosturesList];
    }];
}

- (void)setPersonId:(NSString *)personId{
    _personId = personId;
    [self getPosturesList];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)preparePosture:(id)sender {
    if (!self.models) {
        return;
    }
    
    if ([[PCBluetoothManager sharedPCBluetoothManager] isConnected]) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
        PCSurveyController *controller = [board instantiateViewControllerWithIdentifier:@"PCSurveyController"];
        controller.isPosture = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil];
        PCBlutoothController *controller = [board instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
        
        controller.func = PCFuncPosture;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)add{
    YHPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
    vc.action = PersonInfoActionAdd;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setModels:(NSMutableArray<PCPostureModel *> *)models{
    _models = models;
    
    if (!models.count) {
        UIView *footerView = [[UIView alloc] init];
        //footerView.backgroundColor = [UIColor redColor];
        footerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height-self.tableView.tableHeaderView.bounds.size.height);
        
        UIImageView *noMore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无体态记录"]];
        [footerView addSubview:noMore];
        noMore.center = CGPointMake(footerView.bounds.size.width * 0.5, footerView.bounds.size.height * 0.5 - 65);
        
        UILabel *noMoreLB = [[UILabel alloc] init];
        noMoreLB.text = @"您还没有体态记录，快去测量吧";
        noMoreLB.textColor = YHColor0X(0xABABAB, 1.0);
        noMoreLB.font = [UIFont systemFontOfSize:15.0];
        [noMoreLB sizeToFit];
        [footerView addSubview:noMoreLB];
        noMoreLB.center = CGPointMake(noMore.center.x, noMore.center.y+65);


        self.tableView.scrollEnabled = (BOOL)models.count;
        self.tableView.tableFooterView = footerView;
    }else{
        self.tableView.tableFooterView = [UIView new];
        self.tableView.scrollEnabled = (BOOL)models.count;
        WeakSelf
//          self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                [weakSelf getPosturesList];
//            }];
    }
}

- (void)getPosturesList{
    //@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
    NSString *personId = self.personId;//YHTools.personId;
    NSString *accountId = YHTools.accountId;
    
    if (!personId || !accountId ) {
        
        return;
    }
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *endTime = [fmt stringFromDate:[NSDate date]];

    NSDictionary *parm = @{@"personId":personId,@"accountId":accountId,@"startTime":@"2010-01-01 00:00:00",@"endTime":endTime};
    
    [[YHNetworkManager sharedYHNetworkManager] posturesList:parm onComplete:^(NSMutableArray<PCPostureModel *> *models) {
        
        [MBProgressHUD hideHUDForView:self.view];
        self.models = models;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } onError:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];


    }];
}

- (void)deletePosture:(NSIndexPath * )indexPath{
    //@{@"personId":@"",@"postureId":@"",@"accountId":@""}
    NSString *personId = self.personId;//YHTools.personId;
    NSString *accountId = YHTools.accountId;
    NSString *postureId = self.models[indexPath.row].postureId;

    if (!personId || !accountId || !postureId) {
        
        return;
    }

    NSDictionary *parm = @{@"personId":personId,@"accountId":accountId,@"postureId":postureId};

    [[YHNetworkManager sharedYHNetworkManager] deletePostures:parm onComplete:^{
        
        [self.models removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } onError:^(NSError *error) {

    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.models[indexPath.row].analysisCode? 0 : tableView.rowHeight;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCPostureModel *model = self.models[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //cell.textLabel.text = model.measureTime;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 体态测量", [YHTools stringFromDate:[YHTools dateFromString:model.measureTime byFormatter:@"yyyy-MM-dd HH:mm:ss"] byFormatter:@"yyyy.MM.dd HH:mm"]];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //是否删除此数据
    
    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否删除此数据" message:nil];
    
    [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
    [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        [self deletePosture:indexPath];
    }];
    
    [self presentViewController:vc animated:NO completion:nil];

}

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    
    UIContextualAction* deleteRowAction=[UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否删除此数据" message:nil];
        
        [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
        [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [self deletePosture:indexPath];
        }];
        
        [self presentViewController:vc animated:NO completion:nil];

        
    }];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      if (indexPath.row == 0) {
          [[NSNotificationCenter defaultCenter]postNotificationName:notificationRecordListToHomeDetail object:Nil userInfo:@{@"personId" : self.personId, @"isPosture" : @(YES)}];
          [self.navigationController popToRootViewControllerAnimated:YES];
      }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
        PCPostureDetailController *controller = [board instantiateViewControllerWithIdentifier:@"PCPostureDetailController"];
        PCMessageModel *model = [PCMessageModel new];
        PCMessageBodyModel *info = [PCMessageBodyModel new];
        info.reportId = self.models[indexPath.row].postureId;
        info.accountId = YHTools.accountId;
        info.personId = self.personId;//YHTools.personId;
        model.info = info;
        controller.model = model;
        //controller.postureId = self.models[indexPath.row].postureId;

        [self.parentViewController.navigationController pushViewController:controller animated:YES];
      }
}

- (void)popViewController:(id)sender{
    [super popViewController:sender];
    [self presentLeftMenuViewController:sender];
}
@end
