//
//  YHLoginViewController.h
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/8.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"
#import "YHWebViewController.h"
@protocol YHLoginDelegate <NSObject>

@optional
- (void)loginOnComplete:(NSDictionary*)loginInfo;

@end
@interface YHLoginViewController : YHBaseViewController

@property (nonatomic, weak)id<YHLoginDelegate> delegate;
@property (nonatomic, weak)YHWebViewController *webController;
@property (weak, nonatomic)NSDictionary *corpInfo;
@property (nonatomic) BOOL fromWeb;//从web跳转到登录
@property (nonatomic) BOOL fromSSO;//从单点
@property (nonatomic)BOOL isRegister;
@end
