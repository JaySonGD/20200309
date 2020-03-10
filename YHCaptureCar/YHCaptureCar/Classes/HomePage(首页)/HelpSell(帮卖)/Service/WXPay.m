//
//  WXPay.m
//  YHCaptureCar
//
//  Created by Jay on 28/4/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "WXPay.h"

#import "WXApi.h"

#import "Constant.h"
#import "YHTools.h"
#import "DataMD5.h"
#import "UIAlertView+Block.h"
#import "YHNetworkManager.h"
#import "getIPhoneIP.h"
#import "XMLDictionary.h"

#import <CommonCrypto/CommonDigest.h>

@interface WXPay()

@property (nonatomic, copy) void (^success)(void);
@property (nonatomic, copy) void (^failure)(void);

@end


@implementation WXPay
DEFINE_SINGLETON_FOR_CLASS(WXPay);



- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tongzhi:)
                                                     name:@"tongzhi" object:nil];

    }
    return self;
}

//FIXME:  -  微信支付结果回调
- (void)tongzhi:(NSNotification *)text{
    
    NSString * success = text.userInfo[@"Success"];
    
    if ([success isEqualToString:@"YES"]) {
        //[MBProgressHUD showSuccess:@"支付成功！" toView:self.view];
        //[self jumpPayResult];
        !(_success)? : _success();

    }else{
        //[MBProgressHUD showError:@"支付错误"];
        //[self jumpCheckView];
        !(_failure)? : _failure();
    }
}


- (void)payByParameter:(NSDictionary*)info
               success:(void (^)(void))success
               failure:(void (^)(void))failure{
  
    if (![info isKindOfClass:[NSDictionary class]]) {
        !(failure)? : failure();
        return;
    }
    
    _success = success;
    _failure = failure;
    
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [info valueForKey:@"partnerid"];
    request.prepayId= [info valueForKey:@"wxPrepayId"];
    request.package = [info valueForKey:@"packageVal"];
    request.nonceStr= [info valueForKey:@"noncestr"];

    request.timeStamp= [[info valueForKey:@"timestamp"] intValue];
    
    request.sign = [info valueForKey:@"sign"];
    //            调用微信
    [WXApi sendReq:request];
}


- (void)payByPrepayId:(NSString*)prepayId
              success:(void (^)(void))success
              failure:(void (^)(void))failure{
    
    _success = success;
    _failure = failure;
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = kMchId;
    request.prepayId= prepayId;
    request.package = @"Sign=WXPay";
    request.nonceStr= [self generateTradeNO];
    //将当前事件转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    request.timeStamp= timeStamp;
    DataMD5 *md5 = [[DataMD5 alloc] init];
    request.sign=[md5 createMD5SingForPay:kAppID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
    //            调用微信
    [WXApi sendReq:request];
    
}


#pragma mark - 支付报告费(MWF)
/*
 partnerId   商户号
 prepayId   微信返回的预支付id
 package  商家根据财付通文档填写的数据和签名
 nonceStr  随机字符串
 timeStamp  时间戳
 sign  商家根据微信开放平台文档对数据做的签名
 */
- (void)payWithDict:(NSDictionary *)info
            success:(void (^)(void))success
            failure:(void (^)(void))failure
{
    _success = success;
    _failure = failure;
    
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    
    //(1)商户号
    request.partnerId = info[@"result"][@"partnerid"];
    
    //(2)微信返回的预支付id
    request.prepayId= info[@"result"][@"wxPrepayId"];
    
    //(3)商家根据财付通文档填写的数据和签名
    request.package = info[@"result"][@"packageVal"];
    
    //(4)随机字符串
    request.nonceStr = info[@"result"][@"noncestr"];
    
    //(5)时间戳
    UInt32 timeSp = [info[@"result"][@"timestamp"] intValue];
    request.timeStamp= timeSp;
    
    //(6)商家根据微信开放平台文档对数据做的签名
    request.sign = info[@"result"][@"sign"];
    
    //调用微信
    [WXApi sendReq:request];
    
}

#pragma mark 微信支付
///产生随机字符串
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//将订单号使用md5加密
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//产生随机数
- (NSString *)getOrderNumber{
    int random = arc4random()%10000;
    return [self md5:[NSString stringWithFormat:@"%d",random]];
}


- (void)payTestSuccess:(void (^)(void))success
               failure:(void (^)(void))failure{
    _success = success;
    _failure = failure;

    if ([WXApi isWXAppInstalled] == YES) {
        //            [self getPrepayId];
        
        NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
        //应用APPID
        appid = kAppID;
        //微信支付商户号
        mch_id = kMchId;
        ///产生随机字符串，这里最好使用和安卓端一致的生成逻辑
        nonce_str =[self generateTradeNO];
        body =@"iOS微信支付";
        //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
        out_trade_no = [self getOrderNumber];
        //交易价格1表示0.01元，10表示0.1元
        total_fee = @"1";
        //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
        NSString * IPhone_ip = [getIPhoneIP getIPAddress];
        if ([IPhone_ip hasPrefix:@"."]) {
            spbill_create_ip = IPhone_ip;
        }else{
            spbill_create_ip = NULL;
        }
        //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
        notify_url =@"www.baidu.com";
        trade_type =@"APP";
        //商户密钥
        partner = kPartnerId;
        //获取sign签名
        DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
        sign = [data getSignForMD5];
        //设置参数并转化成xml格式
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:appid forKey:@"appid"];//公众账号ID
        [dic setValue:mch_id forKey:@"mch_id"];//商户号
        [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
        [dic setValue:sign forKey:@"sign"];//签名
        [dic setValue:body forKey:@"body"];//商品描述
        [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
        [dic setValue:total_fee forKey:@"total_fee"];//金额
        [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
        [dic setValue:notify_url forKey:@"notify_url"];//通知地址
        [dic setValue:trade_type forKey:@"trade_type"];//交易类型
        
        NSString *string = [dic XMLString];
        [self http:string];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装微信,请先下载微信客户端" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去下载", nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
        }];
    }
}

- (void)http:(NSString *)xml
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:kUnifiedUrl forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    NSLog(@"---%@",xml);
    
    //发起请求
    [manager POST:kUnifiedUrl parameters:xml progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        NSLog(@"responseString is %@",responseString);
        //将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        //判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId= [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= [dic objectForKey:@"nonce_str"];
            //将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            DataMD5 *md5 = [[DataMD5 alloc] init];
            request.sign=[md5 createMD5SingForPay:kAppID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
            //            调用微信
            [WXApi sendReq:request];
        }else{
            NSLog(@"参数不正确，请检查参数");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}


@end
