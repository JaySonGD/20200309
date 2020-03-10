//
//  HTPlayCardCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTPlayCardCell : UITableViewCell
@property (nonatomic, strong) NSMutableDictionary *assess_info;
@property (nonatomic,copy) void(^getValueBlock)(NSString *time);
@end

NS_ASSUME_NONNULL_END
