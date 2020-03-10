//
//  YHPayResultController.h
//  YHCaptureCar
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHPayResultController : YHBaseViewController
@property (nonatomic, copy) dispatch_block_t doAction;
@property (nonatomic, copy) NSString *payMoneyString;
@end
