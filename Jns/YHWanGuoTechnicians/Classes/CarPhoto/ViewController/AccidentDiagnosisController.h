//
//  AccidentDiagnosisController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@class YHSurveyCheckProjectModel;
@interface AccidentDiagnosisController : YHBaseViewController
@property (nonatomic, strong) YHSurveyCheckProjectModel *model;


    @property (nonatomic, copy) void(^saveTempData)(BOOL isFinish, NSString *key,NSDictionary *val);
    
@end
