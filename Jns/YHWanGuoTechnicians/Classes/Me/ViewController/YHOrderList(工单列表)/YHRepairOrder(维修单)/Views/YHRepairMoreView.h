//
//  YHRepairMoreView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRepairMoreView : UIView

@property (weak, nonatomic) IBOutlet UIButton *reNameBtn;

@property (weak, nonatomic) IBOutlet UIButton *caseButton;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@property (nonatomic, copy) void(^tapViewGesTure)(void);

@property (nonatomic, assign) BOOL is_sysCase;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reNameHeight;

@end
