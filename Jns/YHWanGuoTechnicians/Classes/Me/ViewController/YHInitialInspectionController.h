//
//  YHInitialInspectionController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHInitialInspectionController : YHBaseViewController

@property (strong, nonatomic)NSMutableArray *sysAr;
@property (weak, nonatomic)NSDictionary *sysData;
@property (strong, nonatomic)NSDictionary *orderInfo;
@property (strong, nonatomic)NSNumber *is_circuitry;
@property (strong, nonatomic)NSString *titleStr;
@property (nonatomic)BOOL isInitialInspectionSys;//是不是新全车系统选择页

@property (nonatomic)BOOL isHasPhoto;// J002
/** 刹车距离项存在时对应的code */
@property (nonatomic, copy) NSString *code;
/** 刹车距离项存在时对应的工单号 */
@property (nonatomic,assign) NSInteger billId;
/** 刹车距离name */
@property (nonatomic, copy) NSString *brakeName;

@end
