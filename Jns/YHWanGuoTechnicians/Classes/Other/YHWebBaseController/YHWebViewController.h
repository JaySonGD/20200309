//
//  YHWebViewController.h
//  FTE
//
//  Created by ZWS on 14-9-10.
//  Copyright (c) 2014年 ftsafe. All rights reserved.
//

#import "YHWebViewController.h"
#import "YHBaseViewController.h"
@interface YHWebViewController : YHBaseViewController
@property (nonatomic, strong)NSString *urlStr;
@property (nonatomic)BOOL barHidden;
- (void)loadWebPageWithString:(NSString*)urlString;
- (void)pushVin:(NSString*)vin;
- (void)pushVin:(NSString*)vin
          image:(NSString *)base64String;
- (void)vinCallback:(NSString*)vin;//传vin码

- (void)jumpScanVinCallback:(NSString*)vin;
// H5控制是否显示或者隐藏导航 @"0"显示导航 @"1"不显示导航  @"" 未知，以代码控制
- (NSString *)naviShowState;

- (void)pushLocationLongitude:(NSString *)longitude
                     latitude:(NSString *)latitude
                        state:(BOOL)state;

- (void)appToH5:(NSString*)json;
- (void)toH5:(NSDictionary *)obj;
//{
//    "jnsAppStatus": "android",
//    "jnsAppStep": "airCondition",
//    "bill_id": "9527",
//}

@end
