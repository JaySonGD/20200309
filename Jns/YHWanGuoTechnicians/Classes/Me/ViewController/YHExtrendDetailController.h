//
//  YHExtrendDetailController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHExtrendListController.h"

typedef NS_ENUM(NSInteger, YHExtrendAgreementChoice) {
    YHExtrendAgreementChoiceDate ,//服务期限
    YHExtrendAgreementChoiceTechnician ,//服务技师
    YHExtrendAgreementChoiceSalesperson ,//服务销售
};

@interface YHExtrendDetailController : YHBaseViewController

@property (strong, nonatomic)NSDictionary *extrendOrderInfo;
@property (nonatomic, copy) NSString *status;

@end
