//
//  UIViewController+YH.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/4/23.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YH)
- (BOOL)popToViewcontroller:(Class)class;

//返回到 以controller数组指定的controller
- (BOOL)popToViewcontrollers:(NSArray *)controllers;

//返回到上级controller
- (void)popToPreViewcontroller:(NSArray *)controllers;
@end
