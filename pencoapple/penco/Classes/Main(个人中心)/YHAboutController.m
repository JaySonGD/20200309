//
//  YHAboutController.m
//  penco
//
//  Created by Jay on 21/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "UIViewController+RESideMenu.h"
#import "YHAboutController.h"
#import "PCAlertViewController.h"
#import "YHCallCenterController.h"
#import "MBProgressHUD+MJ.h"
#import "PCTextController.h"

#import "YHTools.h"

@interface YHAboutController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCode;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (nonatomic, strong) NSArray <NSArray *>*data;
@end

@implementation YHAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.versionLB.text = [NSString stringWithFormat:@"当前版本：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSString *newVersion = @"软件版本";
    self.data = @[
        @[newVersion,
          @"许可协议和服务条款",
          @"软件隐私声明"],
        //                  @[@"版权声明"]
    ];
    
    self.qrCode.image = [YHTools createQRCode];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.data[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSDictionary *obj = [YHTools sharedYHTools].appInfo;;
        NSString *AppStoreVersion = obj[@"version"];
        BOOL update = [YHTools canUpDate:AppStoreVersion];
        UILabel *l = cell.contentView.subviews.firstObject;
        l.text = update ? @"升级" : @"最新";
    }
    cell.contentView.subviews.firstObject.hidden = !(indexPath.section == 0 && indexPath.row == 0);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            NSDictionary *obj = [YHTools sharedYHTools].appInfo;;
            NSString *AppStoreVersion = obj[@"version"];
            //            NSString *otaUrl = obj[@"otaUrl"];
#ifdef YHTest
            NSString *otaUrl = @"https://pvtruler.lenovo.com.cn/download/";
#else
            NSString *otaUrl = @"https://chnupdate.lenovo.com.cn/ruler/index.html";
#endif
            if(!otaUrl || !AppStoreVersion) return;
            
            BOOL update = [YHTools canUpDate:AppStoreVersion];
            if (!update) {
                [MBProgressHUD showError:@"已经是最新版本"];
                return;
            }
            
            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否升级" message:nil];
            [vc addActionWithTitle:@"取消" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
                
            }];
            [vc addActionWithTitle:@"升级" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:otaUrl];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [self presentViewController:vc animated:NO completion:nil];
            
            
            return;
        }
        
        if (indexPath.row == 1) {
            PCTextController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCTextController2"];
            //            vc.title = @"联想3D塑形尺软件许可及服务协议";
            //            vc.textTV.text = @"联想3D塑形尺软件许可及服务协议";
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
        
        if (indexPath.row == 2) {
            //            PCTextController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCTextController"];
            //            vc.title = @"联想3D塑形尺隐私保护指引";
            //            vc.textTV.text = @"联想3D塑形尺隐私保护指引";
            YHCallCenterController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCallCenterController"];
            vc.url = @"https://privacy.lenovo.com.cn/products/8d2e264212f11ed0.html";
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
        
        
        return;
    }
    
    //    if (indexPath.section == 1) {
    //
    //        if (indexPath.row == 0) {
    //            PCTextController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCTextController"];
    //            vc.title = @"版权声明";
    //            vc.textTV.text = @"版权声明";
    //            [self.navigationController pushViewController:vc animated:YES];
    //
    //            return;
    //        }
    //
    //        return;
    //    }
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
    [self presentLeftMenuViewController:sender];
}
@end
