//
//  YHScreeningConditionsController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHWebFuncViewController.h"
@interface YHScreeningConditionsController : YHBaseViewController

@property (weak,nonatomic)YHWebFuncViewController *webController;
@property (strong, nonatomic)NSString *fromDate;
@property (strong, nonatomic)NSString *toDate;
@end
