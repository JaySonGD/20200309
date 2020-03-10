//
//  YHFailReasonView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/3/23.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseView.h"

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHFailReasonView : YHBaseView

@property (nonatomic, copy) BtnClickBlock btnClickBlock;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
