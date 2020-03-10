//
//  YHDepthEditeController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/2.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHAddProjectController.h"
@interface YHDepthEditeController : YHBaseViewController
@property (strong, nonatomic)NSString *checkResult;
@property (weak, nonatomic)NSArray *repairActionData;
@property (strong, nonatomic)NSDictionary *orderInfo;
@property (strong, nonatomic)NSDictionary *carBaseInfo;
@property (nonatomic)BOOL isRepair;//维修方式编辑
@property (strong, nonatomic)NSString *repairStr;
@property (strong, nonatomic)NSString *warrantyDay;
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)NSMutableArray *dataSourceSupplies;
@property (nonatomic)NSInteger repairIndex;
@property (nonatomic)BOOL repairEdit;
@property (nonatomic)BOOL cloudRepair;
@property (strong, nonatomic)NSString *dateTime;
@property (strong, nonatomic)NSString *schemeContent;
@property (nonatomic)BOOL isRepairPrice;//是不是修改维修报价
//@property (nonatomic)YHAddProject model;
@end
