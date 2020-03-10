//
//  SPAlertController.h
//  YHCaptureCar
//
//  Created by Jay on 15/9/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SPAlertActionStyle) {
    SPAlertActionStyleDefault = 0,
    SPAlertActionStyleCancel,
    SPAlertActionStyleDestructive
};

@interface SPAlertController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
- (void)addActionWithTitle:(nullable NSString *)title style:(SPAlertActionStyle)style handler:(void (^ __nullable)(SPAlertController *action))handler;
@end
