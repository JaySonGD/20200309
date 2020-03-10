//
//  YHSetPartSearchVc.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

typedef NS_ENUM(NSInteger, YHSetPartsType) {
    YHConsuMaterialType, // 设置配件耗材
    YHAddProjectType // 添加项目
};

@interface YHSetPartSearchVc : YHBaseViewController

/** 是否是新增 */
@property (nonatomic, assign) BOOL isNewAdd;
/** 配件耗材个数 */
@property (nonatomic, assign) NSInteger numbers;
/** 维修方式的名字 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *catchDataArr;

@property (nonatomic, copy) void(^searchPartGetProjectListNotification)(NSMutableArray *repairList);

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithControllerType:(YHSetPartsType)type;

@end
