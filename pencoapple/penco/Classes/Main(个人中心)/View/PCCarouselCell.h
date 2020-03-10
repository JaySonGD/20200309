//
//  PCCarouselCell.h
//  penco
//
//  Created by Jay on 21/10/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YHCellItem;
@class PCPostureCard;

@interface PCCarouselCell : UIView

@property (nonatomic, strong) YHCellItem *item;
- (void)postureLoad:(PCPostureCard *)item;

+ (instancetype)viewWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
