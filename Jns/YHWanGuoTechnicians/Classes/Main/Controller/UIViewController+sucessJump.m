//
//  UIViewController+sucessJump.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/30.test
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "UIViewController+sucessJump.h"
#import "YHDepthController.h"
#import "YHOrderListController.h"
#import "YHExtrendListController.h"
#import "YHWebFuncViewController.h"
#import <objc/runtime.h>

extern NSString *const notificationOrderListChange;

static NSString *const successTimer = @"sucessJump_timer";

@implementation UIViewController (sucessJump)

- (void)setSuccessTimer:(NSTimer *)successTimer{
    objc_setAssociatedObject(self, &successTimer, successTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimer *)successTimer{
    return objc_getAssociatedObject(self, &successTimer);
}

- (void)setTotalTimes:(NSInteger)totalTimes{
     objc_setAssociatedObject(self, @"totalTimes", @(totalTimes), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)totalTimes{
    
     return [objc_getAssociatedObject(self, @"totalTimes") integerValue];
}

- (void)submitDataSuccessToJump:(NSDictionary *)orderInfo pay:(BOOL)isPay message:(NSString *)message{
   
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if (orderInfo) {
        [info setValue:orderInfo forKey:@"orderInfo"];
    }
    [info setValue:[NSNumber numberWithBool:isPay] forKey:@"isPay"];
    message = !message ? @"" : message;
    [info setValue:message forKey:@"message"];
//    self.successTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(successTimer:) userInfo:info repeats:YES];
//    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",message] toView:self.view timeOut:3.0];
    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",message] toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self successToPopViewController:orderInfo];
    });
//    self.totalTimes = 4;
//    [self.successTimer fire];
 
}
- (void)successToPopViewController:(id)orderInfo{

    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationOrderListChange
     object:Nil
     userInfo:nil];
    __weak __typeof__(self) weakSelf = self;
    __block BOOL isBack = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHOrderListController class]] || [obj isKindOfClass:[YHExtrendListController class]] ) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            isBack = YES;
        }
    }];
    ///// 解决方案列表
    if(!isBack){
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"YHSolutionListViewController")]) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                *stop = YES;
                isBack = YES;
            }
        }];
        
    }
    
    
    if(!isBack){
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
                if([orderInfo[@"billType"] isEqualToString:@"Y002"]){
                [obj appToH5:nil];
                }
                [weakSelf.navigationController popToViewController:obj animated:YES];
                *stop = YES;
                isBack = YES;
            }
        }];
        
    }
    
    if (!isBack) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)successTimer:(NSTimer *)timer{
    
    [self successTimeout:timer orderInfo:timer.userInfo[@"orderInfo"] pay:[timer.userInfo[@"isPay"] boolValue] message:timer.userInfo[@"message"]];
}
- (void)successTimeout:(NSTimer *)sender orderInfo:(NSDictionary *)orderInfo pay:(BOOL)isPay message:(NSString *)message{

    NSInteger count = self.totalTimes - 1;
    if (count > 0) {
        self.totalTimes -= 1;
        
    }else{
        
        [self.successTimer invalidate];
        self.successTimer = nil;
        [self successToPopViewController:nil];
    }
}
@end
