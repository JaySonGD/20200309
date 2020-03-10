//
//  YHRepairAddController.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlanModel.h"
#import "YHIntelligentCheckModel.h"

typedef NS_OPTIONS(NSUInteger, YHRepairType) {
    YHRepairPartType = 0,     // 配件
    YHRepairMaterialType = 1, // 耗材
    YHRepairProjectType = 2   // 维修项目
};

typedef NS_OPTIONS(NSUInteger, YHRepairStatus) {
    YHRepairStatusShowLocalRecord = 0,      // 展示本地搜索记录状态
    YHRepairStatusShowSearchResult = 1,      //展示搜索结果状态
    YHRepairStatusShowFinalSelectResult = 2   // 展示最终选择结果状态
};

@interface YHRepairAddController : UIViewController

@property (nonatomic, strong) YTBaseInfo *baseInfo;

@property (nonatomic, strong)YHBaseInfoModel *base_info;

@property (nonatomic,assign) YHRepairType repairType;

@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, strong) NSString *TitleText;
//
@property (nonatomic, assign) BOOL isNotZero;//另外两项是否不为0,b判断最后一项能否删除

@property (nonatomic, copy) void(^addDataBlock)(NSArray *finalArr,NSInteger section);

/** 点击删除按钮 */
@property (nonatomic, copy) void(^removeCallBack)(NSInteger index);

@end
