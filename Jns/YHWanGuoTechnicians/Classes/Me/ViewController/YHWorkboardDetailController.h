//
//  YHWorkboardDetailController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
typedef NS_ENUM(NSInteger, YHWorkbordModel) {
    YHWorkbordModelNotice ,//业务提醒
    YHWorkbordModelOrder ,//最近工单
    YHWorkbordModelRecord ,//回访记录
};
@interface YHWorkboardDetailController : YHBaseViewController
@property (weak, nonatomic)NSDictionary *wordbordInfo;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, assign) BOOL isTubeCarPush;
@end
