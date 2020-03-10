//
//  YHStudyVersionWebController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/8/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHStudyVersionWebController.h"
#import "YHStudyVersionLoginController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"

@interface YHStudyVersionWebController () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,weak) WKWebView *webView;

@end

@implementation YHStudyVersionWebController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    configuration.userContentController = userContentController;
    // token失效
    [userContentController addScriptMessageHandler:self name:@"studyTokenInvalid"];
    // 跳转到下载页
    [userContentController addScriptMessageHandler:self name:@"uploadImg"];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView = webView;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    CGFloat bottomMargin = iPhoneX ? 34 : 0;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(bottomMargin));
    }];
    
//    http://192.168.1.4/test/location.html
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.200/eduWeb/index.html"]]];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
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
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"studyTokenInvalid"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"uploadImg"];
    
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
   
    // token失效
    if ([message.name isEqualToString:@"studyTokenInvalid"]) {
        
//        YHStudyVersionLoginController *studyVersionloginVC = [[YHStudyVersionLoginController alloc] init];
//        [self presentViewController:studyVersionloginVC animated:YES completion:nil];
    }
    
    // 跳转到下载页
    if ([message.name isEqualToString:@"uploadImg"]) {
        
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"YHUploading" bundle:nil] instantiateViewControllerWithIdentifier:@"YHUploadingController"] animated:YES];
        
    }
}
@end
