//
//  YHCarPhotoController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@class YHCarVersionModel,YHCarPicModel;

@interface YHCarPhotoController : YHBaseViewController

//@property(nonatomic,strong)YHCarVersionModel *model;
@property (nonatomic, strong) NSString  *billId;
@property (nonatomic, strong) NSString  *vinStr;

/** 是否已经添加完了必选的图片 */
@property (nonatomic, assign) BOOL isFinished;

/** 远程图片 */
@property (nonatomic, strong) YHCarPicModel *carPhotos;


@property (nonatomic, strong) UITableView *tableView;

@end
