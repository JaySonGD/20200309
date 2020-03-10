//
//  PCShareController.h
//  penco
//
//  Created by Jay on 12/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
//@class YHCellItem;
@interface PCShareController : YHBaseViewController

//@property (nonatomic, strong) NSMutableArray <YHCellItem *>*tableModels;
@property (nonatomic, copy) void(^choseImageBlock)(UIImage *image);


@end

NS_ASSUME_NONNULL_END
