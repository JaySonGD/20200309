//
//  YTDetailInfoCell.h
//  YHCaptureCar
//
//  Created by Jay on 25/5/2019.
//  Copyright © 2019 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTDetailInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *action;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameRight;

@property (nonatomic, copy) dispatch_block_t block;
@end

NS_ASSUME_NONNULL_END
