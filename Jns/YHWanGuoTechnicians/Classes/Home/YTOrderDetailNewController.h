//
//  YTOrderDetailNewController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 30/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHIntelligentCheckModel.h"
#import "YHNoPayStatusView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTOrderDetailNewController : YHBaseViewController
@property (nonatomic, assign) BOOL isNo;
@property (nonatomic, copy) NSString *billType;
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *menuCode;
@property (nonatomic, copy) NSString *billIdNew;
@property (nonatomic,strong) YHReportModel *diagnoseModel;
@property (nonatomic, weak) YHNoPayStatusView *noPayView;

@end

NS_ASSUME_NONNULL_END
