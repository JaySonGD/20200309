//
//  SHViewController.m
//  App
//
//  Created by Jay on 21/2/2020.
//  Copyright © 2020 tianfutaijiu. All rights reserved.
//

#import "SHViewController.h"

#import <WebKit/WebKit.h>

@interface SHViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong) WKWebView *wkWebView;  //  WKWebView
@property (nonatomic,strong) UIProgressView *progress;  //进度条
@property (nonatomic, copy) NSString *url;

@end

@implementation SHViewController
#pragma mark lazy load
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        // 设置WKWebView基本配置信息
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        configuration.selectionGranularity = YES;
        if (@available(iOS 9.0, *)) {
            configuration.requiresUserActionForMediaPlayback = NO;
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackRequiresUserAction = NO;
        }//把手动播放设置NO ios(8.0, 9.0)
        if (@available(iOS 9.0, *)) {
            configuration.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackAllowsAirPlay = YES;
        }//允许播放，ios(8.0, 9.0)
        
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkWebView.allowsBackForwardNavigationGestures = YES;/**这一步是，开启侧滑返回上一历史界面**/
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.scrollView.backgroundColor = [UIColor clearColor];
        _wkWebView.opaque = NO;
        // 设置代理
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 添加进度监听
        [_wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        [_wkWebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        
    }
    return _wkWebView;
}


- (UIProgressView* )progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectZero];
        _progress.trackTintColor = [UIColor clearColor];
        _progress.progressTintColor = self.navigationController.navigationBar.tintColor;//[UIColor colorWithRed:0.15 green:0.49 blue:0.96 alpha:1.0];
    }
    return _progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.prompt = self.url;
    [self setupUI];
    
    NSDictionary *parm = [self getUrlParameterWithUrl:[NSURL URLWithString:self.url]];
    
    
    if (parm[@"page"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"page=%@&h=%@&table=%@&type=%@",parm[@"page"],parm[@"h"],parm[@"table"],parm[@"type"]];
    }
    else{
        self.navigationItem.title = [NSString stringWithFormat:@"type=%@",parm[@"type"]];
    }
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    
}


#pragma mark private Methods
- (void)setupUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    [self.view addSubview:self.wkWebView];
    self.wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                ]];
    
    
    
    
    
    [self.navigationController.view addSubview:self.progress];
    [self.navigationController.view bringSubviewToFront:self.progress];
    self.progress.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController.view addConstraints:@[
                                                     
                                                     [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.progress.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                                     [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],//-0.5
                                                     [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.progress.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                                     [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:2.0]
                                                     
                                                     ]];
    
    
    
    
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.wkWebView) {
        
        NSLog(@"网页加载进度 = %f",self.wkWebView.estimatedProgress);
        self.progress.progress = self.wkWebView.estimatedProgress;
        if (self.wkWebView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progress.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == self.wkWebView){
        
        self.navigationItem.title = self.wkWebView.URL.absoluteString;
        self.navigationItem.prompt = self.wkWebView.URL.absoluteString;
        
        NSDictionary *parm = [self getUrlParameterWithUrl:self.wkWebView.URL];

        if (parm[@"page"]) {
            self.navigationItem.title = [NSString stringWithFormat:@"page=%@&h=%@&table=%@&type=%@",parm[@"page"],parm[@"h"],parm[@"table"],parm[@"type"]];
        }
        else{
            self.navigationItem.title = [NSString stringWithFormat:@"type=%@",parm[@"type"]];
        }

    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (NSDictionary *)getUrlParameterWithUrl:(NSURL *)url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

#pragma mark WKNavigationDelegate

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
  
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
// 返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}


//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}


#pragma mark Dealloc
- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
    
    [_wkWebView stopLoading];
    _wkWebView.UIDelegate = nil;
    _wkWebView.navigationDelegate = nil;
    [_progress removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
