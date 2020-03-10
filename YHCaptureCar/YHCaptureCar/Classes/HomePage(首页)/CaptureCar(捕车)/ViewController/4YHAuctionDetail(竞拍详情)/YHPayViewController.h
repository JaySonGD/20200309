//
//  YHPayViewController.h
//  CommunityFinance
//
//  Created by L on 15/10/13.
//  Copyright © 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLDictionary.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "YHNetworkPHPManager.h"
#import "YHBaseViewController.h"

@interface YHPayViewController : YHBaseViewController
@property (nonatomic)YHBuyType type;
@property (nonatomic)float price;
@property (strong, nonatomic)NSString *vin;


- (void)payByPrepayId:(NSString*)prepayId;

//支付帮检费(梅文峰)
/*
 partnerId   商户号
 prepayId   微信返回的预支付id
 package  商家根据财付通文档填写的数据和签名
 nonceStr  随机字符串
 timeStamp  时间戳
 sign  商家根据微信开放平台文档对数据做的签名
 */
- (void)payWithDict:(NSDictionary *)info;

- (IBAction)submitBtnClick:(UIButton *)btn;

/*
 支付服务费(梅文峰)
 */
-(void)gpaymentAuctionId:(NSString*)auctionId isBuy:(BOOL)isBuy onComplete:(void (^)(NSDictionary *info))onComplet;
@end
