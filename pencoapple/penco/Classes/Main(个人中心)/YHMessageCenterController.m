//
//  YHMessageCenterController.m
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "UIViewController+RESideMenu.h"
#import "YHMessageCenterController.h"
#import "YHHistoryController.h"
#import "PCPostureDetailController.h"
#import "PCAlertViewController.h"

#import "PCHistoryContentView.h"

#import "YHNetworkManager.h"
#import "YHTools.h"

#import "PCTestRecordModel.h"
#import "PCMessageModel.h"

#import "MBProgressHUD+MJ.h"

#import <MJRefresh.h>

extern NSString *const notificationRecordListToHomeDetail;
@interface YHMessageCenterController ()
@property (nonatomic, strong) NSMutableArray <PCTestRecordModel *>*models;
@property (nonatomic, strong) NSMutableArray<PCMessageModel *> *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (nonatomic, assign) NSInteger page;
@end

@implementation YHMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    WeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.type == DataTypeHistory && self.personId) {
            [self getReports];
            return ;
        }
        [self getMessage];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.type == DataTypeHistory && weakSelf.personId) {
            weakSelf.page = 0;
            weakSelf.models = nil;
            [weakSelf getReports];
        }else{
            weakSelf.page = 0;
            weakSelf.messages = nil;
            [weakSelf getMessage];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView.mj_footer beginRefreshing];
    
}

- (void)setPersonId:(NSString *)personId{
    _personId = personId;
    self.page = 0;
    [self.tableView.mj_footer beginRefreshing];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.page = 0;
    ////    self.messages = @[].mutableCopy;
    ////    self.models = @[].mutableCopy;
    //    self.tableView.mj_footer.hidden = NO;
    //    [self.tableView.mj_footer beginRefreshing];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getMessage{
    NSString *accountId = YHTools.accountId;
    
    if (!accountId) {
//        
        return;
    }
    
    //@{@"accountId":@"",@"offset":@"",@"limit":@""}
    //NSDictionary *parm = @{@"accountId":[YHTools accountId],@"offset":@(self.page),@"limit":@"20"};
    NSDictionary *parm = @{@"accountId":[YHTools accountId],@"offset":@(self.page? self.messages.count-1:0),@"limit":@"20"};
    
    [[YHNetworkManager sharedYHNetworkManager] getMessages:parm onComplete:^(NSMutableArray<PCMessageModel *> * _Nonnull models) {
        
        if (!self.page) {
            self.messages = models;
        }else{
            [self.messages addObjectsFromArray:models];
        }
        [self.tableView reloadData];
        if (models.count>=20) {
            self.page++;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }else{
            //[self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_header endRefreshing];
//            self.tableView.mj_header.hidden = YES;
        }
        
    } onError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getReports{
    NSString *personId = self.personId;//YHTools.personId;
    NSString *accountId = YHTools.accountId;
    
    if (!personId || !accountId ) {
//        
        return;
    }
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *endTime = [fmt stringFromDate:[NSDate date]];
    
    //NSDictionary *parm = @{@"personId":[YHTools personId],@"accountId":[YHTools accountId],@"startTime":@"2000-07-01 15:46:00",@"endTime":endTime,@"offset":@(self.page),@"limit":@"20"};
    NSDictionary *parm = @{@"personId":personId,@"accountId":accountId,@"startTime":@"2000-07-01 15:46:00",@"endTime":endTime,@"offset":@(self.page? self.models.count-1:0),@"limit":@"20"};
    
    
    
    [[YHNetworkManager sharedYHNetworkManager] getReports:parm onComplete:^(NSMutableArray<PCTestRecordModel *> *models,BOOL hasMore) {
        
        
        if (!self.page) {
            self.models = models;
            
            if(!models.count){
                UIView *footerView = [[UIView alloc] init];
                footerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height-self.tableView.tableHeaderView.bounds.size.height);
                
                UIImageView *noMore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无体态记录"]];
                [footerView addSubview:noMore];
                noMore.center = CGPointMake(footerView.bounds.size.width * 0.5, footerView.bounds.size.height * 0.5 - 65);
                
                UILabel *noMoreLB = [[UILabel alloc] init];
                noMoreLB.text = @"您还没有体形记录，快去测量吧";
                noMoreLB.textColor = YHColor0X(0xABABAB, 1.0);
                noMoreLB.font = [UIFont systemFontOfSize:15.0];
                [noMoreLB sizeToFit];
                [footerView addSubview:noMoreLB];
                noMoreLB.center = CGPointMake(noMore.center.x, noMore.center.y+65);


                self.tableView.scrollEnabled = (BOOL)models.count;
                self.tableView.tableFooterView = footerView;
            }else{
                self.tableView.scrollEnabled = (BOOL)models.count;
                self.tableView.tableFooterView = nil;
            }
            
        }else{
            [self.models addObjectsFromArray:models];
        }
        [self.tableView reloadData];
        if (models.count >= 20) {
            self.page++;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }else{
            //[self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_header endRefreshing];
//            self.tableView.mj_header.hidden = YES;
        }
        
        
    } onError:^(NSError *error) {
        
    }];
}


- (void)getReports:(PCMessageModel *)model{
    
    
    if (!model.info.personId || !model.info.accountId || !model.info.reportId) {
//        
        return;
    }
    
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    //1.8.4.获取指定测量记录
    //@{@"personId":@"",@"reportId":@"",@"accountId":@""}
    NSDictionary *parm = @{@"personId":model.info.personId,@"reportId":model.info.reportId,@"accountId":model.info.accountId};
    
    [[YHNetworkManager sharedYHNetworkManager] getReportId:parm onComplete:^(PCTestRecordModel * _Nonnull model ,id info) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PCNotificationFirstFigureResult" object:nil userInfo:@{@"data":model,@"info":info}];
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        
    } onError:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];

        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == DataTypeHistory) {
        return self.models[indexPath.row].analysisCode? 0 : tableView.rowHeight;
    }
    
    return tableView.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.type == DataTypeMessage)? self.messages.count : self.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == DataTypeMessage ) {
        return;
        
        PCMessageModel *model = self.messages[indexPath.row];
        if (model.status == 2) {
            [[YHNetworkManager sharedYHNetworkManager] readMessages:@{@"accountId":YHTools.accountId,@"msgType":model.msgType,@"businessId":model.info.reportId} onComplete:^{
                model.status = 3;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } onError:^(NSError * _Nonnull error) {
            }];
        }
        
        if (model.info.analysisCode) {//失败
            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"本次测量失败，请重新测量" message:nil];
            [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            }];
            [self presentViewController:vc animated:NO completion:nil];
            
            return;
        }
        
        //if (model.info.postureId) {//posture_result  体态
        if([model.msgType isEqualToString:@"posture_result"]){
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
            PCPostureDetailController *controller = [board instantiateViewControllerWithIdentifier:@"PCPostureDetailController"];
            controller.model = self.messages[indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
            
            return;
        }
        
        //if (model.info.reportId) {//@"figure_result"。体型
        if([model.msgType isEqualToString:@"figure_result"]){
            
            NSMutableArray *models = [NSMutableArray array];
            [self.messages enumerateObjectsUsingBlock:^(PCMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.msgType isEqualToString:@"figure_result"] && !obj.info.analysisCode){
                    [models addObject:obj];
                }
            }];
            
            NSInteger index = [models indexOfObject:model];
            //            if(!index){
            //                [self getReports:model];
            //                return;
            //            }
            
            PCHistoryContentView *contentVC = [PCHistoryContentView new];
            contentVC.models = models;
            contentVC.index = index;
            [self.navigationController pushViewController:contentVC animated:YES];
            
            return;
        }
        
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:model.info.title message:model.info.message];
        [vc addActionWithTitle:@"确认" style:PCAlertActionStyleDefault handler:nil];
        [self presentViewController:vc animated:NO completion:nil];
        
        return;
    }
    
    PCTestRecordModel *model = self.models[indexPath.row];
    if (model.status && indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationRecordListToHomeDetail object:Nil userInfo:@{@"personId" : model.personId, @"isPosture" : @(NO)}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        PCHistoryContentView *contentVC = [PCHistoryContentView new];
        contentVC.models = self.models;
        contentVC.index = indexPath.row;
        [self.parentViewController.navigationController pushViewController:contentVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == DataTypeHistory) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        UILabel *textLabel = cell.contentView.subviews.firstObject;
        //        UIView *tag = cell.contentView.subviews.lastObject;
        
        PCTestRecordModel *model = self.models[indexPath.row];
        textLabel.text = [NSString stringWithFormat:@"%@ 体形测量", [YHTools stringFromDate:[YHTools dateFromString:model.reportTime byFormatter:@"yyyy-MM-dd HH:mm:ss"] byFormatter:@"yyyy.MM.dd HH:mm"]];
        
        UIView *tag = cell.contentView.subviews.lastObject;
        tag.hidden = model.status;
        return cell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        UILabel *textLabel = cell.contentView.subviews.firstObject;
        UILabel *timeLabel = cell.contentView.subviews[1];
        UILabel *descLabel = cell.contentView.subviews.lastObject;
        
        PCMessageModel *model = self.messages[indexPath.row];
        NSString *measureTime = (model.info.measureTime.length > 10)? ([model.info.measureTime substringToIndex:10]) : model.info.measureTime;
        NSString *personName = model.info.personName? model.info.personName : @"";
        
        //NSString *title = (!model.info.reportId && !model.info.postureId)? model.info.title : ([NSString stringWithFormat:@"%@ %@ 体态测量 %@",personName,measureTime,status]);
        NSString *title = ([model.msgType isEqualToString:@"message"])? (model.info.title? model.info.title:@"") : ([NSString stringWithFormat:@"%@ %@  %@", (([model.msgType isEqualToString:@"figure_result"])? (@"体形测量") : (@"体态测量")), personName, ((( model.info.analysisCode != 0 ))? @"失败" : @"成功")]);
        
        timeLabel.text = [YHTools stringFromDate:[YHTools dateFromString:model.info.measureTime byFormatter:@"yyyy-MM-dd HH:mm:ss"] byFormatter:@"yyyy.MM.dd HH:mm"];
        NSString *des = @"测量成功";
        if( model.info.analysisCode != 0 ) des = @"测量失败";
        descLabel.text = des;
        
        
        
        
        NSMutableAttributedString *varrt = [[NSMutableAttributedString alloc] initWithString:title];
        [varrt addAttribute:NSForegroundColorAttributeName value:YHColor0X(0XF36F6F, 1) range:[title rangeOfString:@"失败"]];
        [varrt addAttribute:NSForegroundColorAttributeName value:YHColor0X(0X99D473, 1) range:[title rangeOfString:@"成功"]];
        textLabel.attributedText = varrt;

        return cell;
        
        
    }
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return (self.type == DataTypeHistory)? YES : NO;
}


-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){

        UIContextualAction* deleteRowAction=[UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

            if(self.type != DataTypeHistory) {completionHandler(NO);return;}

            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否删除此数据" message:nil];

            [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
                completionHandler(NO);
            }];
            [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                [self deleteFigureRecordId:indexPath];
                completionHandler(YES);
            }];

            [self presentViewController:vc animated:NO completion:nil];


        }];
    
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
        config.performsFirstActionWithFullSwipe = NO;

        return config;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //是否删除此数据

    if(self.type != DataTypeHistory) return;

    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否删除此数据" message:nil];

    [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
    [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        [self deleteFigureRecordId:indexPath];
    }];

    [self presentViewController:vc animated:NO completion:nil];

}


- (void)deleteFigureRecordId:(NSIndexPath * )indexPath{
    //@{@"personId":@"",@"postureId":@"",@"accountId":@""}
    NSString *personId = self.personId;//YHTools.personId;
    NSString *accountId = YHTools.accountId;
    NSString *reportId = self.models[indexPath.row].reportId;
    
    if (!personId || !accountId || !reportId) {
//        
        return;
    }
    
    NSDictionary *parm = @{@"personId":personId,@"accountId":YHTools.accountId,@"reportId":reportId};
    
    [[YHNetworkManager sharedYHNetworkManager] deleteFigureRecordId:parm onComplete:^{
        
        [self.models removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } onError:^(NSError *error) {

    }];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)popViewController:(id)sender{
    [super popViewController:sender];
    if (self.type != DataTypeHistory) {
        [self presentLeftMenuViewController:sender];
    }
}
@end
