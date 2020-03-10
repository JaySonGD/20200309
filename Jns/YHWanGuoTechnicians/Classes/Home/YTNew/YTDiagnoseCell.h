//
//  YTDiagnoseCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YTCResultModel;
@interface YTDiagnoseCell : UITableViewCell
@property (nonatomic, copy)  dispatch_block_t searchBlock;
@property (nonatomic, copy)  dispatch_block_t clearResultBlock;

@property (nonatomic, strong) YTCResultModel *model;
- (CGFloat)rowHeight:(YTCResultModel *)model;
@end

NS_ASSUME_NONNULL_END
