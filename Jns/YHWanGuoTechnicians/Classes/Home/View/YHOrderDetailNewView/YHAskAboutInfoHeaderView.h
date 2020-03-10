//
//  YHAskAboutInfoHeaderView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/3.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAskAboutInfoHeaderView : UIView

@property (nonatomic, copy) void(^jumpToCarPicBlock)();

@property (nonatomic, weak) UIButton *jumpCheckCarPicBtn;

- (void)setTitle:(NSString *)title;

@end
