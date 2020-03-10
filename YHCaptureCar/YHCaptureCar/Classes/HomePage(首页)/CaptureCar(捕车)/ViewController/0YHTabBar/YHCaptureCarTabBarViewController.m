//
//  YHCaptureCarTabBarViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/6.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCaptureCarTabBarViewController.h"

@interface YHCaptureCarTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation YHCaptureCarTabBarViewController

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
////    [self.tableView reloadData];
////    [self autoLogin:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"竞价现场";
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//每次点击tabBarItem后触发这个方法(只有点击标签栏中的五个按钮才会触发，MORE里边的不会触发)
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.title = viewController.title;
}

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
