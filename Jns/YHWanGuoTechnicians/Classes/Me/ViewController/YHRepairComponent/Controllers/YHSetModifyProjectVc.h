//
//  YHSetModifyProjectVc.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHSetModifyProjectVc : YHBaseViewController

/** 维修方式的名字 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void(^saveProjectBlock)(NSMutableArray *projectArrs);

/** 是否是新增 */
@property (nonatomic, assign) BOOL isNewAdd;

@property (nonatomic, strong) UIViewController *popVc;

@property (nonatomic, copy) NSArray *parts;
/** 需要提交的配件耗材数据 */
@property (nonatomic, strong) NSMutableArray *requireSaveParts;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *projectDataSource;
/** 搜索配件耗材带出来的维修项目 */
@property (nonatomic, strong) NSMutableArray *repairItemList;

@property (nonatomic, strong) NSMutableDictionary *repairData;

@property (nonatomic, strong) NSMutableArray *catchDataArr;

@end
