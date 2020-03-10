//
//  YHRichSelectBankController.h
//  YHCaptureCar
//
//  Created by liusong on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHRichSelectBankController : YHBaseViewController

@property (nonatomic, copy) void(^selectCellEvent)(NSDictionary *selectDict);

@end
