//
//  YHSetPartNameView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHSetPartNameView : UIView
/** name-Lable */
@property (nonatomic, weak) UILabel *textL;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *removeBtn;
/** XX按钮 */
@property (nonatomic, weak) UIButton *deleBtn;

@property (nonatomic, copy) void(^deleBtnPartNameClickBlock)();

@property (nonatomic, copy) void(^removeBtnPartNameClickBlock)();
@end
