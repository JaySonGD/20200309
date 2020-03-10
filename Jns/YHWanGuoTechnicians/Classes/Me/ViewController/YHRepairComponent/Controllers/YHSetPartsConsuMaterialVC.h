//
//  YHSetPartsConsuMaterialVC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/30.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"


@interface YHSetPartsConsuMaterialVC : YHBaseViewController
/** 维修方式的名字 */
@property (nonatomic, assign) NSInteger index;
/** 是否是新增 */
@property (nonatomic, assign) BOOL isNewAdd;

@property (nonatomic, strong) UIViewController *popVc;

@property (nonatomic, copy) NSDictionary *info;
/** 配件耗材搜索时带出来的维修项目列表 */
@property (nonatomic, strong) NSMutableArray *repaireListWithPart;

@property (nonatomic, strong) NSMutableArray *catchDataArr;

@end
