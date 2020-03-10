//
//  YHBaseViewController.h
//  FTE
//
//  Created by ZWS on 14-9-4.
//  Copyright (c) 2014年 ftsafe. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YHBaseViewController : UIViewController
@property (nonatomic)BOOL isHideLeftButton;//是否隐藏默认返回按钮
- (IBAction)popViewController:(id _Nullable )sender;
- (void)autoLayoutView:(UIView*_Nonnull)view;
- (IBAction)notImplementedViewController:(id _Nullable )sender;

//无网络
- (void)netError:(NSError*_Nonnull)error;

//单点登录判断
- (bool)sso:(NSString*_Nonnull)retCode;

//登录过期
- (bool)networkServiceCenter:(NSNumber*_Nonnull)retCode;


//展示返回错误提示
- (void)showErrorInfo:(NSDictionary*_Nonnull)info;

//UITextField 选择输入
- (void)initInput:(UITextField*_Nonnull)field withInputView:(UIPickerView*_Nonnull)inputView target:(nullable id)target action:(nullable SEL)action;
@end
