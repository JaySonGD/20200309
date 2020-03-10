//
//  YHAddPartVC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/1.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHAddPartVC : YHBaseViewController

/** 维修方式的名字 */
@property (nonatomic, assign) NSInteger index;
/** 上个输入框的text */
@property (nonatomic,copy) NSString *searchText;

@property (nonatomic, copy) void(^notificationToSearchViewBlock)(NSString *text);

@end
