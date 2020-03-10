//
//  YHAddPartTypeView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAddPartTypeView : UIView

@property (nonatomic, copy) void(^selectBtnClickEvent)(BOOL isSelectLeft);

@property (nonatomic, assign) BOOL isSelectLeftBtn;

@end
