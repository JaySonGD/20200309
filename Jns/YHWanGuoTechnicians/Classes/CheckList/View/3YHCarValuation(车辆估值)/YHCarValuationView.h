//
//  YHCarValuationView.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnClickBlock) (UIButton *button);

@interface YHCarValuationView : UIView

@property (weak, nonatomic) IBOutlet UITextField *pushPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property(nonatomic, copy) BtnClickBlock btnClickBlock;

@end
