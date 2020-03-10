//
//  YHBusinessInfoView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHBusinessInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tradingPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *telePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
