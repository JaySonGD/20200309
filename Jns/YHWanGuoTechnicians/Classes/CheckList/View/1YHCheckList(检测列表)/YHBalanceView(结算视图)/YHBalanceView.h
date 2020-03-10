//
//  YHBalanceView.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHBalanceView : UIView

@property (nonatomic, copy) BtnClickBlock btnClickBlock;
@property (weak, nonatomic) IBOutlet UITextField *balanceTF;
@property (weak, nonatomic) IBOutlet UIView *smallBalanceView;

@end
