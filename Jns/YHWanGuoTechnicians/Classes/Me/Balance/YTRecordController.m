//
//  YTRecordController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTRecordController.h"
#import "YTRecordCell.h"

#import "UIView+add.h"

#import "YTRecordDetailController.h"

#import "YHCarPhotoService.h"

#import "YTPointsDealModel.h"

#import "YHStoreTool.h"


@interface YTRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**  */
@property (nonatomic, strong) NSMutableArray <YTPointsDealListModel *>*models;
@end

@implementation YTRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [[YHCarPhotoService new] getPointsDealListOrgCode:[[YHStoreTool ShareStoreTool] org_id] success:^(NSMutableArray<YTPointsDealListModel *> *obj) {
        self.models = obj;
        if (obj.count > 0) {
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:@"暂无明细"];
        }
       
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setRounded:cell.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
        });
    }
    
    if ( indexPath.row == ([tableView numberOfRowsInSection:0] - 1) ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setRounded:cell.bounds corners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:12];
        });

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.models[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTRecordDetailController *VC = [[UIStoryboard storyboardWithName:@"Balance" bundle:nil] instantiateViewControllerWithIdentifier:@"YTRecordDetailController"];
    VC.Id =  self.models[indexPath.row].id;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
