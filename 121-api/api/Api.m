//
//  api.m
//  api
//
//  Created by Jay on 14/3/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "Api.h"
#import <CommonCrypto/CommonCrypto.h>
#import <sys/utsname.h>

static id instance = nil;

@interface Api ()
@property (nonatomic, assign)  CGFloat  differ;
@property (nonatomic, copy)  NSString  *appKey;
@end

@implementation Api


+ (instancetype)shareApi{
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

+ (void)registerAppKey:(NSString *)appKey{
    [Api shareApi].appKey = appKey;
}


- (BOOL)hasProtocol{
    
//#ifdef DEBUG
//    return NO;
//#else
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    //NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //NSLog(@"没代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
//#endif
}


//FIXME:  -  HTTP (GET/POST) 请求
- (void)getRequest:(NSString *)urlStr
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure{
    
    if([self hasProtocol]){
        !(failure)? : failure([NSError errorWithDomain:@"你的网络环境不安全" code:199 userInfo:nil]);
        return;
    }
    
    NSString *parString = [urlStr containsString:@"?"]? [self keyValueStringWithDict:parameters]:[NSString stringWithFormat:@"%@",[self keyValueStringWithDict:parameters]];
    
    NSString *longURLString = [NSString stringWithFormat:@"%@%@",urlStr,parString];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:longURLString]];
    [request setTimeoutInterval:10.0];
    
    //1）获取设置的语言
    
    //NSString *nsLang  = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    
    //传说中获取语言设置最准确的方法：
    
    NSString *nsLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
    
    //2）获取设置的国家
    /*
     中国 CN
     香港 HK
     台湾 TW
     澳门 MO
     
     简体中文 zh-Hans-CN
     繁体中文 zh-Hant-CN
     繁体中文(香港) zh-Hant-HK
     繁体中文(澳门) zh-Hant-TW
     繁体中文(台湾) zh-Hant-MO
     
     */
    
    NSString *nsCount  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSLog(@"%s-线下的国家：%@,语言：%@", __func__,nsCount,nsLang);
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *deviceUUID = [UIDevice currentDevice].identifierForVendor.UUIDString;//获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6

    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@/%d (%@; iOS %@; Scale %0.2f; %@; %@; %@)",
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],online,
                           [[UIDevice currentDevice] model],
                           [[UIDevice currentDevice] systemVersion],
                           [[UIScreen mainScreen] scale],nsCount,nsLang,deviceModel];
    
    [request setValue:[self getToken:userAgent] forHTTPHeaderField:@"User-Id"];
    [request setValue:deviceUUID forHTTPHeaderField:@"Device-Id"];

    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
            obj = obj.mutableCopy;
            
            NSInteger code = [obj[@"code"] integerValue];
            if (!code ) {
                NSLog(@"获取数据成功");
                
                NSMutableString *dataString = [obj valueForKey:@"data"];
                if ([dataString isKindOfClass:[NSString class]] && dataString.length > 1) {
                    
                    
                    dataString = [NSMutableString stringWithString:dataString];
                    [dataString replaceCharactersInRange:NSMakeRange(1, 10) withString:@""];
                    NSString *base64String = [self reverseWordsInString:dataString];
                    NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    id objData = [NSJSONSerialization JSONObjectWithData:base64Data options:NSJSONReadingAllowFragments error:NULL];
                    if (objData) {
                        obj[@"data"] = objData;
                    }
                }
                
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

//FIXME:  -  HTTP (GET/POST) 请求
- (void)postRequest:(NSString *)urlStr
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure{
    
    if([self hasProtocol]){
        !(failure)? : failure([NSError errorWithDomain:@"你的网络环境不安全" code:199 userInfo:nil]);
        return;
    }
    
    NSString *parString =  [self keyValueStringWithDict:parameters];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeoutInterval:10.0];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[parString stringByReplacingOccurrencesOfString:@"?" withString:@""] dataUsingEncoding:NSUTF8StringEncoding];
    
    
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
        
        if (!error) {
            
            NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
            obj = obj.mutableCopy;
            
            NSInteger code = [obj[@"code"] integerValue];
            if (!code) {
                NSLog(@"获取数据成功");
                
                NSMutableString *dataString = [obj valueForKey:@"data"];
                if ([dataString isKindOfClass:[NSString class]] && dataString.length > 1) {
                    
                    
                    dataString = [NSMutableString stringWithString:dataString];
                    [dataString replaceCharactersInRange:NSMakeRange(1, 10) withString:@""];
                    NSString *base64String = [self reverseWordsInString:dataString];
                    NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    id objData = [NSJSONSerialization JSONObjectWithData:base64Data options:NSJSONReadingAllowFragments error:NULL];
                    if (objData) {
                        obj[@"data"] = objData;
                    }
                }
                
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

- (NSString*)reverseWordsInString:(NSString*)oldStr{
    NSMutableString *newStr = [[NSMutableString alloc] initWithCapacity:oldStr.length];
    for (int i = (int)oldStr.length - 1; i >= 0; i --) {
        unichar character = [oldStr characterAtIndex:i];
        [newStr appendFormat:@"%c",character];
    }
    return newStr;
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
    NSString *salt = self.appKey;//@"mdasntvccddbvcxz1234567890";
    
    NSString *token = [self md5:[NSString stringWithFormat:@"%@-%@-%ld",salt,ua,(long)p1]];
    
    return token;
}


- (NSString *)keyValueStringWithDict:(NSDictionary *)dict
{
    if (dict == nil || !dict.allKeys.count) {
        return @"";
    }
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    
    return string;
}

@end
