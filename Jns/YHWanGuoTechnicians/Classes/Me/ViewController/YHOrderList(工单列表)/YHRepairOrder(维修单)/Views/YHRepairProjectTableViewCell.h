//
//  YHRepairProjectTableViewCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"

@interface YHRepairProjectTableViewCell : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UIView *seprateLineV;

@property (weak, nonatomic) IBOutlet UITextField *unitPriceTft;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *repairNameL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *presentViewH;
@property (weak, nonatomic) IBOutlet UIButton *prsentBtn;
@property (weak, nonatomic) IBOutlet UIView *giveView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *botLayout;

@end
