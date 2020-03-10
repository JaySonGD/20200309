//
//  YHUpCaptureCarView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHUpCaptureCarView : UIView

@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
