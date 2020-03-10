//
//  OilCell.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/6/25.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OilCell : UITableViewCell

@property (nonatomic , strong) NSArray *arrModel;

@property (nonatomic , copy) void (^blockPay)(NSInteger idx);

@end

NS_ASSUME_NONNULL_END
