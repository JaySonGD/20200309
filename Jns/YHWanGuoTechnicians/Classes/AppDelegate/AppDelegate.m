//
//  AppDelegate.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/8.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

//#import <BaiduMapAPI_Location/BMKLocationService.h>
//#import <BaiduMapAPI_Map/BMKMapView.h>
#import "AppDelegate.h"
#import "YHTools.h"
#import "YHFunctionsEditerController.h"
//#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "WXApi.h"
#import "Constant.h"
#import "WXApiManager.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <HanyuPinyinOutputFormat.h>
#import <PinyinHelper.h>
#import "CheckNetwork.h"
#import "YHJspathAndVersionManager.h"
#import <IQKeyboardManager.h>
#import <IQKeyboardManager.h>
#import <UMCommon/UMCommon.h>   // 公共组件是所有友盟产品的基础组件，必选
#import <UMShare/UMShare.h>     // 分享组件

#import <Bugly/Bugly.h>

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <JPush/JPUSHService.h>

#import "YHWebFuncViewController.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+OrderDetail.h"

#import "YHStudyVersionNaviController.h"
#import "YHStudyVersionWebController.h"
#import <MJExtension.h>
#import "YHMainNavigationController.h"
#import <UShareUI/UMSocialShareUIConfig.h>
#import "AppDelegate+HttpEnv.h"

NSString *const notificationLocationChange = @"YHNotificationLocationChange";
NSString *const notificationLocationFail = @"YHNotificationLocationFail";

//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
#import <MAMapKit/MAMapKit.h>
//定义一个宏来保存高德的apikey
#define APIKEY @"7fe72ecf424f234896e9069c3101f9c4"
#define EDU_API_KEY @"785dfd91ae060f316d6af06f5e8cfe3c"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define JPushAppKey @"cabbdd0f3861cdb5cba07555"


@interface AppDelegate ()<UIAlertViewDelegate,JPUSHRegisterDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //    [YHTools setAccessToken:@"135c6f9fda95913b5a41a76ed7a7fd1c1"];
    //    [YHTools setAccessToken:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
#ifdef LearnVersion
    
    YHWebFuncViewController *webStudyVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    webStudyVC.urlStr = webUrl;
    webStudyVC.barHidden = YES;
    YHStudyVersionNaviController *naviStudyVC = [[YHStudyVersionNaviController alloc] initWithRootViewController:webStudyVC];
    self.window.rootViewController = naviStudyVC;
#else
    YHMainNavigationController *mainNaviVc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHMainNavigationController"];
    self.window.rootViewController = mainNaviVc;
    
#endif
    
    [self.window makeKeyAndVisible];
    
    // 初始化操作
    [self initSdkBaseSet];
    
    [self initNotification:launchOptions];
    
    [self loadVirtualView];

    return YES;
}

- (void) setupBugly{
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    
#if DEBUG
    config.channel = @"Debug";
#else
    config.channel = @"AppStore";
#endif
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [info valueForKey:@"CFBundleVersion"];
    
    config.version = [NSString stringWithFormat:@"%@(%@)-%@",version,buildVersion,SERVER_PHP_URL];
    
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:@"5ed290b469"
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
}

//FIXME:  -  设置推送别名
- (void)setLoginInfo:(NSDictionary *)loginInfo{
    _loginInfo = loginInfo;
    
    NSString *shopOpenId = [[loginInfo valueForKey:@"data"] valueForKey:@"shopOpenId"];
    NSString *userOpenId = [[loginInfo valueForKey:@"data"] valueForKey:@"userOpenId"];
    NSString *aliasName = [NSString stringWithFormat:@"%@_%@",shopOpenId?shopOpenId:@"",userOpenId?userOpenId:@""];
    
    if (shopOpenId || userOpenId) {
        [JPUSHService setAlias:[YHTools md5:aliasName] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"%s---设置推送别名 --- %@", __func__,iAlias);
        } seq:999];
        if (self.remoteNotificationInfo) {
            [self handleNotification:self.remoteNotificationInfo];
            self.remoteNotificationInfo = nil;
        }
    }else{
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"%s---删除推送别名 --- %@", __func__,iAlias);
        } seq:999];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
    NSLog(@"%s---登录成功", __func__);
}

- (void)initNotification:(NSDictionary *)launchOptions{
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:nil
                 apsForProduction:NO];
#else
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:nil
                 apsForProduction:YES];
#endif
    
    //获取展示过的通知
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].applicationIconBadgeNumber = notifications.count;
                [JPUSHService setBadge:notifications.count];
            });
        }];
    }
}

- (void)initSdkBaseSet{
    
    [self setIQKeyboardManager];   //设置键盘管理者
    
    [[AMapServices sharedServices] setEnableHTTPS:YES];
#ifdef LearnVersion
    [AMapServices sharedServices].apiKey = EDU_API_KEY;
#else
    [AMapServices sharedServices].apiKey = APIKEY;
#endif
    [AMapServices sharedServices].enableHTTPS = YES;

    
    if (![YHTools getExtendSearchKeys]) {
        [YHTools setExtendSearchKeys:@[@"空调系统", @"发动机+变速箱+传动系统", @"空调系统+发动机+变速箱+传动系统", @"全车六大系统套餐"]];
    }
    if ( [YHTools getFunctions] == nil) {
        [YHTools setFunctions:@[]];
    }
    //
    //向微信注册
    [WXApi registerApp:kAppID withDescription:@"demo 2.0"];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    
    //分享(MWF)
    [self initShare];
    
    [self setupBugly];
}

- (void)setIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    /**
     *  控制整个功能是否启用。
     */
    manager.enable = YES;
    
    /**
     *  控制点击背景是否收起键盘。
     */
    manager.shouldResignOnTouchOutside = YES;
    
    /**
     *  控制键盘上的工具条文字颜色是否用户自定义
     */
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    /**
     *  控制是否显示键盘上的工具条。
     */
    manager.enableAutoToolbar = YES;
    
}

#pragma mark - 初始化友盟分分享
- (void)initShare
{
    // 配置友盟SDK产品并并统一初始化
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
    //[UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    
    [UMConfigure initWithAppkey:kUMengKey channel:@"App Store"];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    
    // 请参考「Share详细介绍-初始化第三方平台」
    // 分享组件配置，因为share模块配置可选三方平台较多，代码基本跟原版一样，也可下载demo查看
    // [self configUSharePlatforms];   // required: setting platforms on demand
    
    // 配置分享平台
    [self configUSharePlatforms];
    
    // 配置分享设置
    [self confitUShareSettings];
    
}

#pragma mark - 配置分享设置
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

#pragma mark - 配置分享平台
- (void)configUSharePlatforms
{
    
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = 0;
    
    
    /* 1.设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppID appSecret:kAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 2.设置朋友圈的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:kAppID appSecret:kAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 3.设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 4.设置分享到QQ空间 */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:kQQAppID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

+ (void)initialize {
    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *newUagent = [NSString stringWithFormat:@"%@ YH_JNS_IOS/%@ ", secretAgent, app_version];
    
#ifdef LearnVersion
    //来京教育微信支付直接使用扫描支付标示
    newUagent = [NSString stringWithFormat:@"%@ WX_YH_IOS_PC/%@", newUagent, app_version];
#endif
    NSDictionary *dictionary = [[NSDictionary alloc]
                                initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}


//FIXME:  -  将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenStr:\n%@",deviceTokenStr);
    
}

//FIXME:  -  注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"error -- %@",error);
    
}
#pragma mark- JPUSHRegisterDelegate

- (void)showNotificationAlert:(NSDictionary *)info{
    NSLog(@"%s--推送内容--%@", __func__,info);
    NSDictionary *alert = [[info valueForKey:@"aps"] valueForKey:@"alert"];
    NSString *title = [alert valueForKey:@"title"];
    NSString *body = [alert valueForKey:@"body"];
    [UIAlertController showAlertInViewController:self.window.currentViewController withTitle:title message:body cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"查看"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(controller.cancelButtonIndex == buttonIndex) return ;
        
        [self handleNotification:info];
    }];
    
}

- (void)handleNotification:(NSDictionary *)info{
    
    if(!self.loginInfo){//未登录
        self.remoteNotificationInfo = info;
        return;
    }
    
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badgeNumber = badgeNumber?badgeNumber-1:0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    [JPUSHService setBadge:badgeNumber];
    NSString *billId = [info valueForKey:@"billId"] ? [info valueForKey:@"billId"] : @"";
    NSString *type = [info valueForKey:@"type"] ? [info valueForKey:@"type"] : @"";
    NSString *nextStatusCode = [info valueForKey:@"nextStatusCode"] ? [info valueForKey:@"nextStatusCode"] : @"";
    NSString *nowStatusCode = [info valueForKey:@"nowStatusCode"] ? [info valueForKey:@"nowStatusCode"] : @"";
    NSString *billType = [info valueForKey:@"billType"] ? [info valueForKey:@"billType"] : @"";
    NSString *channelCode = info[@"channelCode"] ? info[@"channelCode"] : @"";
//
    UIViewController *currentViewController = self.window.currentViewController;
    //    UINavigationController *nav = nil;
    //
    //    if ([currentViewController isKindOfClass:[UINavigationController class]]) {
    //        nav = (UINavigationController *)currentViewController;
    //    }else if ([currentViewController.navigationController isKindOfClass:[UINavigationController class]]) {
    //        nav = currentViewController.navigationController;
    //    }
    NSDictionary *orderInfo = @{@"id":billId,
                                @"nextStatusCode":nextStatusCode,
                                @"billType":billType,
                                @"nowStatusCode":nowStatusCode,
                                @"channelCode":channelCode,
                                @"type":type
                                };
    [currentViewController orderDetailNavi:orderInfo code:YHFunctionIdNewWorkOrder];
    
    //    return;
    //    if ([type isEqualToString:@"bill_appointment"] && [nextStatusCode isEqualToString:@"consulting"]) {//预约推送
    //
    //        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    //        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    //        controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_H5@SERVER_PHP_H5_Trunk"/index.html?token=%@&billId=%@&status=ios", [YHTools getAccessToken], billId];
    //        controller.title = @"工单";
    //        controller.barHidden = YES;
    //        if(nav) [nav pushViewController:controller animated:YES];
    //        else [currentViewController presentViewController:controller animated:YES completion:nil];
    //
    //    }else if ([type isEqualToString:@"bill_consulting"] && [nextStatusCode isEqualToString:@"initialSurvey"]){//派工
    //
    //        if ([billType isEqualToString:@"J002"]) {//安检
    //
    //        }else{//初检
    //
    //        }
    //    }else{
    //        NSLog(@"%s---无效路由", __func__);
    //    }
}

// iOS 10 Support
//FIXME:  -  前台调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    //[self showNotificationAlert:userInfo];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
//FIXME:  -  前后台杀死点击通知调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self handleNotification:userInfo];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

//iOS10以下的处理
//FIXME:  -  前后台调用（content-available = 1） 优先级低
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //实现你接收到远程推送的消息处理代码；
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    // Required,For systems with less than or equal to iOS6
    [self handleNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    
}
//iOS10以下的处理
//FIXME:  -  前后台调用（content-available = 1）优先级高
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    [self handleNotification:userInfo];

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (BOOL)jnsHandleOpenURL:(NSURL *)url{
    NSString *sourceURLString = url.absoluteString;
    if ([sourceURLString hasPrefix:@"jns779343://"]) {
        sourceURLString = [sourceURLString stringByReplacingOccurrencesOfString:@"jns779343://" withString:@""];
        NSString *json = [YHTools decodeString:sourceURLString];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        if (obj) {
            [self handleNotification:obj];
        }
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL jnsResult = [self jnsHandleOpenURL:url];

    if (!result && !jnsResult) {
        // 其他如支付等SDK的回调
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}

// 支持所有iOS系统
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    BOOL jnsResult = [self jnsHandleOpenURL:url];

    if (!result && !jnsResult) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#ifdef LearnVersion
#else
    [[YHJspathAndVersionManager sharedYHJspathAndVersionManager] versionManage:@"https://itunes.apple.com/cn/app/云诊断-技师/id1159208817?mt=8"];
#endif

}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    self.handler = completionHandler;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
#ifdef LearnVersion
    
     return UIInterfaceOrientationMaskAll;
    
#else
    
    if (_allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
    
#endif
   
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return _allowRotation;
}
@end
