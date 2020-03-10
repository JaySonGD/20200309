//
//  YHCarVersionVC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//  车辆版本控制器

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
@interface YHCarVersionVC : YHBaseViewController

/**
 VIN码
 */
@property(nonatomic,copy)NSString *vinStr;


@property (nonatomic, strong) NSMutableArray *carVersionArray;  //汽车版本数组


/** 是否来自帮捡*/
@property (nonatomic, assign) BOOL isHelpCheck;

@end

