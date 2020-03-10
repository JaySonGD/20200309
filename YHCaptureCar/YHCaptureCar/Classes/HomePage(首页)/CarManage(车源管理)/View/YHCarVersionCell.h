//
//  YHCarVersionCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCarVersionModel.h"

/**
 版本选择Cell
 */
@interface YHCarVersionCell : UITableViewCell

@property(nonatomic,strong)YHCarVersionModel *model;

/**
 选择按钮
 */
@property (strong , nonatomic)UIButton *selectBtn;

@end
