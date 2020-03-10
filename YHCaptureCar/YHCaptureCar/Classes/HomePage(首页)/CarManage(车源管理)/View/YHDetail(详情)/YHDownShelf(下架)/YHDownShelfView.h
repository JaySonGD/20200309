//
//  YHDownShelfView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>


//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHDownShelfView : UIView

@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *soldBtn;
@property (weak, nonatomic) IBOutlet UIButton *downShelfBtn;
@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
