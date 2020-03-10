//
//  TTZPlateTextField.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZPlateTextField : UITextField
@property (nonatomic, copy) dispatch_block_t textChange;
@property (nonatomic, assign,getter=isPunctuation) IBInspectable BOOL punctuation;
@property (nonatomic, assign) BOOL isCarNo;
@end
