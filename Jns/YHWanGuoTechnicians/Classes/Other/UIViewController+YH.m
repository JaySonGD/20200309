//
//  UIViewController+YH.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/4/23.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "UIViewController+YH.h"

@implementation UIViewController (YH)
- (BOOL)popToViewcontroller:(Class)class{
    NSArray *controllers = self.navigationController.viewControllers;
    for (NSInteger i = controllers.count - 1;  i > 0 ; i--) {
        UIViewController *controllerT = controllers[i];
        if ([controllerT isKindOfClass:class]) {
            [self.navigationController popToViewController:controllerT animated:YES];
            return YES;
        }
    }
    return NO;
}


//返回到 以controller数组指定的controller
- (BOOL)popToViewcontrollers:(NSArray *)controllers{
    __weak __typeof__(self) weakSelf = self;
    __block BOOL isBack;
    [controllers enumerateObjectsUsingBlock:^(__kindof Class _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakSelf popToViewcontroller:class]) {
            *stop = YES;
            isBack = YES;
        }
    }];
    return isBack;
}


//返回到上级controller
- (void)popToPreViewcontroller:(NSArray *)controllers{
    if (![self popToViewcontrollers:controllers]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
