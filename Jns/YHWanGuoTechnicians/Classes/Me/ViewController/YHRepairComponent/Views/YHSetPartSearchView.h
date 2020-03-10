//
//  YHSetPartSearchView.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHSetPartSearchViewDelegate <NSObject>

@required

- (void)setPartSearchViewTextFieldStartEdit:(NSString *)text;

@end

@interface YHSetPartSearchView : UIView

@property (nonatomic, copy) void(^searchBtnClickBlock)(NSString *searchStr);

@property (nonatomic, weak) id <YHSetPartSearchViewDelegate>delegate;

@property (nonatomic, weak) UITextField *inputTf;

/**
 * 设置textField的内容
 */
- (void)setTextFieldText:(NSString *)text;
- (void)setTextFieldPlaceHolder:(NSString *)placeHolder;
- (void)setSearchBtnIsHides:(BOOL)isHide;

@end
