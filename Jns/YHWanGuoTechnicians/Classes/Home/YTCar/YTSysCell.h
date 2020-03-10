//
//  YTSysCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTWarranty;
@interface YTSysCell : UITableViewCell
@property (nonatomic, strong) YTWarranty *model;
@property (nonatomic, copy) dispatch_block_t reloadBlock;
@end

NS_ASSUME_NONNULL_END
