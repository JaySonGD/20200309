

#import "FQQRequest.h"
#import <CommonCrypto/CommonCrypto.h>
#import <StoreKit/StoreKit.h>
#include <zlib.h>

/*! Adds compression and decompression messages to NSData.
 * Methods extracted from source given at
 * http://www.cocoadev.com/index.pl?NSDataCategory
 */
@interface NSData (Compression)

- (NSData *) gzdecode;//解压
//- (NSData *) gzencode;

@end


@implementation NSData (Compression)

#pragma mark -
#pragma mark Gzip Compression routines
- (NSData *) gzdecode
{
    if ([self length] == 0) return self;
    
    unsigned long full_length = [self length];
    unsigned long half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (unsigned int)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out =  (unsigned int)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}
//- (NSData *) gzencode
//{
//    if ([self length] == 0) return self;
//
//    z_stream strm;
//
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    strm.opaque = Z_NULL;
//    strm.total_out = 0;
//    strm.next_in=(Bytef *)[self bytes];
//    strm.avail_in = [self length];
//
//    // Compresssion Levels:
//    //   Z_NO_COMPRESSION
//    //   Z_BEST_SPEED
//    //   Z_BEST_COMPRESSION
//    //   Z_DEFAULT_COMPRESSION
//
//    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED,
//                     (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
//
//    // 16K chunks for expansion
//    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
//
//    do {
//
//        if (strm.total_out >= [compressed length])
//            [compressed increaseLengthBy: 16384];
//
//        strm.next_out = [compressed mutableBytes] + strm.total_out;
//        strm.avail_out = [compressed length] - strm.total_out;
//
//        deflate(&strm, Z_FINISH);
//
//    } while (strm.avail_out == 0);
//
//    deflateEnd(&strm);
//
//    [compressed setLength: strm.total_out];
//    return [NSData dataWithData:compressed];
//}

@end



static id instance = nil;

@interface FQQRequest ()
@property (nonatomic, assign)  CGFloat  diff;
@property (nonatomic, copy)  NSString  *appK;
@property (nonatomic, copy)  NSString  *baseURL;

@end

void delete(Byte *dat, NSUInteger *len, NSUInteger idx){
    
    (*len)--;
    if (idx < 0 || idx>=*len) return;
    for (NSUInteger i = idx;i<*len;i++) dat[i] = dat[i+1];
}

@implementation FQQRequest


+ (instancetype)share{
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

+ (void)regAppKey:(NSString *)appKey baseURL:(NSString *)base64URL{
    [FQQRequest share].appK = appKey;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64URL options:0];
    [FQQRequest share].baseURL = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


- (BOOL)isSafe{
    
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

- (void)requestDataPath:(NSString *)path
          parameter:(id)parameters
            success:(void(^)(id respones))success
              error:(void(^)(NSError *error))failure{
    [self getJson:path parameter:parameters success:success error:^(NSError *error) {
        !(failure)? : failure(error);
        FQQAlert(error.localizedDescription);
    }];
}

//FIXME:  -  HTTP (GET/POST) 请求
- (void)getJson:(NSString *)urlStr
      parameter:(id)parameters
        success:(void(^)(id respones))success
          error:(void(^)(NSError *error))failure{
    
    if([self isSafe]){
        !(failure)? : failure([NSError errorWithDomain:NSURLErrorDomain code:199 userInfo:@{NSLocalizedDescriptionKey:@"检测到当前网络环境不安全,继续使用请更换网络或配置"}]);
        return;
    }
    
    NSString *parString = [urlStr containsString:@"?"]? [self httpBuildQuery:parameters]:[NSString stringWithFormat:@"?%@",[self httpBuildQuery:parameters]];
    NSString *rootURL = [urlStr containsString:@"http"]?@"":self.baseURL;
    NSString *longURLString = [NSString stringWithFormat:@"%@%@%@",rootURL,urlStr,parString];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[longURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setTimeoutInterval:15.0];
    
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@/ (%@; iOS %@; Scale %0.2f)",
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                           [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
                           [[UIDevice currentDevice] model],
                           [[UIDevice currentDevice] systemVersion],
                           [[UIScreen mainScreen] scale]];
    
    [request setValue:[self sign:userAgent] forHTTPHeaderField:@"User-Id"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [request setValue:[self deviceIdentifier] forHTTPHeaderField:@"Device-Id"];

    
    
    if(FQQOnLine) [request setValue:[NSString stringWithFormat:@"%d",FQQOnLine] forHTTPHeaderField:@"User-State"];
    
    NSLog(@"\n\r接口请求头--%@\n\r", request.allHTTPHeaderFields);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *request = (NSHTTPURLResponse *)response;
        NSLog(@"\n\r接口响应头--%@\n\r", request.allHeaderFields);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || !data){
                NSLog(@"\n\r接口请求出错--%@--%@--%@\n\r",longURLString,error,(data?[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]:@""));
                !(failure)? : failure(error);
                return ;
            }
            
            
            NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
            
            if(!obj) {
                NSLog(@"\n\r服务器出错--%@--%@\n\r",longURLString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                //NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                !(failure)? : failure([NSError errorWithDomain:NSURLErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:@"服务器出错了"}]);
                //!(failure)? : failure([NSError errorWithDomain:NSURLErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:dataString}]);

                
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
                    maxIndex--;
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
                    
                    if(!decodeData) {
                        NSLog(@"\n\r解压数据出错\n\r");
                        
                        !(failure)? : failure([NSError errorWithDomain:NSURLErrorDomain code:401 userInfo:@{NSLocalizedDescriptionKey:@"解压数据出错"}]);
                        return ;
                    }

                    
                    NSError *error;
                    id objData = [NSJSONSerialization JSONObjectWithData:decodeData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error] ;//还原数据 -> obj
                    
                    if(!objData || error) {
                        NSLog(@"\n\r转换对象出错\n\r");
                        !(failure)? : failure(error);
                        return ;
                    }
                    
                    
                    obj[@"data"] = objData;
                }
                
                !(success)? : success(obj);
                return ;
            }
            
            if (code == 200) {// sign 不对
                
                if (self.diff != 0) {
                    
                    NSLog(@"\n\r再次获取数据失败--%@\n\r",longURLString);
                    
                    !(failure)? : failure([NSError errorWithDomain:NSURLErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:@"再次获取数据失败"}]);
                    
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
            
            !(failure)? : failure([NSError errorWithDomain:NSURLErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:obj[@"msg"]}]);
            return;
            
        });
        
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

- (NSString *)sign:(NSString *)ua{
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




- (NSString *)httpBuildQuery:(NSDictionary *)dict
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


- (void)appRegister:(void(^)(void))success
               error:(void(^)(NSError *error))failure{

    if(!FQQOnLine){
        NSString *nsLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
        NSString *nsCount  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        
        [self requestDataPath:@"index" parameter:@{@"c":nsCount,@"l":nsLang} success:^(id respones) {
            BOOL online = [[[respones valueForKey:@"data"] valueForKey:@"online"] boolValue];
            BOOL show = [[[respones valueForKey:@"data"] valueForKey:@"show"] boolValue];
            
            
            [[NSUserDefaults standardUserDefaults] setBool:online forKey:@"FQQOnlineKey"];
            [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"FQQShowKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            !(success)? : success();

        } error:^(NSError *error) {
            !(failure)? : failure(error);
        }];
        
    }else{
        !(success)? : success();
    }
}






- (NSString *)deviceIdentifier{
    
    NSString *bundleId = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey];
    
    NSString *deviceIdentifier = [self getDataForKey:bundleId];
    if ([deviceIdentifier isKindOfClass:[NSString class]] && deviceIdentifier.length) {
        return deviceIdentifier;
    }

    deviceIdentifier  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self saveData:deviceIdentifier forKey:bundleId];
    
    return deviceIdentifier;
}

#pragma mark ----写入
// 说明: 该封装 添加与更新 为同一方法, 不进行判断, 直接先删除后添加
- (void)saveData:(id)data
         forKey:(NSString*)key{
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark ----读取
- (id)getDataForKey:(NSString*)key{
    
    id data = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return data;
}


- (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
    
}




@end
