//
//  YHBaseTableViewController.h
//  FTE
//
//  Created by ZWS on 14-9-5.
//  Copyright (c) 2014年 ftsafe. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MBProgressHUD+MJ.h"
@interface YHBaseTableViewController : UITableViewController
@property (strong, nonatomic)NSDictionary *orderInfo;
- (IBAction)endBill:(id)sender;
- (IBAction)popViewController:(id)sender;
- (void)autoLayoutView:(UIView*)view;
- (IBAction)notImplementedViewController:(id)sender;
//无网络
- (void)netError:(NSError*)error;

//单点登录判断
- (bool)sso:(NSString*)retCode;

//登录过期
- (bool)networkServiceCenter:(NSNumber*)retCode;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

//展示返回错误提示
- (void)showErrorInfo:(NSDictionary*)info;

//UITextField 选择输入
- (void)initInput:(UITextField*)field withInputView:(UIPickerView*)inputView target:(nullable id)target action:(nullable SEL)action;
@end