//
//  YHNewOrderCompeteVC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/11.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"

@interface YHNewOrderCompeteVC : YHBaseViewController
/** 技师列表 */
@property (nonatomic, copy) NSArray *technicianArr;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) UIViewController *vinController;
/** 工单号 */
@property (nonatomic, copy) NSString *billId;

/**
 VIN码
 */
@property(nonatomic,copy)NSString *vinStr;
//是否是帮检单
@property (nonatomic)BOOL isHelp;

@end
