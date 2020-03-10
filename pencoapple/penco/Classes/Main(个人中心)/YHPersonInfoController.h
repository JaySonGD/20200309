//
//  YHPersonInfoController.h
//  penco
//
//  Created by Jay on 19/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseTableViewController.h"


typedef enum : NSUInteger {
    PersonInfoActionDefault,
    PersonInfoActionAdd,
    PersonInfoActionDelete,
    PersonInfoActionNext,
    PersonInfoActionMasterDetail,
} PersonInfoAction;

NS_ASSUME_NONNULL_BEGIN

@class PCPersonModel;

@interface YHPersonInfoController : YHBaseTableViewController
@property (nonatomic, assign) PersonInfoAction action;
@property (nonatomic, weak) UIViewController *observer;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, strong) PCPersonModel *model;
@property (nonatomic, weak) UIViewController *sourceVC;
@property (nonatomic, copy) dispatch_block_t exitBlock;
@end

NS_ASSUME_NONNULL_END
