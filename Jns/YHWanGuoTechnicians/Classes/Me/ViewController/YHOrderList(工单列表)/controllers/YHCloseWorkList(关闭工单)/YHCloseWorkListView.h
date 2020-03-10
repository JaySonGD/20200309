//
//  YHCloseWorkListView.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/8/15.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPlaceholderTextView.h"

//声明一个名为 BtnClickBlock  无返回值，参数为UIButton 类型的block
typedef void (^BtnClickBlock) (UIButton *button);

@interface YHCloseWorkListView : UIView

@property (weak, nonatomic) IBOutlet YHPlaceholderTextView *reasonTF;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
