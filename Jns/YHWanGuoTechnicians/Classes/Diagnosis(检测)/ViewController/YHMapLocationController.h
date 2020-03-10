//
//  YHMapLocationController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHMapLocationController : YHBaseViewController

@property(nonatomic,copy)void (^addressBlock)(NSString *address);

@end
