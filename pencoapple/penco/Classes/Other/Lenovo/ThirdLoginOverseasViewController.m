//
//  ThirdLoginOverseasViewController.m
//  LeSyncDemo
//
//  Created by 柏富茯 on 2018/8/16.
//  Copyright © 2018年 winter. All rights reserved.
//

#import "ThirdLoginOverseasViewController.h"

#import "LenovoIDInlandSDK.h"
//生产环境
//static NSString *_Host = @"/https://passport.lenovo.com";
//测试环境
//static NSString *Host = @"https://uss-test.lenovomm.cn/";
//开发环境
//static NSString *Host = @"http://uss.iddev.lenovomm.cn/";

//NS_ENUM(NSInteger,LeInActionParams) {
//    uilogin = 0,  //登录请求.
//    uilogout,  //登出请求
//    newaccount, //注册请求
//    resetpassword, //重置密码请求
//    myaccount, //帐户管理
//};

static NSString *keyOne = @"LENOVOID()*&<MNCXZPKL";
static NSString *keyTwo = @"LENOVOID[]$!>WEAGHVBP";
@interface ThirdLoginOverseasViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *loginWebView;
@property (nonatomic, copy) NSString *key;

@end

@implementation ThirdLoginOverseasViewController
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
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.loginWebView loadRequest:request];
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
    NSString *platform;
    [self needForDefaultUserAgent];
    if ([self.loginMethod isEqualToString:@"Google"]) {
        platform = @"google";
        [self needForGoogleWeb];
    }else if ([self.loginMethod isEqualToString:@"Facebook"]) {
        platform = @"facebook";
    }
    
    static NSString *Host = @"https://passport.lenovo.com/";
    //测试环境
    //    static NSString *Host = @"https://uss-test.lenovomm.cn/";
    
    NSString *url = [NSString stringWithFormat:@"%@wauthen5/gateway?lenovoid.action=uilogin&lenovoid.realm=moc.lenovo.com&lenovoid.cb=http://www.baidu.com&lenovoid.sdk=ios&lenovoid.thirdname=%@",Host,platform];
    return url;
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    NSRange tgtValueRange = [urlString rangeOfString:@"lenovoid.wutgt="];
    NSRange nameRange = [urlString rangeOfString:@"lenovoid.username="];
    NSRange userTTLRange = [urlString rangeOfString:@"lenovoid.ttl="];
    NSRange stRange = [urlString rangeOfString:@"lenovoid.wust="];
    NSRange timestampRange = [urlString rangeOfString:@"lenovoid.nowstate"];
    NSRange userIDRange = [urlString rangeOfString:@"lenovoid.uid="];
    
    if (tgtValueRange.location != NSNotFound && nameRange.location != NSNotFound && userTTLRange.location != NSNotFound && stRange.location != NSNotFound && timestampRange.location != NSNotFound && userIDRange.location != NSNotFound) {
        NSRange urlRange = [urlString rangeOfString:@"?"];
        NSString *paramsString = [urlString substringFromIndex:urlRange.location + 1];
        
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        NSString *tgtValue;
        NSString *name;
        NSString *ttl;
        NSString *st;
        NSString *time;
        NSString *userID;
        for (NSString *str in paramsArray) {
            
            NSRange valueRange = [str rangeOfString:@"lenovoid.wutgt="];
            if (valueRange.location != NSNotFound) {
                tgtValue = [str substringFromIndex:valueRange.location + valueRange.length];
            }
            
            NSRange nameRange = [str rangeOfString:@"lenovoid.username="];
            if (nameRange.location != NSNotFound) {
                name = [str substringFromIndex:nameRange.location + nameRange.length];
            }
            
            NSRange idRange = [str rangeOfString:@"lenovoid.ttl="];
            if (idRange.location != NSNotFound) {
                ttl = [str substringFromIndex:idRange.location + idRange.length];
            }
            
            NSRange stValueRange = [str rangeOfString:@"lenovoid.wust="];
            if (stValueRange.location != NSNotFound) {
                st = [str substringFromIndex:stValueRange.location + stValueRange.length];
            }
            
            NSRange timestampValueRange = [str rangeOfString:@"lenovoid.nowstate="];
            if (timestampValueRange.location != NSNotFound) {
                time = [str substringFromIndex:timestampValueRange.location + timestampValueRange.length];
                self.key = [self obtainTimecamp:time]?keyOne:keyTwo;
            }
            
            NSRange useridRange = [str rangeOfString:@"lenovoid.uid="];
            if (useridRange.location != NSNotFound) {
                userID = [str substringFromIndex:useridRange.location + useridRange.length];
            }
            
        }
        if (nil != st) {
            name = [self LeInalogorithmForThirdLogin:name withKey:self.key];
            tgtValue = [self LeInalogorithmForThirdLogin:tgtValue withKey:self.key];
            userID = [self LeInalogorithmForThirdLogin:userID withKey:self.key];
            ttl = [self LeInalogorithmForThirdLogin:ttl withKey:self.key];
            NSDictionary *dict = @{@"st":st,@"name":name,@"tgtValue":tgtValue,@"userID":userID,@"ttl":ttl,@"key":self.key};
            [LenovoIDInlandSDK leInlandbindAndLoginWithWebNavController:self.navigationController andLoginString:dict];
            //大拿to do....
            //YHLog(@"登录成功");
        }
        
        
        
        
        return NO;
    }
    return YES;
}

- (BOOL)obtainTimecamp:(NSString *)time {
    long long keyType = [time longLongValue];
    NSInteger number = 0;
    NSInteger total = 0;
    for (int i = 0; i <time.length; i++) {
        number = keyType%10;
        keyType = keyType/10;
        total += number;
    }
    BOOL type = total%2;
    return type;
}

//解密
- (NSString *)LeInalogorithmForThirdLogin:(NSString *)encryption withKey:(NSString *)key{
    
    NSData *encryptionData = [[NSData alloc]initWithBase64EncodedString:encryption options:0];
    Byte *encryptionByte = (Byte *)[encryptionData bytes];
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *keybyte = (Byte *)[keyData bytes];
    
    for (int i = 0; i < encryptionData.length; i++) {
        for (int j = 0; j < keyData.length; j++) {
            encryptionByte[i] = encryptionByte[i]^keybyte[j];
        }
    }
    
    NSData *adata = [[NSData alloc] initWithBytes:encryptionByte length:encryptionData.length];
    NSString *str =  [[NSString alloc]initWithData:adata encoding:NSUTF8StringEncoding];
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
