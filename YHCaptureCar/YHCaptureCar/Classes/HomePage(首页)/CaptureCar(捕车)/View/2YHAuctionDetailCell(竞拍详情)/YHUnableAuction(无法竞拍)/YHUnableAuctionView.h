//
//  YHUnableAuctionView.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseView.h"

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHUnableAuctionView :YHBaseView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *payDepositButton;
@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
