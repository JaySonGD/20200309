//
//  YHMaintenanceCollectionCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/11/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHMaintenanceCollectionCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UIButton *itemBtn;

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, assign) BOOL isCanEdit;

@property (nonatomic, copy) void(^clickEditBtnEvent)(NSDictionary *itemDict);

@end
