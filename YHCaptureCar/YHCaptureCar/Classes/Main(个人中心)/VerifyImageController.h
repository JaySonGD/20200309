//
//  VerifyImageController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface VerifyImageController : YHBaseViewController
@property (nonatomic, copy) NSString *imgCodeURL;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) void (^callBack)(NSInteger);
@end
