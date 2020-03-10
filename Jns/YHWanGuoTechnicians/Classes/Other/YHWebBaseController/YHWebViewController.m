//
//  YHWebViewController.m
//  FTE
//
//  Created by ZWS on 14-9-10.
//  Copyright (c) 2014年 ftsafe. All rights reserved.
//

#import "YHWebViewController.h"
#import "UIAlertView+Block.h"
#import "YHCommon.h"
#import <MJExtension.h>
@interface YHWebViewController ()
@property (weak, nonatomic)  IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic)  IBOutlet UIWebView *webView;
@end

@implementation YHWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.urlStr == nil) {
        self.urlStr = @"";
    }
    self.webView.scrollView.bounces = NO;
    self.webView.keyboardDisplayRequiresUserAction = NO;
    [self loadWebPageWithString:self.urlStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_barHidden animated:YES];
    //    [self naviShowDoing];

}

- (void)naviShowDoing{
    NSString *showNaviBarState = [self naviShowState];
    if ([showNaviBarState isEqualToString:@""]) {
        [self.navigationController setNavigationBarHidden:_barHidden animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:showNaviBarState.boolValue animated:YES];
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


-(NSString *)URLEncodedString:(NSString *)str{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
- (void)pushVin:(NSString*)vin{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ios_vin('%@');",vin]];
}

- (void)pushVin:(NSString*)vin
          image:(NSString *)base64String{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ios_vin('%@','%@');",vin,base64String]];
}

- (void)vinCallback:(NSString*)vin{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"vinHandle('%@');",vin]];
    
//    NSString *json = [@{
//                        @"status" : @"ios",// ios或者android
//                        @"jnsAppStep" : @"vin",
//                        @"vin" : vin,
//                        } mj_JSONString];
//     [self appToH5:json];
}

- (void)jumpScanVinCallback:(NSString*)vin{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jumpScanVin('%@');",vin]];
}

- (void)toH5:(NSDictionary *)obj{
    NSMutableDictionary *par = obj.mutableCopy;
    par[@"jnsAppStatus"] = @"ios";
        NSString *json = [par mj_JSONString];
    [self appToH5:json];
}

- (void)appToH5:(NSString*)json{
    json = [self URLEncodedString:json];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"appToH5('%@');",json]];
}

- (void)pushLocationLongitude:(NSString *)longitude
                     latitude:(NSString *)latitude
                        state:(BOOL)state{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"longitudeAndLatitude('%@','%@','%@');",state? @"success":@"fail",longitude,latitude]];
}

- (NSString*)naviShowState{
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"\
    //     function ios_is_navi(){\
    //     return '0';\
    //     }\
    //     "];
    return  [self.webView stringByEvaluatingJavaScriptFromString:@"ios_is_navi();"];
}

#pragma mark - selector

- (IBAction)popViewController:(id)sender{
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - OnlienView

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView setHidden:NO];
    [_activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicatorView setHidden:YES];
    [_activityIndicatorView stopAnimating];

    //    [self naviShowDoing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    YHLog(@"%@", error);
    if (error.code == -999) {//忽略 一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
        return;
    }
    [_activityIndicatorView setHidden:YES];
    [_activityIndicatorView stopAnimating];
    [self popViewController:nil];
}

- (IBAction)outWebAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// Objective-C语言
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc"])
            {
                
                /*调用本地函数1*/
                NSLog(@"doFunc");
                
            }
        }
        else if(2 == [arrFucnameAndParameter count])
        {
            //有参数的
            if([funcStr isEqualToString:@"doFunc"] &&
               [arrFucnameAndParameter objectAtIndex:1])
            {
                /*调用本地函数1*/
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"back"]) {
                    [self outWebAction:nil];
                }
            }
        }
        return NO;
    };
    return YES;
}
//    // Javascript 语言
//    (function(global){
//        var notifyInvoke = function(method, args){
//            if (global.callbacks[method] && typeof global.callbacks[method] == 'function') {
//                global.callbacks[method].apply(global, args);
//            } else {
//                throw new Error('未实现');
//            }
//        };
//
//        global.iosNotify = notifyInvoke;
//        global.callbacks = {};
//
//        /* 注册一个方法 */
//        global.callbacks["methodIdentifier"] = function(){};
//    })(window);

@end
