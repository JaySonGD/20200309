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
static NSString *kUMengKey = @"5aa9c84d8f4a9d694a000066";

//2.微信:
//APPID
static NSString *kAppID = @"wx7bbd1b8de3f45d8d";
//AppSecret
static NSString *kAppSecret = @"3b02b4d6a59544c48068140928dc921b";
//商户号
static NSString *kMchId = @"1446585402";
//商户密钥
static NSString *kPartnerId = @"1234567890qwertyuiopfffffffdgdfg";
//统一下单接口URL
static NSString *kUnifiedUrl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

//3.QQ:
//APPID
static NSString *kQQAppID = @"1106778284";

//AppSecret
static NSString *kQQAppSecret = @"nil";

//APPKEY
static NSString *kQQAppKey = @"b40UVNVBRKWlwcmV";

//URLScheme
//需要添加两项URL Scheme：
//1、"tencent"+腾讯QQ互联应用appID
//2、“QQ”+腾讯QQ互联应用appID转换成十六进制（不足8位前面补0）
static NSString *kQQURLScheme1 = @"tencent1106768374";

static NSString *kQQURLScheme2 = @"QQ41f7f1f6";

#endif
