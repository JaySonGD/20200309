//
//  YHOrderDetailViewHeaderView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHOrderDetailViewHeaderView : UIView

@property (nonatomic, copy) void(^indicateBtnClickBlock)();

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UILabel *indicateL;

@property (nonatomic, assign) BOOL isCar;

- (void)modifyContentViewHeight:(CGFloat)height;

- (void)setTitleLableTextContent:(NSString *)text;

- (void)hideBottomContentView:(BOOL)hide;

@end
