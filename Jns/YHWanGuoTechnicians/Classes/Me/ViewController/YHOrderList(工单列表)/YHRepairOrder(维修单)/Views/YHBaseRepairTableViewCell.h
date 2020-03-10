//
//  YHBaseRepairTableViewCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/24.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlanModel.h"

@interface YHBaseRepairTableViewCell : UITableViewCell
/** 是否需要圆角效果 */
@property (nonatomic, assign) BOOL isNeedRaidus;
/** 模型数据 */
@property (nonatomic, strong) id cellModel;

@property (nonatomic, strong) NSIndexPath *indexPath;
/** 点击删除按钮 */
@property (nonatomic, copy) void(^removeCallBack)(NSIndexPath *indexPath);
/** 选择类别按钮 */
@property (nonatomic, copy) void(^selectClassClickEvent)(NSIndexPath *indexPath);
/** 是否需要隐藏下划线 */
@property (nonatomic, assign) BOOL isHiddenSeprateLine;
/** 是否不可编辑 默认为NO */
@property (nonatomic, assign) BOOL isNOCanEdit;
/** 是否是技师*/
@property (nonatomic, assign) BOOL isTechOrg;

/** :赠送 */
@property (nonatomic, assign) BOOL hasPresent;

@property (nonatomic, assign) BOOL is4s;
/**0 -> 没有   1-> 有一条  2-> 有两条（这个最多2条，至少1条） */
//@property (nonatomic, copy) NSString *isOilNumber;

@property (nonatomic, copy) void(^purchaseOperation)(NSMutableDictionary *);

@property (nonatomic, copy) NSString *billType;//类别

@end
