
#import <CocoaLumberjack/CocoaLumberjack.h>
#define YHProduction //生产
//#define YHTest //测试
//#define YHDebugData //开发数据
#define  TestError
//#define  NetworkTest
#define  ShowLog


#define CarInterval @"20"
#define LoginTimeout @"COMMON016" //登录过期
#define UserException @"BUCHE021" //用户状态异常

#define JsonDataCheckoutFailure @"COMMON200" //网络返回数据检验失败
#define Timeout 60
#define AlertDelay 1.
// 1.判断是否为iOS7
#define moreTheIOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS7 (7.0 <=[[UIDevice currentDevice].systemVersion doubleValue] < 8.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

#define YHExtrendBackColor  [UIColor colorWithRed:83/255.0 green:187/255.0 blue:141/255.0 alpha:1.0]
#define YHNaviColor  YHColor0X(0XD1B182, 1)
#define YHWordColor [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]
#define YHLineColor [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]
#define YHCellColor [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]
#define YHBackgroundColor [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]
#define YHHeaderTitleColor [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]
#define YHLocationTitleColor [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1.0]

#define YHBlackColor [UIColor blackColor]
#define YHWhiteColor [UIColor whiteColor]
#define YHRedColor   [UIColor redColor]
#define YHLightGrayColor [UIColor lightGrayColor]

#define EmptyStr(str) ((str == nil || str == [NSNull null]) ? (@"") : (str))
#define IsEmptyStr(str) (str == nil || [@"" isEqualToString:str] || ((id)str == [NSNull null]))
#define addCarParameter(keys, parameters, key, value)  if (value != nil && ![value isEqualToString:str]) {\
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
//十六进制 颜色创建
#define YHColor0X(rgb, a) [UIColor colorWithRed:((rgb >> 16) & 0XFF)/255.0 green:((rgb >> 8) & 0XFF)/255.0 blue:(rgb & 0XFF)/255.0 alpha:a]
//主题颜色
#define ZTColor [UIColor colorWithRed:68/255.0 green:70/255.0 blue:82/255.0 alpha:1.0]
#define ZTTColor [UIColor colorWithRed:253/255.0 green:83/255.0 blue:0/255.0 alpha:0.5]

//获取屏幕bounds 长度 宽度
#define screenBound [UIScreen mainScreen].bounds
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height


#define buildTime [YHTools stringFromDate:[NSDate date] byFormatter:@"YYYY-MM-dd HH:mm:ss"]
#define buildTimeVersionMannger [YHTools stringFromDate:[NSDate date] byFormatter:@"YYYYMMddHHmmss"]
// 自定义Log
#ifdef ShowLog
#define YHLog(fmt, ...) DDLogInfo((@"PCDebug : [%s]" "[%s]" "[%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define YHLogERROR(fmt, ...) DDLogInfo((@"PCDebugError : [%s]" "[%s]" "[%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
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
#define IphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height>20)
#define  kStatusBarAndNavigationBarHeight  (IphoneX ? 88.f : 64.f)
#define SafeAreaBottomHeight (IphoneX?34:0)
#define TabbarHeight (IphoneX?83:49) // 适配iPhone x 底栏高度
#define NavbarHeight (IphoneX?88:64) // 适配iPhone x 导航栏高度
#define  kTabbarSafeBottomMargin         (IphoneX ? 34.f : 0.f)


#define DebugTime YHLog(@"debugTime : %@", [YHTools getDateStr]);

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

#define WeakSelf __weak typeof(self) weakSelf = self;

//#define  YHImage(@"imageName") [UIImage imageNamed:imageName];
//__weak __typeof__(self) weakSelf = self;

////通知
//UIKIT_EXTERN NSNotificationName const UITextFieldTextDidBeginEditingNotification;
//UIKIT_EXTERN NSNotificationName const UITextFieldTextDidEndEditingNotification;
//UIKIT_EXTERN NSNotificationName const UITextFieldTextDidChangeNotification;
#define PopToBeDetectionVCNotification @"popToBeDetectionVCNotification"


#define PushController(boardName, storyboardId)\
PushControllerAnimated(boardName, storyboardId, YES);

#define PushControllerAnimated(boardName, storyboardId, isAnimated)\
PushControllerBlockAnimated(boardName, storyboardId, ;, isAnimated);

#define PushControllerBlockAnimated(boardName, storyboardId, block, isAnimated)\
UIStoryboard *board = [UIStoryboard storyboardWithName:boardName bundle:nil];\
UIViewController *controller = [board instantiateViewControllerWithIdentifier:storyboardId];\
block\
[self.navigationController pushViewController:controller animated:isAnimated];

