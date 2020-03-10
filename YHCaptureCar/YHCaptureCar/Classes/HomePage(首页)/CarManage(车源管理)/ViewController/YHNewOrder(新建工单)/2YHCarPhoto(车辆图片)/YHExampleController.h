//
//  YHExampleController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
@class YHPhotoModel;
@interface YHExampleController : YHBaseViewController
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray<YHPhotoModel*> *models;
@end
