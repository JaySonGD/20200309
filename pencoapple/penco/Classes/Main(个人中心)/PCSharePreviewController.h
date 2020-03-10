//
//  PCSharePreviewController.h
//  penco
//
//  Created by Jay on 25/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class YHCellItem;
@interface PCSharePreviewController : YHBaseViewController
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSMutableArray <YHCellItem *>*tableModels;

@end

NS_ASSUME_NONNULL_END
