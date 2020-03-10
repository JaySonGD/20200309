//
//  YHEditDiagnoseResultVc.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/29.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHEditDiagnoseResultVc : YHBaseViewController

@property (nonatomic, copy) void(^saveSuccessBackBlock)(NSString *text);
/** 诊断结果字符串 */
@property (nonatomic, copy) NSString *diagnoseResultText;

@property (nonatomic, assign) NSInteger type;//1.诊断思路 2.诊断结果 0其他

@property (nonatomic ,copy) NSString * bill_id;//工单id

@end
