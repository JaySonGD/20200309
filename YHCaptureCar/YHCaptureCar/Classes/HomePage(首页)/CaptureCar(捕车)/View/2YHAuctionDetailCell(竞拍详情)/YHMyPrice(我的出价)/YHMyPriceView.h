//
//  YHMyPriceView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseView.h"

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHMyPriceView : YHBaseView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *myPriceNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *addRangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidNumLabel2;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
