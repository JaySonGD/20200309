//
//  PCHomeLeftCell.h
//  penco
//
//  Created by Zhu Wensheng on 2019/11/5.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YHCellItem;
@class PCPostureCard;
@interface PCHomeLeftCell : UICollectionViewCell
@property (nonatomic, strong) YHCellItem *item;
- (void)postureLoad:(PCPostureCard *)item;
@end

NS_ASSUME_NONNULL_END
