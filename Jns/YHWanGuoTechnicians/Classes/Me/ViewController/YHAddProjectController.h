//
//  YHAddProjectController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/10.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

typedef NS_ENUM(NSInteger, YHAddProject) {
    YHAddProjectDepth ,//创建细检项目
    YHAddProjectRepairItem ,//创建检测与维修个项
    YHAddProjectPart ,//创建配件与耗材
    YHAddProjectActionSel ,//维修项目动作选择
};

@interface YHAddProjectController : YHBaseViewController

//@property (nonatomic)BOOL isRepairOption;//是维修方式操作选择
//@property (nonatomic)BOOL isRepair;
//@property (nonatomic)BOOL isRepairModel;//是维修方式还是耗材
@property (nonatomic)YHAddProject model;
@property (weak, nonatomic)NSArray *repairActionData;
@end
