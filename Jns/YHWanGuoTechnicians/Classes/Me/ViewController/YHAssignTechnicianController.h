//
//  YHAssignTechnicianController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/24.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
@interface YHAssignTechnicianController : YHBaseViewController

@property(strong, nonatomic)NSDictionary *data;
@property(strong, nonatomic)NSMutableDictionary *assignInfo;
@property (strong, nonatomic)NSDictionary *orderInfo;
@property (nonatomic)BOOL isMark;
@end
