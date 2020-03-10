//
//  YHDepthController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/2.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHOrderDetailController.h"
@interface YHDepthController : YHOrderDetailController

@property (strong, nonatomic)NSDictionary *orderInfo;
@property (nonatomic)BOOL isRepair;
@property (nonatomic)BOOL isRepairPrice;//是不是修改维修报价
@end
