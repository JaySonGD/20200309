//
//  YTPriceCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPointsDealModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTPriceCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (nonatomic, strong) YTPriceModel *model;
@end

NS_ASSUME_NONNULL_END
