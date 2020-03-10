//
//  YHWebViewController.h
//  FTE
//
//  Created by ZWS on 14-9-10.
//  Copyright (c) 2014年 ftsafe. All rights reserved.
//

#import "YHWebViewController.h"
#import "YHBaseViewController.h"
@interface YHWebViewController : YHBaseViewController
@property (nonatomic, strong)NSString *urlStr;
@property (nonatomic)BOOL barHidden;
- (void)loadWebPageWithString:(NSString*)urlString;
- (void)pushVin:(NSString*)vin;
- (void)pushVin:(NSString*)vin
          image:(NSString *)base64String;
// H5控制是否显示或者隐藏导航 @"0"显示导航 @"1"不显示导航  @"" 未知，以代码控制
- (NSString *)naviShowState;

@property (weak, nonatomic)  IBOutlet UIWebView *webView;

@end
