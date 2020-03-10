//
//  YHRichBindBankCardController.h
//  YHCaptureCar
//
//  Created by liusong on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHRichBindBankCardController : YHBaseViewController
/** 是否是修改银行卡 */
@property (nonatomic, assign) BOOL isModifyBank;
/** 记录ID 新增的时候 留空， 修改时，必填 */
@property (nonatomic, copy) NSString *bankCardId;

@end
