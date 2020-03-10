//
//  TTZCheckViewController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
@class TTZSYSModel,YHOrderDetailNewController;
@interface TTZCheckViewController : YHBaseViewController
@property (nonatomic, strong) NSMutableArray <TTZSYSModel *>*sysModels;
/** 当前索引*/
@property (nonatomic, assign) NSInteger currentIndex;
/** 基本信息*/
@property (nonatomic, strong) NSDictionary *baseInfo;
/** 工单id*/
@property (nonatomic, copy) NSString *billId;

@property (nonatomic, copy) NSString *billType;

@property (nonatomic, copy) dispatch_block_t callBackBlock;

@property (nonatomic, assign) BOOL is_circuitry;

@property (nonatomic, copy) void(^backBlock)();

@property (nonatomic, weak) YHOrderDetailNewController *detailNewController;

@property (nonatomic, assign) BOOL isNoEdit;

@property (nonatomic, copy) NSString *carBrand;

@property (nonatomic, assign) BOOL isFromAI;//是不是从尾气诊断过来

@property (nonatomic, strong) NSMutableArray *sysArray;

@end
