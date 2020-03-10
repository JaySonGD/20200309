//
//  YHMapSearchCell.h
//  YHCaptureCar
//
//  Created by mwf on 2018/6/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHReservationModel.h"

@interface YHMapSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

- (void)refreshUIWithModel:(YHReservationModel *)model;

@end
