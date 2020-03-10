//
//  YHMainViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/10/11.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHMainViewController.h"
#import "YHTools.h"
#import "YHHomeViewController.h"
#import "YHNetworkManager.h"
#import "YHLeftController.h"
#import "AppDelegate.h"
#import "LenovoIDInlandSDK.h"
#import "YHCommonTool.h"



static const DDLogLevel ddLogLevel = DDLogLevelInfo;
extern NSString *const notificationUpdataUserinfo;
@interface YHMainViewController () <YHLeftMenuActionDelegate>

@end

@implementation YHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    // 设置内容控制器
    self.contentViewStoryboardID = @"contentViewController";
    self.panGestureEnabled = NO;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.leftMenuViewController = [board instantiateViewControllerWithIdentifier:@"YHLeftController"];
    ((YHLeftController*)self.leftMenuViewController).delegate = self;
    self.delegate = self;
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Menu Delegate
- (void)leftMenuActions:(YHLeftMenuActions)actionKey withInfo:(NSDictionary *)info{
    UIViewController * controller;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(actionKey == YHLeftMenuActionsAuditIng
       || actionKey == YHLeftMenuActionsAuditFail
       || actionKey == YHLeftMenuActionsRegistrationSuccessful){
        controller = [board instantiateViewControllerWithIdentifier:@"YHExamineStateController"];
//        ((YHExamineStateController*)controller).status = actionKey;
//        ((YHExamineStateController*)controller).info = info;
    }
    
    UINavigationController *naviController = (UINavigationController*)self.contentViewController;
    [naviController pushViewController:controller animated:YES];
    [self hideMenuViewController];
}



#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    YHLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    YHLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    YHLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    YHLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
@end
