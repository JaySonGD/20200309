//
//  YHMainViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/10/11.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHMainViewController.h"
#import "YHTools.h"
//#import "YHHomeViewController.h"
#import "YHNetworkManager.h"
#import "YHLeftController.h"
#import "YHLoginViewController.h"
#import "YHExamineStateController.h"
#import "AppDelegate.h"
#import "YHCommonTool.h"



extern NSString *const notificationUpdataUserinfo;
extern NSString *const notificationReloadLoginInfo;
@interface YHMainViewController () <YHLeftMenuActionDelegate>

@end

@implementation YHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloginAction:) name:notificationReloadLoginInfo object:nil];
    [self autoLogin:nil];
}


- (void)reloginAction:(NSNotification*)notice{
    [YHTools setAccessToken:nil];
    [self autoLogin:nil];
}

- (void)autoLogin:(NSString*)code{
//    [YHTools setAccessToken:@"23432"];
    if ([YHTools getAccessToken]) {
        NSLog(@"===token===%@",[YHTools getAccessToken]);
    }else{
        
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        if (appDelegate.isLogining) {
//            return;
//        }
//        appDelegate.isLogining = YES;
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YHLoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
        [(UINavigationController*)self.contentViewController pushViewController:controller animated:YES];
        
        // 检测网络状态并默认弹框
        [YHCommonTool ShareCommonToolDefaultCurrentController:self];
        
    }
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
        ((YHExamineStateController*)controller).status = actionKey;
        ((YHExamineStateController*)controller).info = info;
    }
    
    UINavigationController *naviController = (UINavigationController*)self.contentViewController;
    [naviController pushViewController:controller animated:YES];
    [self hideMenuViewController];
}



#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
@end
