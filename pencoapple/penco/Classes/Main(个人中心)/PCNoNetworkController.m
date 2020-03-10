//
//  PCNoNetworkController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/11/9.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCNoNetworkController.h"

#import "MBProgressHUD+MJ.h"
#import "CheckNetwork.h"
NSString *const notificationNoNetwork = @"notificationNoNetwork";
extern NSString *const notificationRefreshToken;
@interface PCNoNetworkController ()

@end

@implementation PCNoNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)againAction:(id)sender {
    
    [MBProgressHUD showMessage:nil toView:self.view];
    if([[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationRefreshToken object:Nil userInfo:nil];
    }else{
        [MBProgressHUD hideHUDForView:self.view];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
