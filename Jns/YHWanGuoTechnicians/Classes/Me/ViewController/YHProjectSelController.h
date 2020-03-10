//
//  YHProjectSelController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/10.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHAddProjectController.h"
@interface YHProjectSelController : YHBaseViewController

@property (strong, nonatomic)NSDictionary *orderInfo;
//@property (nonatomic)BOOL isRepair;
//@property (nonatomic)BOOL isRepairModel;//是维修方式还是耗材
@property (nonatomic)YHAddProject model;
@property (weak, nonatomic)NSArray *repairActionData;
@property (strong, nonatomic)NSDictionary *carBaseInfo;
@property (nonatomic)BOOL isRepairPrice;//是不是修改维修报价
@end
