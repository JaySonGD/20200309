//
//  YHAddModifyProjectVc.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAddModifyProjectVc : UIViewController

/** 上个输入框的text */
@property (nonatomic,copy) NSString *searchText;

@property (nonatomic, copy) void(^notificationToSearchViewBlockFromProject)(NSString *text);

@end
