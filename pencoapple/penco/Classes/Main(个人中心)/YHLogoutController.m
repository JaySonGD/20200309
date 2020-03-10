//
//  YHLogoutController.m
//  penco
//
//  Created by Jay on 20/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHLogoutController.h"
#import "LenovoIDInlandSDK.h"
#import "YHTools.h"
extern NSString *const notificationReloadLoginInfo;
@interface YHLogoutController ()

@end

@implementation YHLogoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logoutAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[LenovoIDInlandSDK shareInstance] leInlandLogout];//退出登入
    [YHTools setAccessToken:nil];
    [YHTools setAccountId:nil];
    [YHTools setRefreshToken:nil];
    [YHTools setRulerToken:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationReloadLoginInfo object:nil userInfo:nil];
}

@end
