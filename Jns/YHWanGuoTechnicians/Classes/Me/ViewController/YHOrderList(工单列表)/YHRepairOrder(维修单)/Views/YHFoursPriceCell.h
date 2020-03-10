//
//  YHFoursPriceCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/4/1.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHFoursPriceCell : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameL;

@property (weak, nonatomic) IBOutlet UITextField *priceTft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceConstraint;

@end

NS_ASSUME_NONNULL_END
