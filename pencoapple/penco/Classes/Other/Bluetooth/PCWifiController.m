//
//  PCWifiController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/25.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "PCWifiController.h"
#import "UIViewController+RESideMenu.h"
#import "PCBluetoothManager.h"
#import "YHCommon.h"
#import "PCWifiPCell.h"
#import "MBProgressHUD+MJ.h"
#import "PCSurveyController.h"
#import "YHTools.h"
#import "PCBlutoothController.h"
#import "PCAlertViewController.h"
#import "PCWifiCell.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCWifiController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    
}
@property (nonatomic, strong)NSMutableArray *wifis;
@property (weak, nonatomic) IBOutlet UIButton *showWifiB;
- (IBAction)showWifiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UITextField *wifFT;
@property (weak, nonatomic) PCWifiPCell *PCWifiPCell;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic)NSString *password;
@property (strong, nonatomic)NSString *wifiName;
@property (weak, nonatomic)MBProgressHUD *hud;
@end

@implementation PCWifiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.password = @"232323";
    self.showWifiB.selected = NO;
//    self.wifis = @[@{@"ssid" : @"2323"}];
//    [self.tableV reloadData];
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请选择要连接的WiFi" attributes:
    
    @{NSForegroundColorAttributeName:[UIColor blackColor],
      
      NSFontAttributeName:self.wifFT.font}];
    
    self.wifFT.attributedPlaceholder = attrString;
    
    self.wifFT.text = [PCWifiController fetchSSIDInfo];
    self.wifiName = self.wifFT.text;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    WeakSelf
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject)
     {
         YHLog(@"%@", responseObject)
         NSNumber *code = [responseObject objectForKey:@"action"];
         switch (code.integerValue) {
                 
             case 200001://
             {
//                 return ;
                 weakSelf.wifis = [[responseObject objectForKey:@"wifi"] mutableCopy];
                weakSelf.showWifiB.selected = !(weakSelf.wifis.count == 0 || weakSelf.wifis == nil);
                 
               weakSelf.title = (weakSelf.showWifiB.selected)? (@"选择WiFi") : (@"配置WiFi网络");
                 [weakSelf.hud setCompletionBlock:nil];
                 [MBProgressHUD hideHUDForView:self.view];
                 [weakSelf.tableV reloadData];
             }
                 break;
             case 200002://
             {
                 NSString *result = [responseObject objectForKey:@"result"];
                 [self.hud setCompletionBlock:nil];
                 [MBProgressHUD hideHUDForView:self.view];
                 if ([result isEqualToString:@"ok"]) {
                     [MBProgressHUD showError:@"配置wifi成功" toView:self.navigationController.view];
                      if (weakSelf.func == PCFuncWifi) {
                          [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                      }else{
                          UIStoryboard *board = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
                          PCSurveyController *controller = [board instantiateViewControllerWithIdentifier:@"PCSurveyController"];
                          controller.isPosture = (self.func == PCFuncPosture);
                          [self.navigationController pushViewController:controller animated:YES];
                      }
                 }else{
                     [MBProgressHUD showError:([result isEqualToString:@"failPsw"]?  @"密码错误,请重新输入" : @"配网失败") toView:self.navigationController.view];
                 }
             }
                 break;
            
             case 990000:
             {
                 YHLog(@"蓝牙自动连接成功！");
             }
                 break;
             case 990001 :
             {
                 YHLog(@"蓝牙已断开！");
                 [MBProgressHUD hideHUDForView:self.view];
                 PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"蓝牙中断" message:nil];
                 
                 [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                     [weakSelf popViewController:nil];
                 }];
                 [self presentViewController:vc animated:NO completion:nil];
                 
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil];
//                 PCBlutoothController *controller = [board instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
//                 controller.func = self.func;
//                 [self.navigationController pushViewController:controller animated:YES];
             }
                 break;
             case 990004://保存蓝牙数据失效
             {
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Bluetooth" bundle:nil];
//                 PCBlutoothController *controller = [board instantiateViewControllerWithIdentifier:@"PCBlutoothController"];
//                 
//                 controller.func =self.func;
//                 [self.navigationController pushViewController:controller animated:YES];
                 
             }
                 break;
                 
             default:
                 break;
         }
     }];
    
    //延时自动连接蓝牙
    if (IsEmptyStr([PCWifiController fetchSSIDInfo])) {
        [self getWifiList:nil];
    }
    //    [self performSelector:@selector(getWifiList:) withObject:nil afterDelay:1];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)getWifiList:(id)sender{
    self.hud = [MBProgressHUD showMessage:@"正在获取设备wifi" toView:self.view];
    WeakSelf
    [self.hud setCompletionBlock:^{
        PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"获取WiFi列表失败，重新获取。" message:nil];
        
        [vc addActionWithTitle:@"取消" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
            [weakSelf popViewController:nil];
        }];
        [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
            [weakSelf getWifiList:nil];
//            [weakSelf popViewController:nil];
        }];
        [weakSelf presentViewController:vc animated:NO completion:nil];
//        [MBProgressHUD showError:@"获取WiFi列表失败" toView:self.navigationController.view];
//        [weakSelf.hud setCompletionBlock:nil];
//        [weakSelf popViewController:nil];
    }];
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
       @"action": @"100001"
       }
     
     ];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.wifFT) {
        self.wifiName = self.wifFT.text;
    }else{
        self.password = textField.text;
    }
}
#pragma mark -table委托 table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.btn.hidden = (self.showWifiB.selected);
    return (self.showWifiB.selected)? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return ((self.showWifiB.selected) ? (self.wifis.count) : (0));
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PCWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSDictionary *wifi = self.wifis[indexPath.row];
        cell.ssidL.text = [wifi objectForKey:@"ssid"];
        [cell ssid:[wifi objectForKey:@"rssi"]];
        return cell;
    }else{
        PCWifiPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellP"];
        [cell loadData:self.password];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = self.wifis[indexPath.row];
    if (([@"" isEqualToString:[item objectForKey:@"ssid"]] || ![item objectForKey:@"ssid"]) && indexPath.section == 0) {
        return 0;
    }
    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *wifi = self.wifis[indexPath.row];
        self.wifiName = [wifi objectForKey:@"ssid"];
        self.wifFT.text = [wifi objectForKey:@"ssid"];
        self.showWifiB.selected = NO;
        self.title = (self.showWifiB.selected)? (@"选择WiFi") : (@"配置WiFi网络");
        [self.tableV reloadData];
    }else{
    }
}
- (IBAction)showWifiAction:(UIButton*)button {
//    self.title = (self.showWifiB.selected)? (@"选择WiFi") : (@"配置WiFi网络");
    if (button.selected == NO) {
        [self getWifiList:nil];
    }else{
        button.selected = !button.selected;
        [self.tableV reloadData];
    }
}

- (IBAction)connectWifiAction:(id)sender {
    if (self.wifiName == nil|| [self.wifiName isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择wifi"];
        return;
    }
    
//    if (self.password == nil|| [self.password isEqualToString:@""]) {
//        [MBProgressHUD showError:@"请输入密码"];
//        return;
//    }
    
    self.hud = [MBProgressHUD showMessage:@"配网中..." toView:self.view];
    WeakSelf
    [self.hud setCompletionBlock:^{
        [MBProgressHUD showError:@"密码错误，请重新输入" toView:self.view];
    }];
    [[PCBluetoothManager sharedPCBluetoothManager] sendTo:
     @{
       @"action": @"100002",
       @"ssid":self.wifiName,
       @"pwd":(self.password? self.password : @""),
//       @"longitude":@(12.966163),
//       @"latitude":@(18.565641)
       @"province": (([YHTools province])? ([YHTools province]) : (@"")),
       @"city": (([YHTools cityName])? ([YHTools cityName]) : (@"")),
       @"county": (([YHTools area])? ([YHTools area]) : (@""))
       }
     ];
}

- (IBAction)popViewController:(id)sender{

    [[PCBluetoothManager sharedPCBluetoothManager] stop];
    [[PCBluetoothManager sharedPCBluetoothManager] setBlockBluetoothDataFrame:^(NSDictionary * _Nonnull responseObject) {
        ;
    }];
    if (self.func == PCFuncWifi) {
        [self presentLeftMenuViewController:sender];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}


+(NSString*)fetchSSIDInfo {
    
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    
    NSDictionary *info;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            
            return [info objectForKey:@"SSID"];
            break;
        }
    }
    
    return @"";
}
@end
