//
//  YHHelpCheckCell0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/4/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseCell.h"
#import "YHHelpCheckModel0.h"


//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHHelpCheckCell0 : YHBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *isCheckedI;
@property (weak, nonatomic) IBOutlet UILabel *orgNameL;
@property (weak, nonatomic) IBOutlet UILabel *carDescL;
@property (weak, nonatomic) IBOutlet UILabel *bookDateL;
@property (weak, nonatomic) IBOutlet UIButton *applyRefundB;

- (void)refreshUIWithModel:(YHHelpCheckModel0 *)model;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
