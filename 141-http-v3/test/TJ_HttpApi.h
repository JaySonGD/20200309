
#import <UIKit/UIKit.h>


#ifdef DEBUG
// google
// 测试 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-3940256099942544~1458002511"
//插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-3940256099942544/4411468910"
//横幅广告ID
#define kGoogleMobileAdsBannerID  @"ca-app-pub-3940256099942544/6300978111"
//激励广告ID
#define kGoogleMobileAdsVideoID  @"ca-app-pub-3940256099942544/1712485313"

#else
// google
// 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-8803735862522697~2675111215"
////插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-8803735862522697/9021027714"
////横幅广告ID
#define kGoogleMobileAdsBannerID  @"ca-app-pub-8803735862522697/2347808153"
//激励广告ID
#define kGoogleMobileAdsVideoID  @"ca-app-pub-8803735862522697/9127310868"

#endif


#define MJOnLine [[NSUserDefaults standardUserDefaults] boolForKey:@"TJLineKey"]
#define MJShow [[NSUserDefaults standardUserDefaults] boolForKey:@"TJshowKey"]
#define MJAudio  [[NSUserDefaults standardUserDefaults] boolForKey:@"TJaudioKey"]

#define writeURL @"itms-apps://itunes.apple.com/app/id1469382584?action=write-review"
#define downLoadURL @"http://itunes.apple.com/us/app/id1469382584"


@interface TJ_HttpApi : NSObject


+ (instancetype)api;

+ (void)registerAppKey:(NSString *)appKey
         base64BaseURL:(NSString *)base64URL;

- (void)getRequest:(NSString *)url
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure;

- (void)appInitSuccess:(void(^)(void))success
               failure:(void(^)(NSError *error))failure;

- (void)goReviewNextStep:(void(^)(void))step;

+ (NSString *)admobAppId;
+ (NSString *)admobBannerId;
+ (NSString *)admobInterstitialId;

+ (NSString *)GDTAppId;
+ (NSString *)GDTBannerId;
+ (NSString *)GDTInterstitialId;
+ (NSString *)GDTNativeId;
+ (NSString *)GDTSplashId;
+ (NSString *)GDTBundleId;


+ (NSArray *)banner;


@end
