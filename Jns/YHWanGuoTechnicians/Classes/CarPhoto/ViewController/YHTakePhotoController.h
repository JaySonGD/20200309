//
//  YHTakePhotoController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@class YHPhotoModel,YHPhotoDBModel,TTZDBModel;
@interface YHTakePhotoController : YHBaseViewController

@property (nonatomic, strong) NSMutableArray <YHPhotoModel *>*models;
@property (nonatomic, strong) YHPhotoDBModel *dbTemp;

@property (nonatomic, strong) NSMutableArray <TTZDBModel *> *otherTempImage;

@property (nonatomic, copy) NSString *billId;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^doClick)(void);


@end
