//
//  VerifyCodeController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface VerifyCodeController : YHBaseViewController
@property (nonatomic, assign) NSInteger expire;
@property (nonatomic, copy) NSString * mobile;
/** 登录者账户 */
@property (nonatomic, copy)NSString *accName;

@end
