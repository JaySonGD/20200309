//
//  YHShowImageController.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/12/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHShowImageController : YHBaseViewController
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, assign) BOOL needBuy;
@property (nonatomic, assign) BOOL isHome;//首页进入显示升级权限,其他进入默认
@end
