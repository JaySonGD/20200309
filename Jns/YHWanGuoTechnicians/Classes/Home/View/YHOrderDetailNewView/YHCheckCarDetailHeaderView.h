//
//  YHCheckCarDetailHeaderView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCheckCarDetailHeaderView : UIView

@property (nonatomic, copy) void(^rigitBtnClickedEvent)(BOOL isOpen, NSInteger sectionIndex);
/** 对应的组索引 */
@property (nonatomic, assign) NSInteger sectionIndex;
/** 关闭时的count */
@property (nonatomic, assign) NSInteger problemCount;
/** 展开时count */
@property (nonatomic, assign) NSInteger sectionCount;
/** 工单类型 */
@property (nonatomic, assign) NSString *billType;

- (void)initCheckCarDetailHeaderViewUI;

- (void)setHeaderTitle:(NSString *)text;
- (void)isNeedOpen:(BOOL)isOpen;
- (void)setHeaderResultTitle:(NSString *)text;
@end
