//
//  YHNewOrderController.h
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/4/12.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
#import "YHWebFuncViewController.h"

/**
 新建工单控制器
 */
@interface YHNewOrderController : YHBaseViewController
@property (weak,nonatomic)YHWebFuncViewController *webController;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *vin;
@property (nonatomic)BOOL isCar;
- (void)loaddata:(NSString*)vin image:(UIImage*)image;


/** 是否来自帮捡*/
@property (nonatomic, assign) BOOL isHelpCheck;
@end
