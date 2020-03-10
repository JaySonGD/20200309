//
//  YTReportPromptCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTReportPromptCell : UITableViewCell

- (CGFloat)rowHeight:(NSDictionary *)model;

@property (nonatomic, strong) NSDictionary *model;

@property (nonatomic, copy) dispatch_block_t closeBlock;
@property (nonatomic, copy) dispatch_block_t submitBlock;

@end

NS_ASSUME_NONNULL_END
