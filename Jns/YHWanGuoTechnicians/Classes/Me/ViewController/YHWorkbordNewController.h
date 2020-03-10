//
//  YHWorkbordNewController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/28.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"


typedef NS_ENUM(NSInteger, YHWorkbordServiceType) {
    YHWorkbordServiceTypeW = 1 ,//1:维修
    YHWorkbordServiceTypeB ,//2:保养
    YHWorkbordServiceTypeJ ,// 3:检测
};
@interface YHWorkbordNewController : YHBaseViewController
@property (nonatomic, assign) BOOL isPushByWorkListDetail;
@property (weak, nonatomic)NSDictionary *uesrInfo;


@end
