//
//  YHRepairPartTableViewCell.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/19.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseRepairTableViewCell.h"


@interface YHRepairPartTableViewCell : YHBaseRepairTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deletePartsBtn;

@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;

@property (weak, nonatomic) IBOutlet UILabel *categoryContentL;

@property (weak, nonatomic) IBOutlet UILabel *categoryL;

@property (weak, nonatomic) IBOutlet UIView *seprateLineV;

@property (weak, nonatomic) IBOutlet UITextField *unitTft;
@property (weak, nonatomic) IBOutlet UITextField *amountTft;
@property (weak, nonatomic) IBOutlet UITextField *unitPriceTft;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentRightMargin;
@property (weak, nonatomic) IBOutlet UILabel *categaryNameL;
@property (weak, nonatomic) IBOutlet UITextField *categaryTft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *presentViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandViewH;
@property (weak, nonatomic) IBOutlet UITextField *brandTF;
@property (weak, nonatomic) IBOutlet UIButton *prsentBtn;
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oilNameHeight;
@property (weak, nonatomic) IBOutlet UIView *oilView;
@property (weak, nonatomic) IBOutlet UIView *oilContainView;

@property (weak, nonatomic) IBOutlet UIButton *oilDeployTitleL;
@property (weak, nonatomic) IBOutlet UIView *giveVIew;

@end
