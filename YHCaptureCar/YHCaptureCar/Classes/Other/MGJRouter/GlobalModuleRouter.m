//
//  GlobalModuleRouter.m
//  RouterDemo
//
//  Created by 廖文韬 on 2018/7/16.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

#import "GlobalModuleRouter.h"
#import "MGJRouter.h"
#import "YTDetailViewController.h"
#import "UIViewController+RESideMenu.h"
#import "TTZCarModel.h"

@implementation GlobalModuleRouter

// 在load方法中自动注册，在主工程中不用写任何代码。
+ (void)load {
    
    [MGJRouter registerURLPattern:@"open://YTDetailViewController" toHandler:^(NSDictionary *routerParameters) {
        UIViewController *VC = routerParameters[MGJRouterParameterUserInfo][@"gotoVC"];
        NSLog(@"%@",routerParameters[MGJRouterParameterUserInfo]);
        YTDetailViewController *vc =  [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YTDetailViewController"];
        TTZCarModel *model = [TTZCarModel new];
        model.carId = routerParameters[MGJRouterParameterUserInfo][@"orderInfo"][@"carId"];
        model.flag = YES;
        vc.carModel = model;
        vc.title = @"详情";
        vc.bottomStyle = YTDetailBottomStyleHelpSellAuth;
        if(VC.navigationController){
            [VC.navigationController setNavigationBarHidden:NO animated:NO];//防止h5跳转导航栏不出来
            [VC.navigationController pushViewController:vc animated:YES];
        }else{
            [VC presentViewController:vc animated:YES completion:nil];
        }
        [VC hideMenuViewController:nil];
        
    }];
    
    
//    [MGJRouter registerURLPattern:@"b" toHandler:^(NSDictionary *routerParameters) {
//        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
//        NSString *labelText = routerParameters[MGJRouterParameterUserInfo][@"text"];
//        TestViewController2 *vc = [[TestViewController2 alloc] init];
//        vc.labelText = labelText;
//        [navigationVC pushViewController:vc animated:YES];
//    }];
//
//    [MGJRouter registerURLPattern:@"c" toHandler:^(NSDictionary *routerParameters) {
//        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
//        void(^block)(NSString *) = routerParameters[MGJRouterParameterUserInfo][@"block"];
//        TestViewController3 *vc = [[TestViewController3 alloc] init];
//        vc.clicked = block;
//        [navigationVC pushViewController:vc animated:YES];
//    }];
    
    
//    [MGJRouter registerURLPattern:@"d" toObjectHandler:^id(NSDictionary *routerParameters) {
//        NSString *labelText = routerParameters[MGJRouterParameterUserInfo][@"text"];
//        TestViewController2 *vc = [[TestViewController2 alloc] init];
//        vc.labelText = labelText;
//        return vc;
//    }];
    
}


@end
