//
//  YHDiagnosisProjectVC.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBillStatusModel.h"
#import "YHBaseViewController.h"
@interface YHDiagnosisProjectVC : YHBaseViewController

@property(nonatomic,strong)YHBillStatusModel *billModel;
@property (nonatomic)BOOL isHelp;//是否是帮检单

@end
