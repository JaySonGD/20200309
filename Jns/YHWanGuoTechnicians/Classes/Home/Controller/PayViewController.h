//
//  PayViewController.h
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

@interface PayViewController : YHBaseViewController
@property (nonatomic)YHBuyType type;
@property (nonatomic)float price;
@property (strong, nonatomic)NSString *vin;
@end
