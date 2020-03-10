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
static NSString *kUMengKey = @"5d1dd11f4ca357102b000bad";

//2.微信:
//APPID
static NSString *kWXAppID = @"wx80272df8beef95f3";
//AppSecret

//3.QQ:
//APPID
static NSString *kQQAppID = @"1106778284";

//AppSecret
static NSString *kQQAppSecret = @"nil";


//URLScheme
//需要添加两项URL Scheme：
//1、"tencent"+腾讯QQ互联应用appID
//2、“QQ”+腾讯QQ互联应用appID转换成十六进制（不足8位前面补0）
static NSString *kQQURLScheme1 = @"tencent1106768374";

static NSString *kQQURLScheme2 = @"QQ41f7f1f6";

#endif
