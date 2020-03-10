//
//  YHModiPassWordItemView.h
//  YHCaptureCar
//
//  Created by liusong on 2018/6/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPassWordTextField.h"

typedef NS_ENUM(NSInteger, YHModiPassWordItemViewType) {
    YHModiPassWordItemViewOriginPass,
    YHModiPassWordItemViewNewPass,
    YHModiPassWordItemViewSurePass
};

@interface YHModiPassWordItemView : UIView

@property (nonatomic, weak) YHPassWordTextField *inputField;

@property (nonatomic, assign) YHModiPassWordItemViewType type;

@property (nonatomic, weak) UIViewController *viewController;

@end
