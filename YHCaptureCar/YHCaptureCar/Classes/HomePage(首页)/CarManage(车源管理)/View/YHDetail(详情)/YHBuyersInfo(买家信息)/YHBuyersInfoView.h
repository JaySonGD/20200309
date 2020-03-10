//
//  YHBuyersInfoView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/4/8.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHBuyersInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telePhoneLabel;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
