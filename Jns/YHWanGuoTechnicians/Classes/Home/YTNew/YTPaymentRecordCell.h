//
//  YTPaymentRecordCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTPaymentRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *payDAmount;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

NS_ASSUME_NONNULL_END
