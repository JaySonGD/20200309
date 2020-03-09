

#import "AARequest.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+Compression.h"


static id instance = nil;

@interface AARequest ()
@property (nonatomic, assign)  CGFloat  diff;
@property (nonatomic, copy)  NSString  *appK;
@property (nonatomic, copy)  NSString  *baseURL;
@end

void delete(Byte *dat, NSUInteger *len, NSUInteger idx){
    
    (*len)--;
    if (idx < 0 || idx>=*len) return;
    for (NSUInteger i = idx;i<*len;i++) dat[i] = dat[i+1];
}

@implementation AARequest


+ (instancetype)request{
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

+ (void)initAppKey:(NSString *)appKey base64BaseURL:(NSString *)base64URL{
    [AARequest request].appK = appKey;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64URL options:0];
    [AARequest request].baseURL = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


- (BOOL)hasP{
    
    #ifdef DEBUG
        return NO;
    #else
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
    #endif
}


//FIXME:  -  HTTP (GET/POST) 请求
- (void)getJson:(NSString *)urlStr
           parameter:(id)parameters
        success:(void(^)(id respones))success
          error:(void(^)(NSError *error))failure{
    
    if([self hasP]){
        !(failure)? : failure([NSError errorWithDomain:@"你的网络环境不安全" code:199 userInfo:nil]);
        return;
    }
    
    NSString *parString = [urlStr containsString:@"?"]? [self kVSWDict:parameters]:[NSString stringWithFormat:@"?%@",[self kVSWDict:parameters]];
    NSString *rootURL = [urlStr containsString:@"http"]?@"":self.baseURL;
    NSString *longURLString = [NSString stringWithFormat:@"%@%@%@",rootURL,urlStr,parString];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:longURLString]];
    [request setTimeoutInterval:10.0];
    
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@/ (%@; iOS %@; Scale %0.2f)",
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
                           [[UIDevice currentDevice] model],
                           [[UIDevice currentDevice] systemVersion],
                           [[UIScreen mainScreen] scale]];
    
    [request setValue:[self gT:userAgent] forHTTPHeaderField:@"User-Id"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    if(VPOnLine) [request setValue:[NSString stringWithFormat:@"%d",VPOnLine] forHTTPHeaderField:@"User-State"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || !data){
                NSLog(@"\n\r接口请求出错--%@\n\r",longURLString);
                !(failure)? : failure(error);
                return ;
            }
            
            
            NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
            
            if(!obj) {
                NSLog(@"\n\r服务器出错--%@\n\r",longURLString);
                !(failure)? : failure([NSError errorWithDomain:@"服务器出错" code:500 userInfo:nil]);
                return ;
            }
            
            NSInteger code = [obj[@"code"] integerValue];
            if (!code) {
                NSLog(@"\n\r获取数据成功--%@\n\r",longURLString);
                
                obj = obj.mutableCopy;
                NSMutableString *dataString = [obj valueForKey:@"data"];//base64（压缩数据）->NSString
                
                
                if ([dataString isKindOfClass:[NSString class]] && dataString.length > 10) {
                    
                    NSUInteger maxIndex = dataString.length - 10 + 1;//先减去混淆的长度 在加 尾部1
                    NSUInteger index = floor(maxIndex / ((maxIndex%9) + 1));//定位混淆的下标
                    if (index > maxIndex) index = maxIndex;
                    
                    dataString = [NSMutableString stringWithString:dataString];
                    [dataString replaceCharactersInRange:NSMakeRange(index, 10) withString:@""];//提除混淆的字符串
                    
                    
                    NSData * data = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];//（压缩数据）->NSData
                    
                    
                    Byte *Bytes = (Byte *)[data bytes];
                    
                    NSUInteger len = [data length];
                    
                    //    for (NSUInteger i = 0; i < len; i ++) {
                    //        printf("testByte = %d\n",Bytes[i]);
                    //    }
                    
                    maxIndex = len;
                    
                    index = floor(maxIndex / ((maxIndex%9) + 1));
                    
                    if (index > maxIndex) index = maxIndex;
                    
                    
                    delete(Bytes, &len, index);// 提除（压缩数据）->NSData 中混淆 字符
                    
                    //    for (NSUInteger i = 0; i < len; i ++) {
                    //        printf("testByte = %d\n",Bytes[i]);
                    //    }
                    
                    NSData *oData = [[NSData alloc] initWithBytes:Bytes length:len];//压缩数据
                    
                    
                    
                    NSData *decodeData = [oData gzdecode];// 明文数据
                    
                    id objData = [NSJSONSerialization JSONObjectWithData:decodeData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:NULL] ;//还原数据 -> obj
                    
                    if (objData) {
                        obj[@"data"] = objData;
                    }
                }
                
                !(success)? : success(obj);
                return ;
            }
            
            if (code == 200) {// sign 不对
                
                if (self.diff != 0) {
                    
                    NSLog(@"\n\r再次获取数据失败--%@\n\r",longURLString);
                    !(failure)? : failure([NSError errorWithDomain:@"再次获取数据失败" code:code userInfo:nil]);
                    
                    return ;
                }
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                NSDictionary *headerDict = res.allHeaderFields;
                
                
                NSTimeInterval appTime = [[NSDate date] timeIntervalSince1970];
                self.diff = [headerDict[@"Time-Stamp"] doubleValue] - appTime;
                
                [self getJson:longURLString parameter:parameters success:success error:failure];
                
                NSLog(@"\n\r同步时间再次获取数据--%@\n\r",longURLString);
                NSLog(@"%s--%@---%f", __func__,headerDict[@"Time-Stamp"],appTime);
                return;
            }
            
            
            NSLog(@"\n\r其他业务错误(%@:%ld)--%@\n\r",obj[@"msg"],code,longURLString);
            !(failure)? : failure([NSError errorWithDomain:obj[@"msg"] code:code userInfo:nil]);
            return;
            
        });
        
    }];
    
    //开始任务
    [task resume];
}

//FIXME:  -  HTTP (GET/POST) 请求
//- (void)postRequest:(NSString *)urlStr
//         parameters:(id)parameters
//            success:(void(^)(id respones))success
//            failure:(void(^)(NSError *error))failure{
//
//    if([self hasP]){
//        !(failure)? : failure([NSError errorWithDomain:@"你的网络环境不安全" code:199 userInfo:nil]);
//        return;
//    }
//
//    NSString *parString =  [self kVSWDict:parameters];
//
//    NSString *rootURL = [urlStr containsString:@"http"]?@"":self.baseURL;
//    NSString *longURLString = [NSString stringWithFormat:@"%@%@",rootURL,urlStr];
//
//
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:longURLString]];
//    [request setTimeoutInterval:10.0];
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [parString dataUsingEncoding:NSUTF8StringEncoding];
//
//
//    NSString *userAgent = [NSString stringWithFormat:@"%@/%@/ (%@; iOS %@; Scale %0.2f)",
//                           [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
//                           [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
//                           [[UIDevice currentDevice] model],
//                           [[UIDevice currentDevice] systemVersion],
//                           [[UIScreen mainScreen] scale]];
//
//    [request setValue:[self gT:userAgent] forHTTPHeaderField:@"User-Id"];
//    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//    [request setValue:[NSString stringWithFormat:@"%d",VPOnLine] forHTTPHeaderField:@"User-State"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//            if(error || !data){
//                NSLog(@"\n\r接口请求出错--%@\n\r",longURLString);
//                !(failure)? : failure(error);
//                return ;
//            }
//
//
//            NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
//
//            if(!obj) {
//                NSLog(@"\n\r服务器出错--%@\n\r",longURLString);
//                !(failure)? : failure([NSError errorWithDomain:@"服务器出错" code:500 userInfo:nil]);
//                return ;
//            }
//
//            NSInteger code = [obj[@"code"] integerValue];
//            if (!code) {
//                NSLog(@"\n\r获取数据成功--%@\n\r",longURLString);
//
//                obj = obj.mutableCopy;
//                NSMutableString *dataString = [obj valueForKey:@"data"];//base64（压缩数据）->NSString
//
//
//                if ([dataString isKindOfClass:[NSString class]] && dataString.length > 10) {
//
//                    NSUInteger maxIndex = dataString.length - 10 + 1;//先减去混淆的长度 在加 尾部1
//                    NSUInteger index = floor(maxIndex / ((maxIndex%9) + 1));//定位混淆的下标
//                    if (index > maxIndex) index = maxIndex;
//
//                    dataString = [NSMutableString stringWithString:dataString];
//                    [dataString replaceCharactersInRange:NSMakeRange(index, 10) withString:@""];//提除混淆的字符串
//
//
//                    NSData * data = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];//（压缩数据）->NSData
//
//
//                    Byte *Bytes = (Byte *)[data bytes];
//
//                    NSUInteger len = [data length];
//
//                    //    for (NSUInteger i = 0; i < len; i ++) {
//                    //        printf("testByte = %d\n",Bytes[i]);
//                    //    }
//
//                    maxIndex = len;
//
//                    index = floor(maxIndex / ((maxIndex%9) + 1));
//
//                    if (index > maxIndex) index = maxIndex;
//
//
//                    delete(Bytes, &len, index);// 提除（压缩数据）->NSData 中混淆 字符
//
//                    //    for (NSUInteger i = 0; i < len; i ++) {
//                    //        printf("testByte = %d\n",Bytes[i]);
//                    //    }
//
//                    NSData *oData = [[NSData alloc] initWithBytes:Bytes length:len];//压缩数据
//
//
//
//                    NSData *decodeData = [oData gzdecode];// 明文数据
//
//                    id objData = [NSJSONSerialization JSONObjectWithData:decodeData
//                                                                 options:NSJSONReadingAllowFragments
//                                                                   error:NULL] ;//还原数据 -> obj
//
//                    if (objData) {
//                        obj[@"data"] = objData;
//                    }
//                }
//
//                !(success)? : success(obj);
//                return ;
//            }
//
//            if (code == 200) {// sign 不对
//
//                if (self.diff != 0) {
//
//                    NSLog(@"\n\r再次获取数据失败--%@\n\r",longURLString);
//                    !(failure)? : failure([NSError errorWithDomain:@"再次获取数据失败" code:code userInfo:nil]);
//
//                    return ;
//                }
//                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//                NSDictionary *headerDict = res.allHeaderFields;
//
//
//                NSTimeInterval appTime = [[NSDate date] timeIntervalSince1970];
//                self.diff = [headerDict[@"Time-Stamp"] doubleValue] - appTime;
//
//                [self getJson:longURLString parm:parameters success:success error:failure];
//
//                NSLog(@"\n\r同步时间再次获取数据--%@\n\r",longURLString);
//                NSLog(@"%s--%@---%f", __func__,headerDict[@"Time-Stamp"],appTime);
//                return;
//            }
//
//
//            NSLog(@"\n\r其他业务错误(%@:%ld)--%@\n\r",obj[@"msg"],code,longURLString);
//            !(failure)? : failure([NSError errorWithDomain:obj[@"msg"] code:code userInfo:nil]);
//            return;
//
//        });
//
//    }];
//
//    //开始任务
//    [task resume];
//
//}



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

- (NSString *)gT:(NSString *)ua{
    NSDate*date=[NSDate dateWithTimeIntervalSinceNow:self.diff];
    
    NSDateFormatter *formatter  =   [[NSDateFormatter alloc]    init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    
    [formatter setDateFormat:@"mm"];
    NSInteger m = [formatter stringFromDate:date].integerValue;
    [formatter setDateFormat:@"ss"];
    NSInteger s = [formatter stringFromDate:date].integerValue;
    
    NSInteger time = m * 60 + s;
    NSInteger p1 = time/10;
    NSString *salt = self.appK;;
    
    NSString *token = [self md5:[NSString stringWithFormat:@"%@-%@-%ld",salt,ua,(long)p1]];
    
    return token;
}




- (NSString *)kVSWDict:(NSDictionary *)dict
{
    if (dict == nil || !dict.allKeys.count) {
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


//- (void)appInitOk:(void(^)(void))success
//               error:(void(^)(NSError *error))failure{
//    
//    if(!VPOnLine){
//        NSString *nsLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
//        NSString *nsCount  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
//        
//        [self getJson:@"index" parm:@{@"c":nsCount,@"l":nsLang} success:^(id  _Nonnull respones) {
//            
//            BOOL online = [[[respones valueForKey:@"data"] valueForKey:@"online"] boolValue];
//            [[NSUserDefaults standardUserDefaults] setBool:online forKey:@"VPLineKey"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                !(success)? : success();
//            });
//        } error:^(NSError * _Nonnull error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                !(failure)? : failure(error);
//            });
//        }];
//        
//    }else{
//        !(success)? : success();
//    }
//}


@end
