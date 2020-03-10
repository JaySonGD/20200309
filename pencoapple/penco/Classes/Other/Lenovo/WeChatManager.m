//
//  WeChatManager.m
//  LeSyncDemo
//
//  Created by 柏富茯 on 2018/8/15.
//  Copyright © 2018年 winter. All rights reserved.
//

#import "WeChatManager.h"
#import "Constant.h"
#import "LenovoIDInlandSDK.h"
#import "YHCommon.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@implementation WeChatManager
+ (WeChatManager*) singleton
{
    static WeChatManager* instance = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

//微信登录
- (void)loginByWechat {
    // 进行微信授权
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123";
        [WXApi sendReq:req];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
    }else {
        [self alertTitle:@"请安装微信客户端" content:nil];
        //隐藏登录界面的加载菊花
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
    }
}

#pragma mark - 三方登录回调
// 微信登录成功或者失败回调
- (void) onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]){
        // 微信登录的回调
        if (resp.errCode == 0) {  //成功。
            SendAuthResp *temp = (SendAuthResp *)resp;
            NSString *code = temp.code.length != 0 ? temp.code : @"";
            [self sendRequest:code];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showToastNotification" object:nil];
        }else{ //失败
            //隐藏登录界面的加载菊花
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
        }
    }
}

//通过code获取access_token
- (void)sendRequest:(NSString *)code {
    NSString *APPID = kWXAppID;
    NSString *SECRET = @"e7637c7ec5e15f0ef2723b935967bb3b";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APPID,SECRET,code]];
    if (nil != url) {
        __block NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                                initWithURL:url
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0 ];
        [request setHTTPMethod:@"GET"];
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (data != nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dic objectForKey:@"errcode"] == nil) {
                    NSString *accessToken = [dic objectForKey:@"access_token"];
                    NSString *openId = [dic objectForKey:@"openid"];
                    // 微信登录
                    [LenovoIDInlandSDK leInlandLoginWithHalfWithAppkey:kWXAppID accessToken:accessToken thirdPartyName:@"weixin" openId:openId success:^(BOOL judge) {
                        //大拿to do....
                        YHLog(@"登录成功");
                    } error:^(NSDictionary *errorDic) {
                        //隐藏登录界面的加载菊花
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
                    }];
                    
                }
                
            }else {
                //隐藏登录界面的加载菊花
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
            }
            if (connectionError != nil) {
                //隐藏登录界面的加载菊花
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hidToastNotification" object:nil];
            }
        }];
    }
}

//获取昵称
//- (void)getWechatNickNameByAccessToken:(NSString *)accessToken OpengID:(NSString *)openId {
//
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId]];
//    if (nil != url) {
//        __block NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
//                                                initWithURL:url
//                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                timeoutInterval:60.0 ];
//        [request setHTTPMethod:@"GET"];
//
//        NSOperationQueue *queue = [NSOperationQueue mainQueue];
//        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//            if (data != nil) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                if ([dic objectForKey:@"errcode"] == nil) {
//                    [LenovoIDInlandSDK leInlandWeChatLoginWithHalfWithAppkey:@"wxdb414cecf518dfce" accessToken:accessToken openId:openId nickName:[dic objectForKey:@"nickname"] error:^(NSDictionary *errorDic) {
//                        YHLog(@"%@",errorDic);
//                    }];
//                }
//
//            }
//            if (connectionError != nil) {
//                YHLog(@"%@",connectionError);
//            }
//        }];
//    }
//
//}


#pragma mark - 弹框
- (void)alertTitle:(NSString *)title content:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2];
}

- (void)dismiss:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end

