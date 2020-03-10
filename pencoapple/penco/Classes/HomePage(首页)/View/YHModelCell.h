//
//  YHModelCell.h
//  penco
//
//  Created by Jay on 17/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YHCellItem;
@class PCPostureCard;
@interface YHModelCell : UITableViewCell
@property (nonatomic, strong) YHCellItem *item;
- (void)postureLoad:(PCPostureCard *)item;
@end

NS_ASSUME_NONNULL_END
