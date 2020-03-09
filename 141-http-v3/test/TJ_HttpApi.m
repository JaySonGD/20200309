
#import "TJ_HttpApi.h"
#import <CommonCrypto/CommonCrypto.h>
#import <StoreKit/StoreKit.h>




typedef NS_ENUM(NSInteger, MJRvStatus) {
    MJRvNone = 0,//不需要
    MJRvIn = 1,//内部评分
    MJRvOut = 2//外部评分
};

static id instance = nil;

@interface TJ_HttpApi ()

@property (nonatomic, copy)  NSString  *baseURL;

@property (nonatomic, copy)  NSString  *appKey;

@property (nonatomic, assign)  CGFloat  differ;

@property (nonatomic, strong) NSDate *beginTime;

@end

@implementation TJ_HttpApi


+ (instancetype)api{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        NSInteger loadTimeCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loadTimeCount"] integerValue];
        loadTimeCount ++;
        
        [[NSUserDefaults standardUserDefaults] setObject:@(loadTimeCount) forKey:@"loadTimeCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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

+ (void)registerAppKey:(NSString *)appKey
            base64BaseURL:(NSString *)base64URL {
    [TJ_HttpApi api].appKey = appKey;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64URL options:0];
    [TJ_HttpApi api].baseURL = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


- (BOOL)hasProtocol{
    
#ifdef DEBUG
    return NO;
#else
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    
    NSDictionary *settings = proxies[0];
    
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
- (void)getRequest:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id respones))success failure:(void(^)(NSError *error))failure{
    
    if([self hasProtocol]){
        !(failure)? : failure([NSError errorWithDomain:@"你的网络环境不安全" code:199 userInfo:nil]);
        return;
    }
    
    NSString *parString = [urlStr containsString:@"?"]? [self keyValueStringWithDict:parameters]:[NSString stringWithFormat:@"?%@",[self keyValueStringWithDict:parameters]];
    
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
    
    [request setValue:[self getToken:userAgent] forHTTPHeaderField:@"User-Id"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    if (MJOnLine) {
        [request setValue:[NSString stringWithFormat:@"%d",MJOnLine] forHTTPHeaderField:@"User-State"];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error || !data){
                NSLog(@"\n\r接口请求出错--%@\n\r--%@",longURLString,error);
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
                return ;
            }
            
            if (code == 200) {// sign 不对
                
                if (self.differ != 0) {
                    
                    NSLog(@"\n\r再次获取数据失败--%@\n\r",longURLString);
                    !(failure)? : failure([NSError errorWithDomain:@"再次获取数据失败" code:code userInfo:nil]);
                    
                    return ;
                }
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                NSDictionary *headerDict = res.allHeaderFields;
                
                NSTimeInterval appTime = [[NSDate date] timeIntervalSince1970];
                self.differ = [headerDict[@"Time-Stamp"] doubleValue] - appTime;
                
                [self getRequest:urlStr parameters:parameters success:success failure:failure];
                
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

- (NSString*)reverseWordsInString:(NSString*)oldStr {
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
    NSString *salt = self.appKey;;
    
    NSString *token = [self md5:[NSString stringWithFormat:@"%@-%@-%ld",salt,ua,(long)p1]];
    
    return token;
}




- (NSString *)keyValueStringWithDict:(NSDictionary *)dict
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


- (void)appInitSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure{
    [self mj_config];
    if(!MJOnLine){
        NSString *nsCount  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        NSString *nsLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
        
        [self getRequest:@"index"
              parameters:@{@"c":nsCount,@"l":nsLang}
                 success:^(id  _Nonnull respones) {
                     
                     BOOL online = [[[respones valueForKey:@"data"] valueForKey:@"online"] boolValue];
                     [[NSUserDefaults standardUserDefaults] setBool:online forKey:@"TJLineKey"];
                     
                     BOOL show = [[[respones valueForKey:@"data"] valueForKey:@"show"] boolValue];
                     [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"TJshowKey"];
                     
                     BOOL audio = [[[respones valueForKey:@"data"] valueForKey:@"audio"] boolValue];
                     [[NSUserDefaults standardUserDefaults] setBool:audio forKey:@"TJaudioKey"];
                     
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         !(success)? : success();
                     });
                 } failure:^(NSError * _Nonnull error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         !(failure)? : failure(error);
                     });
                 }];
        
    }else{
        !(success)? : success();
    }
}


- (void)mj_config{
    [[TJ_HttpApi api] getRequest:@"config" parameters:@{} success:^(id  _Nonnull respones) {
        NSLog(@"%@", respones);
        
        NSDictionary *data = [respones valueForKey:@"data"];
        NSDictionary *admob = [data valueForKey:@"admob"];
        NSDictionary *alert = [data valueForKey:@"alert"];
        NSDictionary *banner = [data valueForKey:@"banner"];
        NSDictionary *review = [data valueForKey:@"review"];
        NSDictionary *gdtmob = [data valueForKey:@"gdtmob"];
        
        
        NSString *appId = [admob valueForKey:@"appId"];
        NSString *bannerId = [admob valueForKey:@"bannerId"];
        NSString *interstitialId = [admob valueForKey:@"interstitialId"];
        
        NSString *gdtAppId = [gdtmob valueForKey:@"appId"];
        NSString *gdtBannerId = [gdtmob valueForKey:@"bannerId"];
        NSString *gdtInterstitialId = [gdtmob valueForKey:@"interstitialId"];
        NSString *gdtNativeId = [gdtmob valueForKey:@"nativeId"];
        NSString *gdtSplashId = [gdtmob valueForKey:@"splashId"];
        NSString *gdtBundleId = [gdtmob valueForKey:@"bundleId"];

        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showAlert:alert];
                if ([self appRvStatus] != MJRvIn) return ;
                if (@available(iOS 10.3, *)) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SKStoreReviewController requestReview];
                    });
                }
        });
        
        if (appId && bannerId && interstitialId && appId.length) {
            [[NSUserDefaults standardUserDefaults] setObject:appId forKey:@"appId"];
            [[NSUserDefaults standardUserDefaults] setObject:bannerId forKey:@"bannerId"];
            [[NSUserDefaults standardUserDefaults] setObject:interstitialId forKey:@"interstitialId"];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bannerId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interstitialId"];
        }
        if (banner) {
            [[NSUserDefaults standardUserDefaults] setObject:banner forKey:@"banner"];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"banner"];
        }
        
        if (![self review]) {
            [[NSUserDefaults standardUserDefaults] setObject:review forKey:@"review"];
        }
        
        if (gdtAppId && gdtBannerId && gdtInterstitialId && gdtNativeId && gdtSplashId && gdtAppId.length) {
           
            [[NSUserDefaults standardUserDefaults] setObject:gdtAppId forKey:@"GDTAppId"];
            [[NSUserDefaults standardUserDefaults] setObject:gdtBannerId forKey:@"GDTBannerId"];
            [[NSUserDefaults standardUserDefaults] setObject:gdtInterstitialId forKey:@"GDTInterstitialId"];
            [[NSUserDefaults standardUserDefaults] setObject:gdtNativeId forKey:@"GDTNativeId"];
            [[NSUserDefaults standardUserDefaults] setObject:gdtSplashId forKey:@"GDTSplashId"];
            [[NSUserDefaults standardUserDefaults] setObject:gdtBundleId forKey:@"GDTBundleId"];

        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GDTAppId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GDTBannerId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GDTInterstitialId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GDTNativeId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GDTSplashId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GDTBundleId"];

        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)showAlert:(NSDictionary *)responseObject{

    NSString *title = [responseObject valueForKey:@"title"];
    NSString *msg = [responseObject valueForKey:@"msg"];
    NSArray *items = [responseObject valueForKey:@"items"];
    NSInteger count = [[responseObject valueForKey:@"count"] integerValue];
    
    NSInteger showCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"count"] integerValue];
    
    if(!count) [[NSUserDefaults standardUserDefaults] setObject:@(count) forKey:@"count"];
    
    if (items.count && count > showCount) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                         message:msg
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
        [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action  = [UIAlertAction actionWithTitle:[obj valueForKey:@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:[obj valueForKey:@"url"]];
                if(url && [[UIApplication sharedApplication] canOpenURL:url])[[UIApplication sharedApplication] openURL:url];
            }];
            [alertVC addAction:action];
        }];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
        
        
        showCount ++;
        [[NSUserDefaults standardUserDefaults] setObject:@(showCount) forKey:@"count"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"-------showAlert--------");
    }
}

- (MJRvStatus)appRvStatus{
    
    if (![self review]) {//没有配置信息 - 不评分
        
        return MJRvNone;
    }

    
    if (!MJShow) {//广告都不展示 有配置信息 - 不评分
        
        return MJRvNone;
    }
    
    NSInteger loadTimeCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loadTimeCount"] integerValue];
    NSInteger count = [[[self review] valueForKey:@"write"] integerValue];
    
    if (!MJOnLine) {//未上线 广告展示 有配置信息 - 内部评分
        
        if (loadTimeCount >= labs(count)) {
            return MJRvIn;
        }
        return MJRvNone;
        
    }
    
    //上线 广告展示 有配置信息
    if(count == 0){
        
        return MJRvNone;
    }else if (count > 0) {
        
        if (loadTimeCount >= count) {
            return MJRvOut;
        }
        return MJRvNone;
    }else{
        
        if (loadTimeCount >= labs(count)) {
            return MJRvIn;
        }
        return MJRvNone;
    }
}

- (NSDictionary *)review{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"review"];
}
//FIXME:  -  是否已经跳去评分了
- (void)applicationBecomeActive{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:
                               self.beginTime?self.beginTime:[NSDate date]];
    if (interval >= 8.0) {
        NSMutableDictionary *review = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"review"].mutableCopy;
        review[@"write"] = @(0);
        [[NSUserDefaults standardUserDefaults] setObject:review forKey:@"review"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)goReviewNextStep:(void(^)(void))step{
    
    if (self.appRvStatus == MJRvNone)  {
        
        !(step)? : step();
        return;
    }
    if (self.appRvStatus == MJRvIn) {
       
        !(step)? : step();
        return;
    }
    
    
    NSString *msg = [self review][@"title"];
    bool must = [[self review][@"must"] boolValue];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:msg
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *action  = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSURL *url = [NSURL URLWithString:writeURL];
            if(url){
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(applicationBecomeActive)
                                                             name:UIApplicationWillEnterForegroundNotification
                                                           object:nil];
                self.beginTime = [NSDate date];
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        [alertVC addAction:action];
    
        UIAlertAction *cannel  = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           if(!must) !(step)? : step();
        }];
        [alertVC addAction:cannel];

    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    

    
}


+ (NSString *)admobAppId{
    
    NSString *admobAppId =  [[NSUserDefaults standardUserDefaults] objectForKey:@"appId"];
    
    return admobAppId? admobAppId : kGoogleMobileAdsAppID;
}
+ (NSString *)admobBannerId{
    NSString *admobBannerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerId"];
    return admobBannerId? admobBannerId : kGoogleMobileAdsAppID;
    
}
+ (NSString *)admobInterstitialId{
    NSString *admobInterstitialId = [[NSUserDefaults standardUserDefaults] objectForKey:@"interstitialId"];
    return admobInterstitialId? admobInterstitialId : kGoogleMobileAdsAppID;
}



+ (NSString *)GDTAppId{
    
    NSString *GDTAppId =  [[NSUserDefaults standardUserDefaults] objectForKey:@"GDTAppId"];
    
    return GDTAppId? GDTAppId : @"";
}
+ (NSString *)GDTBannerId{
    NSString *GDTBannerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GDTBannerId"];
    return GDTBannerId? GDTBannerId : @"";
    
}
+ (NSString *)GDTInterstitialId{
    NSString *GDTInterstitialId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GDTInterstitialId"];
    return GDTInterstitialId? GDTInterstitialId : @"";
}
+ (NSString *)GDTNativeId{
    NSString *GDTNativeId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GDTNativeId"];
    return GDTNativeId? GDTNativeId : @"";
}
+ (NSString *)GDTSplashId{
    NSString *GDTSplashId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GDTSplashId"];
    return GDTSplashId? GDTSplashId : @"";
}
+ (NSString *)GDTBundleId{
    NSString *GDTBundleId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GDTBundleId"];
    return GDTBundleId? GDTBundleId : [[NSBundle mainBundle] bundleIdentifier];
}


//{
//img = "https://i.loli.net/2018/09/11/5b97982b0f268.jpeg";
//name = "\U6b22\U8fce\U4f7f\U7528";
//url = "";
//}
+ (NSArray *)banner{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
}



@end
