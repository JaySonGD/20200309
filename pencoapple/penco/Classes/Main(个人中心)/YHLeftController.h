//
//  YHLeftController.h
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/3.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseViewController.h"
#import "PCPersonModel.h"
typedef NS_ENUM(NSInteger, YHLeftMenuActions) {
    YHLeftMenuActionsRegistrationSuccessful    ,//注册成功(未申请)
    YHLeftMenuActionsAuditIng    ,//审核中
    YHLeftMenuActionsAuditDone    ,//已认证
    YHLeftMenuActionsAuditFail    ,//审核不通过
};

@protocol YHLeftMenuActionDelegate <NSObject>
@required
- (void)leftMenuActions:(YHLeftMenuActions)actionKey withInfo:(NSDictionary*)info;

@end

@interface YHLeftController : YHBaseViewController

@property (nonatomic, weak)id<YHLeftMenuActionDelegate> delegate;
@end
