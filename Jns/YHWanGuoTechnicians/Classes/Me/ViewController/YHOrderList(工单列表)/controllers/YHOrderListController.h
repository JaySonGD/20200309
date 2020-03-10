//
//  YHOrderListController.h
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseTableViewController.h"
#import "YHFunctionsEditerController.h"
@interface YHOrderListController : YHBaseTableViewController
@property (nonatomic)YHFunctionId functionKey;
@property (nonatomic)BOOL isLevelTwo;//是否从二级目录进入

@property (nonatomic, assign) BOOL showCarReport;
@property (nonatomic, copy) NSString *keyWord;
@end
