//
//  YHExtrendBackListController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
typedef NS_ENUM(NSInteger, YHExtrendBackModel) {
    YHExtrendBackModelUn ,//未返现
    YHExtrendBackModelPart ,//部分
    YHExtrendBackModelAll ,//全部
};
@interface YHExtrendBackListController : YHBaseViewController

@property (strong, nonatomic)NSString *fromDate;
@property (strong, nonatomic)NSString *toDate;
@end
