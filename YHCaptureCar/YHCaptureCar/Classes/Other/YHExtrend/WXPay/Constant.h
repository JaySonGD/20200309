//
//  Constant.h
//  WeChatDemo
//
//  Created by L on 15/12/1.
//  Copyright © 2015年 L. All rights reserved.
//

#ifndef CommunityFinance_Constant_h
#define CommunityFinance_Constant_h

//1.友盟
static NSString *kUMengKey = @"5aa7301ca40fa336cb000048";


//2.微信:
//APPID
static NSString *kAppID = @"wxceb61f50d7290a6f";

//AppSecret
static NSString *kAppSecret = @"7f597fe3b57be1aa92d1f57c95a27ba2";

//商户号
static NSString *kMchId = @"1501912231";
//
////商户密钥
static NSString *kPartnerId = @"PA2Ujkrft6M3JWXf1PDThgjgNnnqIksj";

//统一下单接口URL
static NSString *kUnifiedUrl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

//URLScheme
static NSString *kURLScheme = @"wxceb61f50d7290a6f";



//3.QQ:
//APPID
static NSString *kQQAppID = @"1106768374";

//AppSecret
static NSString *kQQAppSecret = @"nil";

//APPKEY
static NSString *kQQAppKey = @"wzckLlhymHAlctk3";

//URLScheme
//需要添加两项URL Scheme：
//1、"tencent"+腾讯QQ互联应用appID
//2、“QQ”+腾讯QQ互联应用appID转换成十六进制（不足8位前面补0）
static NSString *kQQURLScheme1 = @"tencent1106768374";

static NSString *kQQURLScheme2 = @"QQ41f7f1f6";


#endif
