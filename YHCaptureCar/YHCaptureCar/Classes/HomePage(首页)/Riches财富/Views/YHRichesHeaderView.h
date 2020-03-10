//
//  YHRichesHeaderView.h
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRichesHeaderView : UIView

@property (nonatomic,copy)void(^applyCashBtnClickEvent)(void);

- (NSString *)getAccountBalance;
- (void)setAccountBalance:(NSString *)balanceStr;

- (void)setGetAccountBalancePremptText:(NSString *)text;

- (void)setApplyCashBtnEnable:(BOOL)isEnable;

@end
