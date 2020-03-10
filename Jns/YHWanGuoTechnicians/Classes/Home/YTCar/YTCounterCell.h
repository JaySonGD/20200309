//
//  YTCounterCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/4/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTPayMode;
@interface YTCounterCell : UITableViewCell
@property (nonatomic, strong)  YTPayMode*model;
- (CGFloat)rowHeight:(YTPayMode *)model;

@property (nonatomic, copy) void(^selectBlock)(YTPayMode*);
@property (nonatomic, copy) dispatch_block_t topupBlock;

@end

NS_ASSUME_NONNULL_END
