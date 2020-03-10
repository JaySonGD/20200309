//
//  YHMapViewController.h
//  YHCaptureCar
//
//  Created by liusong on 2018/1/17.
//  Copyright © 2018年 YH. All rights reserved.
//  检测模块地图展示控制器

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
@interface YHMapViewController : YHBaseViewController

@property (nonatomic)BOOL isNavi;
@property (strong, nonatomic)NSString *addrStr;

@end
