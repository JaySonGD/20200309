//
//  YHOrderDetailController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/17.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHFunctionsEditerController.h"

@interface YHOrderDetailController : YHBaseViewController <UITableViewDelegate, UITableViewDataSource>

//是否为父工单
@property (nonatomic, assign) BOOL isFatherWorkList;
                @property (nonatomic, assign) BOOL showCarReport;

@property (strong, nonatomic)NSDictionary *orderInfo;
@property (nonatomic)YHFunctionId functionKey;
@property (strong, nonatomic)NSDictionary *data;
@property (nonatomic)BOOL isDepth;

@property (nonatomic)BOOL dethPay;
@property (nonatomic)BOOL newWhole;
@property (nonatomic)BOOL isPop2Root;
@property (strong, nonatomic)NSMutableArray *depthProjectVal;
@property (strong, nonatomic)NSMutableArray *cloudDepthProjectVal;
@property (strong, nonatomic)NSMutableArray *storeDepthProjectVal;
@property (strong, nonatomic)NSMutableArray *cloudRepairs;
@property (strong, nonatomic)NSDictionary *cloudCheckResult;//云诊断结果
@property (strong, nonatomic)NSString *orderId;

- (void)orderDetail;

@end
