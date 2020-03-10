//
//  YTCounterController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTCounterController : YHBaseViewController
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *billType;
//@property (nonatomic, copy) NSString *bill_sort;
@property (nonatomic, copy) NSString *parts_suggestion_id;
@property (nonatomic, assign) NSInteger buy_type;
@property (nonatomic, assign) BOOL isReloadH5;
@property (nonatomic, copy) dispatch_block_t block;//配置建议支付成功回调刷新界面
@property (nonatomic, copy) void(^paySuccessBlock)(NSString *);
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
