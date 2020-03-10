//
//  YHStudyVersionLoginController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/8/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStudyVersionLoginController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"

@interface YHStudyVersionLoginController () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *loginWebView;

@end

@implementation YHStudyVersionLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    configuration.userContentController = userContentController;
    // 登录回调
    [userContentController addScriptMessageHandler:self name:@"loginCallBack"];
    // 获取设备id
    [userContentController addScriptMessageHandler:self name:@"getAppUUId"];
    
     [userContentController addScriptMessageHandler:self name:@"studyTokenInvalid"];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;

    WKWebView *loginWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.loginWebView = loginWebView;
    loginWebView.UIDelegate = self;
    loginWebView.navigationDelegate = self;
    [self.view addSubview:loginWebView];
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    CGFloat bottomMargin = iPhoneX ? 34 : 0;
    
    [loginWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    
    [loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.200/eduWeb/index.html"]]];
    [loginWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"%@",change);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.loginWebView.configuration.userContentController removeScriptMessageHandlerForName:@"loginCallBack"];
    [self.loginWebView.configuration.userContentController removeScriptMessageHandlerForName:@"getAppUUId"];
    [self.loginWebView.configuration.userContentController removeScriptMessageHandlerForName:@"studyTokenInvalid"];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    // 登录回调
    if ([message.name isEqualToString:@"loginCallBack"]) {
        [YHTools setAccessToken:message.body[@"token"]];
        [YHTools setName:message.body[@"username"]];
        [YHTools setPassword:message.body[@"password"]];
        
        [self autoLogin:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    // 获取设备id
    if ([message.name isEqualToString:@"getAppUUId"]) {
        // 设备UUID
        NSString *sciptStr = [NSString stringWithFormat:@"getUUId(\"%@\")",[YHTools getUniqueDeviceIdentifierAsString]];
        [self.loginWebView evaluateJavaScript:sciptStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }
    // token失效
    if ([message.name isEqualToString:@"studyTokenInvalid"]) {
        
    }
}

- (void)autoLogin:(NSString*)code{
    
    //用户登录过
    if ([YHTools getAccessToken]) {
        __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] userInfo:[YHTools getAccessToken]
                                                       onComplete:^(NSDictionary *info) {
                                                        
                                                           [MBProgressHUD hideHUDForView:self.view];
                                                           if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                                                               [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:[info mutableCopy]];

                                                           }else{
                                                               if(![weakSelf networkServiceCenter:info[@"code"]]){
                                                                   YHLogERROR(@"");
                                                               }
                                                           }
                                                       } onError:^(NSError *error) {
                                                           [MBProgressHUD hideHUDForView:self.view];
                                                       }];
        
    }
}
@end
