//
//  YHDeleteRepairCaseView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/20.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHDeleteRepairCaseView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *topicL;

@property (weak, nonatomic) IBOutlet UILabel *describeL;

@property (weak, nonatomic) UIView *hudView;

+ (instancetype)alertToView:(UIView *)view;

- (void)hideDeleteView;

@end
