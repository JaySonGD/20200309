//
//  YHExtrendListController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/10/23.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
typedef NS_ENUM(NSInteger, YHExtrendModel) {
    
    YHExtrendModelUnpay = 0 ,//@"待支付",
    YHExtrendModelPendingAudit = 1 ,//@"待审核",
    YHExtrendModelAuditAotThrough = 2 ,//@"审核不通过",
    YHExtrendModelAudited = 3 ,//@"已审核",
    YHExtrendModelCanceled = 4,//@"已取消"
    YHExtrendModelNoHaveExamine = 5 //@"待补充资料",
};
@interface YHExtrendListController : YHBaseViewController

@end
