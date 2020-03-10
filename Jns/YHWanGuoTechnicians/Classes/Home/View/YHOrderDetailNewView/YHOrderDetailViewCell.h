//
//  YHOrderDetailViewCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTZSurveyModel.h"


typedef NS_ENUM(NSInteger, YHOrderDetailViewCellType) {
    YHOrderDetailViewCellTypeNone, 
    YHOrderDetailViewCellTypeArrow, // 仅仅显示箭头
    YHOrderDetailViewCellTypeArrowAndText, // 仅仅显示箭头和文字
    YHOrderDetailViewCellTypeSwitch // 仅仅显示开关
};

@interface YHOrderDetailViewCell : UITableViewCell

@property (nonatomic, copy) TTZSYSModel *cellModel;

+ (instancetype)createOrderDetailViewCell:(UITableView *)tableView;

@property (nonatomic, copy) NSString *orderIdType;

@property (nonatomic, assign) YHOrderDetailViewCellType type;

@property (nonatomic, copy) void(^onOffSwitchTouchEvent)(NSString *Id,BOOL isOn);

@property (nonatomic, assign) BOOL isEnableForSwitch;

@property (nonatomic, assign) BOOL isOnOffSwitch;

@property (nonatomic, weak) UILabel *checkL;

@end
