//
//  YYGB_NavigationController.m
//  YYGB
//
//  Created by Jay on 3/12/2019.
//  Copyright © 2019 YYGB_. All rights reserved.
//

#import "YYGB_NavigationController.h"

@interface YYGB_NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YYGB_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:0.09 green:0.14 blue:0.26 alpha:1.00];
//
//
//
//    self.navigationBar.tintColor = [UIColor whiteColor];
//
//    self.navigationBar.barTintColor = self.view.backgroundColor;
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
//
//
//    if (@available(iOS 11.0, *)) {
//        self.navigationBar.prefersLargeTitles = YES;
//        [self.navigationBar setLargeTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:34]}];
//
//    }
    
    // 全屏返回手势，而不是边缘返回手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    
    [self.view addGestureRecognizer:pan];
    // 控制手势什么时候触发，只有非根控制器才需要出发手势
    pan.delegate = self;
    // 禁止之前手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 当不是根控制器时才会触发返回手势
    return (self.childViewControllers.count > 1);
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
//    if (@available(iOS 11.0, *)) {
//        if(
//           ![viewController isKindOfClass:NSClassFromString(@"YYGB_PlayViewController")]
//           ){
//            viewController.navigationItem.largeTitleDisplayMode =  UINavigationItemLargeTitleDisplayModeAutomatic;
//        }
//        else{
//            viewController.navigationItem.largeTitleDisplayMode =  UINavigationItemLargeTitleDisplayModeNever;
//        }
//    }
    [super pushViewController:viewController animated:animated];
}


@end
