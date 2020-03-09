//
//  RRHttp.m
//  test
//
//  Created by Jay on 25/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "RRHttp.h"

#import <CommonCrypto/CommonCrypto.h>

static id instance = nil;

@interface RRHttp ()
@property (nonatomic, assign)  CGFloat  differ;
@end

@implementation RRHttp

+ (instancetype)shareHttp{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


//FIXME:  -  HTTP (GET/POST) 请求
- (void)getRequest:(NSString *)urlStr
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure{
    
    NSString *parString = [urlStr containsString:@"?"]? [self keyValueStringWithDict:parameters]:[NSString stringWithFormat:@"?%@",[self keyValueStringWithDict:parameters]];
    
    NSString *longURLString = [NSString stringWithFormat:@"%@%@",urlStr,parString];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:longURLString]];
    [request setTimeoutInterval:10.0];

    
    // @"BundleId/AppVersion/(Model;SystemVersion;DeviceScale)";
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@/ (%@; iOS %@; Scale %0.2f)",
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
                           [[UIDevice currentDevice] model],
                           [[UIDevice currentDevice] systemVersion],
                           [[UIScreen mainScreen] scale]];
    
    [request setValue:[self getToken:userAgent] forHTTPHeaderField:@"User-Id"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
        //NSLog(@"%@",obj);
        
        if (obj && !error) {
            
            NSInteger code = [obj[@"code"] integerValue];
            if (!code) {
                NSLog(@"获取数据成功");
                !(success)? : success(obj);

                
            }else if (code == 200) {// sign 不对
                
                if (self.differ != 0) {
                    
                    NSLog(@"再次获取数据失败");
                    !(failure)? : failure([NSError errorWithDomain:@"再次获取数据失败" code:code userInfo:nil]);

                    return ;
                }
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                NSDictionary *headerDict = res.allHeaderFields;
                
                
                NSTimeInterval appTime = [[NSDate date] timeIntervalSince1970];
                self.differ = [headerDict[@"Time-Stamp"] doubleValue] - appTime;
                
                [self getRequest:urlStr parameters:parameters success:success failure:failure];
                
                NSLog(@"同步时间再次获取数据");
                NSLog(@"%s--%@---%f", __func__,headerDict[@"Time-Stamp"],appTime);
                
            }else{
                NSLog(@"其他业务错误");
                !(failure)? : failure([NSError errorWithDomain:obj[@"msg"] code:code userInfo:nil]);

            }
        }else{
            !(failure)? : failure(error);
        }
        
    }];
    
    //开始任务
    [task resume];

}


- (nullable NSString *)md5:(nullable NSString *)str {
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

- (NSString *)getToken:(NSString *)ua{
    NSDate*date=[NSDate dateWithTimeIntervalSinceNow:self.differ];
    
    NSDateFormatter *formatter  =   [[NSDateFormatter alloc]    init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    
    [formatter setDateFormat:@"mm"];
    NSInteger m = [formatter stringFromDate:date].integerValue;
    [formatter setDateFormat:@"ss"];
    NSInteger s = [formatter stringFromDate:date].integerValue;
    
    NSInteger time = m * 60 + s;
    NSInteger p1 = time/10;
    NSString *salt = @"mcdfdgq4363731453637";
    
    NSString *token = [self md5:[NSString stringWithFormat:@"%@-%@-%ld",salt,ua,(long)p1]];
    
    return token;
}


- (NSString *)keyValueStringWithDict:(NSDictionary *)dict
{
    if (dict == nil) {
        return @"";
    }
    NSMutableString *string = [NSMutableString stringWithString:@""];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    
    return string;
}

@end
