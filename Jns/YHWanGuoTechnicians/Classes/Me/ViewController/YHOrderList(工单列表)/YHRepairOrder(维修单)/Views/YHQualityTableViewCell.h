//
//  YHQualityTableViewCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"

@interface YHQualityTableViewCell : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameL;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UITextField *amountL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *requireSideShowBtn;

@end
