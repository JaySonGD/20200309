//
//  PCAccountController.m
//  penco
//
//  Created by Jay on 22/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "UIViewController+RESideMenu.h"
#import "PCAccountController.h"
#import "YHPersonInfoController.h"
#import "PCAlertViewController.h"

#import "YHNetworkManager.h"
#import "YHTools.h"

#import "PCAccountCell.h"
#import "PCPersonModel.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

extern NSString *const notificationConfirmReport;

@interface PCAccountController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<PCPersonModel *> *models;
@end

@implementation PCAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = 90;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加成员"] style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPersionList];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.models) [self.tableView.mj_header beginRefreshing];
    else [self getPersionList];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getPersionList{
    NSString *accountId = YHTools.accountId;
    
    if (!accountId) {
        
        return;
    }

    [[YHNetworkManager sharedYHNetworkManager] getPersonsOnComplete:^(NSMutableArray<PCPersonModel *> *models) {
        self.models = models;
        [self.tableView reloadData];
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
//        self.tableView.mj_footer.hidden = YES;

    } onError:^(NSError *error) {

        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)add{
    YHPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
    vc.action = PersonInfoActionAdd;
    vc.sourceVC = self.sourceVC;
    vc.observer = self.observer;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PCPersonModel *model = self.models[indexPath.row];
    cell.personName.text = model.personName;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"默认头像"]];

    //cell.headImg.image = [YHTools imageFromBase64:model.headImg];
    cell.personType.hidden = ![model.personType isEqualToString:@"master"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sourceVC) {
        
        PCPersonModel *model = self.models[indexPath.row];
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定测量用户为'%@'",self.models[indexPath.row].personName] message:nil];
        
        [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
        [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [YHTools setPersonId:model.personId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationConfirmReport object:self.observer userInfo:@{@"personId" : model.personId}];
            [self.navigationController popToViewController:self.sourceVC animated:NO];
        }];
        [self presentViewController:vc animated:NO completion:nil];

        return;
    }
    
    YHPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPersonInfoController"];
    vc.action = (indexPath.row == 0)? PersonInfoActionMasterDetail : PersonInfoActionDelete;
    vc.model = self.models[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



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
    if (self.isLeft) {
        [self presentLeftMenuViewController:sender];
    }
}
@end
