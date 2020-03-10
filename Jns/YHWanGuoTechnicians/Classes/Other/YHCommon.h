
#ifdef Test
    #define YHTest //测试

    #define kHttpEnvInt ([[[NSUserDefaults standardUserDefaults] objectForKey:@"kHttpEnv"] integerValue])

#elif DEBUG
//    #define YHProduction //生产
//    #define YHProduction_Demo //生产demo
    #define YHTest //测试
//    #define YHDev //开发
//    #define YHLocation //本地



    #ifdef YHTest

        #define kHttpEnvInt 3

    #endif
#else
    #define YHProduction //生产
//    #define YHDev //开发
#endif




//#define YHDebugData //开发数据
//#define  TestError
//#define  NetworkTest
//
// 1 :小虎检车   0: 烟台工贸技师学院
/**
 默认来京账号
 老师 10000000000 密码 123456
 学生 11000000000 密码 123456
 */
#define isSmallTigerCheck 1


#define CarInterval @"10"
#define LoginTimeout @"COMMON016" //登录过期
#define Timeout 60
#define AlertDelay 1.
// 1.判断是否为iOS7
#define moreTheIOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS7 (7.0 <=[[UIDevice currentDevice].systemVersion doubleValue] < 8.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

#define YHExtrendBackColor  [UIColor colorWithRed:83/255.0 green:187/255.0 blue:141/255.0 alpha:1.0]
#define YHNaviColor  [UIColor colorWithRed:70/255.0 green:174/255.0 blue:247/255.0 alpha:1.0]
#define YHWordColor [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]
#define YHLineColor [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]
#define YHCellColor [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]
#define YHBackgroundColor [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]
#define YHHeaderTitleColor [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]
#define YHLocationTitleColor [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1.0]
#define YHBlackOneColor  [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0]
#define YHBlackColor [UIColor blackColor]

#define YHNagavitionBarTextColor [UIColor blackColor]
#define YHWhiteColor [UIColor whiteColor]
#define YHRedColor   [UIColor redColor]
#define YHLightGrayColor [UIColor lightGrayColor]

#define EmptyStr(str) ((str == nil || str == [NSNull null]) ? (@"") : (str))
#define IsEmptyStr(str) (str == nil || (((id)str == [NSNull null])? (YES) : ([(NSString*)str isEqualToString:@""])))
#define addCarParameter(keys, parameters, key, value)  if (value != nil && ![value isEqualToString:@""]) {\
keys = [keys stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];\
[parameters setObject:value forKey:key];\
}

#define YHLayerBorder(view, color, width) \
view.layer.borderColor  = color.CGColor; \
view.layer.borderWidth  = width;

#define YHViewRadius(View,Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@" "] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

// 获得RGB颜色
#define YHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define YHColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//主题颜色
#define ZTColor [UIColor colorWithRed:253/255.0 green:83/255.0 blue:0/255.0 alpha:1.0]
#define ZTTColor [UIColor colorWithRed:253/255.0 green:83/255.0 blue:0/255.0 alpha:0.5]

#define YHColorWithHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define YHRandomColor YHColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//获取屏幕bounds 长度 宽度
#define IphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height>20)
#define NavbarHeight (IphoneX?88:64) // 适配iPhone x 导航栏高度
#define SafeAreaBottomHeight (IphoneX ? 14 : 0)
#define screenBound [UIScreen mainScreen].bounds
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

//弱引用self
#define WeakSelf __weak typeof(self) weakSelf = self;

#define buildTime [YHTools stringFromDate:[NSDate date] byFormatter:@"YYYYMMddHHmmss"]
// 自定义Log
#ifdef DEBUG
#define YHLog(fmt, ...) NSLog((@"YHDebug : [文件名:%s]" "[函数名:%s]" "[行号:%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define YHLogERROR(fmt, ...) NSLog((@"YHDebugError : [文件名:%s]" "[函数名:%s]" "[行号:%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define YHLog(...)
#define YHLogERROR(...)
#endif

#define currentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]

// 常用的对象
#define YHNotificationCenter [NSNotificationCenter defaultCenter]
#define YHNSUserDefaults [NSUserDefaults standardUserDefaults]
#define YHNSFileManager [NSFileManager defaultManager]
//#define YHAutoLayout(item) (item##.constant = item##.homeButtonCL.constant / 667.) * [UIScreen mainScreen].bounds.size.height)
//#define YHAutoLayout(item)  item.constant//(item##.constant = 1)
// 是否为3.5inch


#define YHAutoLayout(item) (item / 667.) * [UIScreen mainScreen].bounds.size.height;


#define inch3_5 ([UIScreen mainScreen].bounds.size.height == 480.)
// 是否为4inch
#define inch4_0 ([UIScreen mainScreen].bounds.size.height == 568.)
// 是否为4.7inch
#define inch4_7 ([UIScreen mainScreen].bounds.size.height == 667.)
// 是否为5.5inch
#define inch5_5 ([UIScreen mainScreen].bounds.size.height == 736.)


// 是否为6
#define Iphone6 ([UIScreen mainScreen].bounds.size.width == 375.)
// 是否为6Plus
#define Iphone6Plus ([UIScreen mainScreen].bounds.size.width == 414.)
// iPhone X
#define  iPhoneX ((kStatusBarHeight >20) ? YES : NO)
// Status bar height.
// #define  StatusBarHeight      (iPhoneX ? 44.f : 20.f)
#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height
// Navigation bar height.
#define  kNavigationBarHeight  44.f
// Tabbar height.
#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)


//View圆角和加边框
#define kViewBorderRadius(View,Radius,Width,Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
// View圆角
#define kViewRadius(View,Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


// 常用的对象
#define FTNotificationCenter [NSNotificationCenter defaultCenter]

// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \


#ifdef YHProduction
//生产
#define signKey @"402881yy55dcd8ad0155dddd7f89006a"
#define HmacSHA1Key @"R2hBjRIUXsvCaP8HM3EoD" //HmacSHA1加密 key
#define HmacSHA1KeyJns @"JLmYRlpzEPuoSFfKpo2udi9RoQSXvo3X" //认证检测图片key
//轮播图
#define SERVER_JAVA_IMAGE_URL @"http://img.wanguoqiche.cn/"  //生产
//非认证检测图片
#define SERVER_JAVA_NonAuthentication_IMAGE_URL @"https://img.51buche.com/"

#define SERVER_JAVA_NavTitle_IMAGE_URL @"https://images.mhace.cn/cloudImg/shopApply"
//首页icon地址
#define SERVER_HOME_ICON_IMAGE_URL @"https://www.wanguoqiche.com/"
#define EnvTitle @"JNS数据云" //环境标识
#define NavEnvTitle @"" //环境标识

#endif


#ifdef YHProduction_Demo
//生产demo
#define signKey @"4028816455dcd8ad0155dddd7f89006a"
#define HmacSHA1Key @"R2hBjRIUXsvCaP8HM3EoD" //HmacSHA1加密 key
#define HmacSHA1KeyJns @"JLmYRlpzEPuoSFfKpo2udi9RoQSXvo3X" //认证检测图片key
//轮播图
#define SERVER_JAVA_IMAGE_URL @"http://imgs.static.com/"  //开发
//非认证检测图片
#define SERVER_JAVA_NonAuthentication_IMAGE_URL @"http://192.168.1.200/"

#define SERVER_JAVA_NavTitle_IMAGE_URL @"https://images.mhace.cn/cloudImg/shopApply"

#define EnvTitle @"JNS数据云" //环境标识
#define NavEnvTitle @"" //环境标识
#endif

#ifdef YHTest
//测试环境
//#define signKey @"4028816455dcd8ad0155dddd7f89006a"
#define signKey (@[@"402881yy55dcd8ad0155dddd7f89006a",@"4028816455dcd8ad0155dddd7f89006a",@"4028816455dcd8ad0155dddd7f89006a",@"4028816455dcd8ad0155dddd7f89006a"][kHttpEnvInt])

//#define HmacSHA1Key @"f0ea01e0abc311e6bc3ffcaa14ff071e" //HmacSHA1加密 key
#define HmacSHA1Key (@[@"R2hBjRIUXsvCaP8HM3EoD",@"R2hBjRIUXsvCaP8HM3EoD",@"f0ea01e0abc311e6bc3ffcaa14ff071e",@"f0ea01e0abc311e6bc3ffcaa14ff071e"][kHttpEnvInt])

//#define HmacSHA1KeyJns @"f0ea01e0abc311e6bc3ffcaa14ff071e" //认证检测图片key
#define HmacSHA1KeyJns (@[@"JLmYRlpzEPuoSFfKpo2udi9RoQSXvo3X",@"JLmYRlpzEPuoSFfKpo2udi9RoQSXvo3X",@"f0ea01e0abc311e6bc3ffcaa14ff071e",@"f0ea01e0abc311e6bc3ffcaa14ff071e"][kHttpEnvInt])

//轮播图
//#define SERVER_JAVA_IMAGE_URL @"http://imgs.static.com/"  //开发
#define SERVER_JAVA_IMAGE_URL (@[@"http://img.wanguoqiche.cn/",@"http://imgs.static.com/",@"http://imgs.static.com/",@"http://imgs.static.com/"][kHttpEnvInt])

//非认证检测图片
//#define SERVER_JAVA_NonAuthentication_IMAGE_URL @"http://192.168.1.220/"
#define SERVER_JAVA_NonAuthentication_IMAGE_URL (@[@"https://img.51buche.com/",@"http://192.168.1.200/",@"http://192.168.1.200/",@"http://192.168.1.220/"][kHttpEnvInt])

//#define SERVER_JAVA_NavTitle_IMAGE_URL @"http://192.168.1.220/bcFiles/shopApply"
#define SERVER_JAVA_NavTitle_IMAGE_URL (@[@"https://images.mhace.cn/cloudImg/shopApply",@"http://192.168.1.200/bcFiles/shopApply",@"http://192.168.1.200/bcFiles/shopApply",@"http://192.168.1.220/bcFiles/shopApply"][kHttpEnvInt])

//首页icon地址
#define SERVER_HOME_ICON_IMAGE_URL (@[@"https://www.wanguoqiche.com/",@"http://192.168.1.200/",@"http://192.168.1.200/",@"http://192.168.1.220/"][kHttpEnvInt])

//#define EnvTitle @"JNS数据云(测试)" //环境标识
#define EnvTitle (@[@"JNS数据云",@"JNS数据云(本地)",@"JNS数据云(开发)",@"JNS数据云(测试)"][kHttpEnvInt])

//#define NavEnvTitle @"(测试)" //环境标识
#define NavEnvTitle (@[@"",@"(本地)",@"(开发)",@"(测试)"][kHttpEnvInt])

#endif

#ifdef YHDev
#define signKey @"4028816455dcd8ad0155dddd7f89006a"
#define HmacSHA1Key @"f0ea01e0abc311e6bc3ffcaa14ff071e" //HmacSHA1加密 key
#define HmacSHA1KeyJns @"f0ea01e0abc311e6bc3ffcaa14ff071e" //认证检测图片key
//轮播图
#define SERVER_JAVA_IMAGE_URL @"http://imgs.static.com/"  //开发
//非认证检测图片
#define SERVER_JAVA_NonAuthentication_IMAGE_URL @"http://192.168.1.200/"

#define SERVER_JAVA_NavTitle_IMAGE_URL @"http://192.168.1.200/bcFiles/shopApply"

//首页icon地址
#define SERVER_HOME_ICON_IMAGE_URL @"http://192.168.1.200/"

#define EnvTitle @"JNS数据云(开发)" //环境标识
#define NavEnvTitle @"(开发)" //环境标识
#endif

#ifdef YHLocation
#define signKey @"4028816455dcd8ad0155dddd7f89006a"
#define HmacSHA1Key @"R2hBjRIUXsvCaP8HM3EoD" //HmacSHA1加密 key
#define HmacSHA1KeyJns @"JLmYRlpzEPuoSFfKpo2udi9RoQSXvo3X" //认证检测图片key
//轮播图
#define SERVER_JAVA_IMAGE_URL @"http://imgs.static.com/"  //开发
//非认证检测图片
#define SERVER_JAVA_NonAuthentication_IMAGE_URL @"http://192.168.1.200/"

#define SERVER_JAVA_NavTitle_IMAGE_URL @"http://192.168.1.200/bcFiles/shopApply"

//首页icon地址
#define SERVER_HOME_ICON_IMAGE_URL @"http://192.168.1.200/"

#define EnvTitle @"JNS数据云(本地)" //环境标识
#define NavEnvTitle @"(本地)" //环境标识
#endif

