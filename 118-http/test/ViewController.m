//
//  ViewController.m
//  test
//
//  Created by Jay on 20/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "RRHttp.h"

#import <CommonCrypto/CommonCrypto.h>

@interface ViewController ()
//@property (nonatomic, assign)  CGFloat  differ;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSString *old = [self reverseWordsInString:@"5aSa5aSa5bKb"];
    NSLog(@"%s", __func__);
    return
    
//    [self httpRequest];return;
    //http://129.204.117.172/api/vod?tid=22&p=10&debug=99
    [[RRHttp shareHttp] getRequest:@"http://129.204.117.172/taiju/vod" parameters:@{@"p":@(0),@"tid":@(16)} success:^(id  _Nonnull respones) {
        NSLog(@"%@", respones);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (NSString *)generateTradeNO{
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklnmopqrstuvwxyz";
    unsigned index = rand() % [sourceStr length];
    return [sourceStr substringWithRange:NSMakeRange(index, 1)];
}

- (NSString*)reverseWordsInString:(NSString*)oldStr{
    NSMutableString *newStr = [[NSMutableString alloc] initWithCapacity:oldStr.length];
    for (int i = (int)oldStr.length - 1; i >= 0; i --) {
        unichar character = [oldStr characterAtIndex:i];
        [newStr appendFormat:@"%c",character];
    }
    return newStr;
}


- (void)httpRequest{
    NSString *urlStr = @"https://haokan.baidu.com/videoui/list/tab?subTab=qiongying&source=wise-channel&bt=2222&_=1551750564572&direction=down&refreshType=1";//@"http://129.204.117.172/api/series";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];

    // @"BundleId/AppVersion/(Model;SystemVersion;DeviceScale)";
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@/ (%@; iOS %@; Scale %0.2f)",
                 [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                 [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
                 [[UIDevice currentDevice] model],
                 [[UIDevice currentDevice] systemVersion],
                 [[UIScreen mainScreen] scale]];

    //[request setValue:[self getToken:userAgent] forHTTPHeaderField:@"User-Id"];
    //[request setValue:userAgent forHTTPHeaderField:@"User-Agent"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"%@",obj);

        if (obj) {

//            NSInteger code = [obj[@"code"] integerValue];
//            if (!code) {
//                NSLog(@"获取数据成功");
//
//            }else if (code == 200) {// sign 不对
//
//                if (self.differ != 0) {
//
//                    NSLog(@"再次获取数据失败");
//                    return ;
//                }
//                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//                NSDictionary *headerDict = res.allHeaderFields;
//
//
//                NSTimeInterval appTime = [[NSDate date] timeIntervalSince1970];
//                self.differ = [headerDict[@"Time-Stamp"] doubleValue] - appTime;
//
//                [self httpRequest];
//
//                NSLog(@"同步时间再次获取数据");
//                NSLog(@"%s--%@---%f", __func__,headerDict[@"Time-Stamp"],appTime);
//
//            }else{
//                NSLog(@"其他业务错误");
//            }
        }

    }];

    //开始任务
    [task resume];
}

//- (nullable NSString *)md5:(nullable NSString *)str {
//    if (!str) return nil;
//
//    const char *cStr = str.UTF8String;
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
//
//    NSMutableString *md5Str = [NSMutableString string];
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
//        [md5Str appendFormat:@"%02x", result[i]];
//    }
//    return md5Str;
//}
//
//- (NSString *)getToken:(NSString *)ua{
//    NSDate*date=[NSDate dateWithTimeIntervalSinceNow:self.differ];
//
//    NSDateFormatter *formatter  =   [[NSDateFormatter alloc]    init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
//
//    [formatter setDateFormat:@"mm"];
//    NSInteger m = [formatter stringFromDate:date].integerValue;
//    [formatter setDateFormat:@"ss"];
//    NSInteger s = [formatter stringFromDate:date].integerValue;
//
//    NSInteger time = m * 60 + s;
//    NSInteger p1 = time/10;
//    NSString *salt = @"mcdfdgq4363731453637";
//
//    NSString *token = [self md5:[NSString stringWithFormat:@"%@-%@-%ld",salt,ua,(long)p1]];
//
//    return token;
//}



@end
