//
//  PCFigureContrastController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/10/11.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCFigureContrastController.h"
#import "YHTools.h"
#import "PCPersonModel.h"
#import "MBProgressHUD+MJ.h"
#import "YHCommon.h"
#import "YHNetworkManager.h"
#import "YHModelItem.h"
#import "PCTestRecordModel.h"
#import "ContrastCell.h"
@interface PCFigureContrastController ()
@property (nonatomic, strong) NSMutableArray <YHCellItem *>*reportModels;
@property (nonatomic, strong) PCTestRecordModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PCFigureContrastController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getLastReport];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)getLastReport{
    NSString *personId = [YHTools sharedYHTools].masterPersion.personId;
    NSString *accountId = YHTools.accountId;
    
    if (!personId || !accountId ) {
        
        return;
    }
    WeakSelf
    [MBProgressHUD showMessage:nil toView:self.view];
    NSDictionary *parm = @{@"personId":personId,@"accountId":accountId};
    [[YHNetworkManager sharedYHNetworkManager] lastReport:parm onComplete:^(PCTestRecordModel *model, NSDictionary *info) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.model = model;
        weakSelf.reportModels = [model contrastWithHeight:model.height.integerValue];
//        reportTime
        weakSelf.timeL.text = [model.reportTime substringWithRange:NSMakeRange(0, 16)];
        [weakSelf.tableView reloadData];
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.reportModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.item = self.reportModels[indexPath.row];
    return cell;
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

@end
