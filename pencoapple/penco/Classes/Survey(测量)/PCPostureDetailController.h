//
//  PCPostureController.h
//  penco
//
//  Created by Zhu Wensheng on 2019/7/11.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"
#import "PCPostureModel.h"
NS_ASSUME_NONNULL_BEGIN
@class PCMessageModel;
@interface PCPostureDetailController : YHBaseViewController
//@property (strong, nonatomic) PCPostureModel *info;
//@property (nonatomic, copy) NSString *postureId;
@property (nonatomic, strong) PCMessageModel *model;
@property (nonatomic, assign) BOOL isNews;
@end

NS_ASSUME_NONNULL_END
