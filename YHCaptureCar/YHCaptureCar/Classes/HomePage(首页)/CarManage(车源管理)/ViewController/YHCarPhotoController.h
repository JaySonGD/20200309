//
//  YHCarPhotoController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@class YHCarPicModel;

@interface YHCarPhotoController : YHBaseViewController

@property (nonatomic, strong) NSString  *billId;
@property (nonatomic, strong) NSString  *vinStr;

/** 是否已经添加完了必选的图片 */
@property (nonatomic, assign) BOOL isFinished;

/** 远程图片 */
@property (nonatomic, strong) YHCarPicModel *carPhotos;

/** 描述 */
@property (nonatomic, copy) NSString *carDesc;

@end
