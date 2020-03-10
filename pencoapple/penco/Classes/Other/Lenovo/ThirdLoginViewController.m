//
//  ThirdLoginViewController.m
//  LeSyncDemo
//
//  Created by 柏富茯 on 2018/5/8.
//  Copyright © 2018年 winter. All rights reserved.
//

#import "ThirdLoginViewController.h"
#import "LenovoIDInlandSDK.h"
#import "YHCommon.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface ThirdLoginViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *loginWebView;
@property (nonatomic,copy)NSString *urlString;

@end

@implementation ThirdLoginViewController
- (UIWebView *)loginWebView {
    if (_loginWebView == nil) {
        CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
        CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
        _loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - rectOfNavigationbar.size.height - rectOfStatusbar.size.height)];
        [self.view addSubview:_loginWebView];
    }
    return _loginWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.loginMethod;
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:[self loadRequest]];
    self.urlString = [self loadRequest];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.loginWebView loadRequest:request];
    
    //隐藏登录界面的加载菊花
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
    
    //QQ一键登录，Safari回调起APP接收到URL发来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getQQRedirectUrl:) name:@"LenovoIDQQWebLoginNotification" object:nil];
}

- (void)getQQRedirectUrl:(NSNotification *)noti {
    NSString *url = [noti object];
    YHLog(@"%@",url);
    
    NSString *urlString = url;
    NSRange openappValueRange = [urlString rangeOfString:@"com.lenovo.lsf.sdk.test.openapp.lenovoid://"];
    
    if (openappValueRange.location != NSNotFound) {
        
        [self loginWithUrlString:urlString];
        
    }
    
    
}

//Google在中国限制，必须添加如下代码
- (void)needForGoogleWeb {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)needForDefaultUserAgent {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12H143", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
}


- (NSString *)loadRequest {
    NSString *Host1 = @"https://passport.lenovo.com/";
    //测试环境
    //    NSString *Host1 = @"https://uss-test.lenovomm.cn/";
    
    
    NSString *platform;
    NSString *host;
    if ([self.loginMethod isEqualToString:NSLocalizedString(@"com_lenovo_lsf_sina_login", nil)]) {
        platform = @"sina";
        host = [NSString stringWithFormat:@"%@wauthen/oauth?",Host1];
        [self needForDefaultUserAgent];
    }else if ([self.loginMethod isEqualToString:NSLocalizedString(@"com_lenovo_lsf_qq_login", nil)]) {
        platform = @"qqsns";
        host = [NSString stringWithFormat:@"%@wauthen/oauth?",Host1];
        [self needForDefaultUserAgent];
    }else if ([self.loginMethod isEqualToString:@"Google"]) {
        platform = @"google";
        host = [NSString stringWithFormat:@"%@wauthen5/oauth?",Host1];
        [self needForGoogleWeb];
    }else {
        platform = @"facebook";
        host = [NSString stringWithFormat:@"%@wauthen5/oauth?",Host1];
        [self needForDefaultUserAgent];
    }
    
    
    //    NSString *url = [NSString stringWithFormat:@"%@lenovoid.action=%@&lenovoid.realm=%@&lenovoid.cb=%@&lenovoid.sdk=ios&lenovoid.thirdname=%@",host,action,realm,cb,platform];
    
    NSString *url = [NSString stringWithFormat:@"%@source=android:com.lenovo.lsf.sdk.test-4.5&dit=imei&edi=5C39FA9E-4590-4A56-9665-B3C3C574B7D0&dc=unknown&dv=motorola&dm=XT1789-05&os=android&ov=8.0.0&cn=com.lenovo.lsf.sdk.test&cv=4.5&d=small&n=%@&redirect.uri=com.lenovo.lsf.sdk.test.openapp.lenovoid&ctx=999999&lang=zh-CN",host,platform];
    return url;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    NSRange openappValueRange = [urlString rangeOfString:@"com.lenovo.lsf.sdk.test.openapp.lenovoid://"];
    
    if (openappValueRange.location != NSNotFound) {
        
        [self loginWithUrlString:urlString];
        
        return NO;
    }
    return YES;
}

- (void)loginWithUrlString:(NSString *)urlString {
    NSString *subString = [urlString substringFromIndex:43];
    YHLog(@"%@",subString);
    NSString *utfString = [subString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YHLog(@"%@",utfString);
    NSArray *array = [utfString componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    for (NSString *str in array) {
        NSArray *dictArr = [str componentsSeparatedByString:@"="];
        [mDict setValue:dictArr[1] forKey:dictArr[0]];
    }
    YHLog(@"%@",mDict);
    if ([[mDict objectForKey:@"errors"] isEqualToString:@"USS-0191"]) {//三方登录超时
        [self alertTitle:NSLocalizedString(@"com_lenovo_lsf_error_uss_0191", nil) content:nil];
    }else {
        NSString *platform  ;
        if ([self.loginMethod isEqualToString:NSLocalizedString(@"com_lenovo_lsf_sina_login", nil)]) {
            platform = @"sina";
        }else if ([self.loginMethod isEqualToString:NSLocalizedString(@"com_lenovo_lsf_qq_login", nil)]) {
            platform = @"qqsns";
        }
        
        if ([[mDict allKeys] containsObject:@"accesstoken"]) {
            [LenovoIDInlandSDK leInlandLoginWithHalfWithAppkey:[mDict objectForKey:@"appkey"] accessToken:[mDict objectForKey:@"accesstoken"] thirdPartyName:platform openId:nil success:^(BOOL judge) {
                //大拿to do....
                //YHLog(@"登录成功");
            } error:^(NSDictionary *errorDic) {
                YHLog(@"%@",errorDic);
            }];
            
        }
        else {
            
            [LenovoIDInlandSDK leInlandLoginWithWebNavController:self.navigationController andAccount:[mDict objectForKey:@"un"] tgt:[mDict objectForKey:@"lpsutgt"]];
        }
    }
    
    
}

- (void)alertTitle:(NSString *)title content:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2];
}

- (void)dismiss:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

