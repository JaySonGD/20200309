//
//  UIButton+YHNetWorkLoad.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/8/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "UIButton+YHNetWorkLoad.h"
#import <objc/runtime.h>
#import "YHCommon.h"

@implementation UIButton (YHNetWorkLoad)

- (void)setYH_normalTitle:(NSString *)YH_normalTitle{
    objc_setAssociatedObject(self, @"YH_normalTitle_key", YH_normalTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setTitle:YH_normalTitle forState:UIControlStateNormal];
}
- (NSString *)YH_normalTitle{
    return objc_getAssociatedObject(self, @"YH_normalTitle_key");
}

- (void)setYH_loadStatusTitle:(NSString *)YH_loadStatusTitle{
    objc_setAssociatedObject(self, @"YH_loadStatusTitle_key", YH_loadStatusTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)YH_loadStatusTitle{
    return objc_getAssociatedObject(self, @"YH_loadStatusTitle_key");
}

- (void)setYH_indicatorView:(UIActivityIndicatorView *)YH_indicatorView{
    objc_setAssociatedObject(self, @"YH_indicatorView_key", YH_indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIActivityIndicatorView *)YH_indicatorView{
    return objc_getAssociatedObject(self, @"YH_indicatorView_key");
}

- (void)setYH_hudView:(UIView *)YH_hudView{
    objc_setAssociatedObject(self, @"YH_hudView_key", YH_hudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)YH_hudView{
    return objc_getAssociatedObject(self, @"YH_hudView_key");
}

- (void)YH_showStartLoadStatus{
    
    CGFloat loginInfoWidth = [self.YH_loadStatusTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 16.0) options:nil attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size.width;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.hidesWhenStopped = YES;
    [self addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(indicatorView.superview);
        make.right.equalTo(indicatorView.superview.mas_centerX).offset(-(loginInfoWidth/2.0 + 10));
    }];
    self.YH_indicatorView = indicatorView;
    [self setTitle:self.YH_loadStatusTitle forState:UIControlStateNormal];
    [indicatorView startAnimating];
    self.userInteractionEnabled = NO;
    
    UIView *hudView = [[UIView alloc] init];
    hudView.backgroundColor = [UIColor clearColor];
    CGFloat topMargin = 64;
    if ([UIScreen mainScreen].bounds.size.width == 375.0 && [UIScreen mainScreen].bounds.size.height == 812.0) {
        topMargin = 88.0;
    }
    hudView.frame = CGRectMake(0, topMargin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topMargin);
    hudView.backgroundColor = [UIColor clearColor];
    UIViewController *currentVc = [self getCurrentVC];
    [currentVc.view addSubview:hudView];
    self.YH_hudView = hudView;
}
- (void)YH_showEndLoadStatus{
   
    [self setTitle:self.YH_normalTitle forState:UIControlStateNormal];
    [self.YH_indicatorView stopAnimating];
    self.userInteractionEnabled = YES;
    [self.YH_hudView removeFromSuperview];
    self.YH_hudView = nil;
}
#pragma mark  --获取当前屏幕显示的viewcontroller --------
- (UIViewController *)getCurrentVC{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
