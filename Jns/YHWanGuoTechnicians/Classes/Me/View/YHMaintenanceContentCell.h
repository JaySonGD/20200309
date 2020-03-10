//
//  YHMaintenanceContentCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/11/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHMaintenanceContentCell : UITableViewCell

@property (nonatomic,assign) BOOL isCanEdit;

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, assign)BOOL isLast;//最后一个切圆角

@property (nonatomic, copy) void(^clickSelectMaintenanceEvent)(NSDictionary *itemDict);

@end
