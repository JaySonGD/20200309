//
//  YHSysSelController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHSysSelController : YHBaseViewController

@property (strong, nonatomic)NSMutableArray *sysinfos;
@property (weak, nonatomic)NSDictionary *sysData;
@property (strong, nonatomic)NSDictionary *orderInfo;
@property (strong, nonatomic)NSNumber *is_circuitry;
@end
