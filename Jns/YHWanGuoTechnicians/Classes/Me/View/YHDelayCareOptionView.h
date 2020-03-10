//
//  YHDelayCareOptionView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHDelayCareOptionView : UIView

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, copy) NSString *optionIdStr;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *groupName;

@end
