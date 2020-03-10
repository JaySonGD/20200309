//
//  LePreferenceForUI.h
//  LeSyncSDK
//
//  Created by winter on 16/4/13.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LeInTitleIndentifier){
    //设置
    LeInSettingTitleIndentifier = 0,
    //登录
    LeInLoginTitleIndentifier,
    //注册
    LeInRegisterTitleIndentifier,
    //修改密码
    LeInModifyPasswordTitleIndentifier,
    //找回密码
    LeInRetrievePasswordTitleIndentifier,
    //重置密码
    LeInResetPasswordTitleIndentifier,
};

@interface LeInPreferenceForUI : NSObject

@property (nonatomic, strong) UIColor *navigationColor;//导航栏文字颜色，默认black
@property (nonatomic, strong) UIFont *navigationFont;//导航栏字体大小，默认system20
@property (nonatomic, strong) UIColor *navigationBackgroundColor;//导航栏背景色
@property (nonatomic, strong) UIColor *backgroundColor;//背景色
@property (nonatomic, assign) UIInterfaceOrientationMask faceOrientation;//sdk内方向,默认为UIInterfaceOrientationMaskAll

+ (LeInPreferenceForUI *)singleton;

/**
 *  设置导航栏文字
 *
 *  @param title       导航栏文字
 *  @param indentifier SDK内的界面标示
 */
- (void)configNavigationTitle:(NSString *)title withIndentifier:(LeInTitleIndentifier)indentifier;


@end
