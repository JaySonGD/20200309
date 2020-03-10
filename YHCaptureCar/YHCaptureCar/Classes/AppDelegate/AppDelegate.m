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
#import "Constant.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "CheckNetwork.h"
#import "YHJspathAndVersionManager.h"
#import "YHNetworkManager.h"
#import "UIAlertController+Blocks.h"
#import "YHWebFuncViewController.h"
#import "YHMainViewController.h"
#import "YHTools.h"
#import "MGJRouter.h"
#import <UMCommon/UMCommon.h>   // 公共组件是所有友盟产品的基础组件，必选
#import <UMShare/UMShare.h>     // 分享组件
//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>

//高德地图基础类
#import <MAMapKit/MAMapKit.h>
//定义一个宏来保存高德的apikey
#define APIKEY @"72dd42f1ff8898baebb788ac6a22337a"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import <Bugly/Bugly.h>

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <JPush/JPUSHService.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define JPushAppKey @"4491f970fb2a631dfa823dbe"

@interface AppDelegate ()<JPUSHRegisterDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initNotification:launchOptions];
    
    [self setIQKeyboardManager];
    //地图定位
    [self initMap];
    
    //微信支付
    [self initWeChatPay];
    
    //分享
    [self initShare];
    
    [self setupBugly];
    
    return YES;
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
    
    config.version = [NSString stringWithFormat:@"%@(%@)-%@",version,buildVersion,@SERVER_JAVA_URL];
    
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:@"363d8a2cae"
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
}


#pragma mark - 地图定位
- (void)initMap
{
    // Override point for customization after application launch.
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = APIKEY;
    [AMapServices sharedServices].enableHTTPS = YES;
}

#pragma mark - 微信支付
- (void)initWeChatPay
{
    //
    //向微信注册
    [WXApi registerApp:kAppID withDescription:@"demo 2.0"];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
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
    NSString *newUagent = [NSString stringWithFormat:@"%@ YH_CaptureCar_IOS/%@", secretAgent, app_version];
    NSDictionary *dictionary = [[NSDictionary alloc]
                                initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
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

//FIXME:  -  将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
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
    [UIAlertController showAlertInViewController:[AppDelegate findCurrentShowingViewController] withTitle:title message:body cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"查看"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(controller.cancelButtonIndex == buttonIndex) return ;
        
        [self handleNotification:info];
    }];
    
}

- (void)handleNotification:(NSDictionary *)info{
    
//    if(!self.loginInfo){//未登录
//        self.remoteNotificationInfo = info;
//        return;
//    }
    
    if(![YHTools getAccessToken]){//请先注册或者登录
        return;
    }
    
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badgeNumber = badgeNumber?badgeNumber-1:0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    [JPUSHService setBadge:badgeNumber];
    NSString *carId = [info valueForKey:@"carId"] ? [info valueForKey:@"carId"] : @"";
    NSString *type = [info valueForKey:@"type"] ? [info valueForKey:@"type"] : @"";
    NSString *isFlag = @"1";
    
    NSDictionary *orderInfo = @{@"carId":carId,
                                 @"isFlag":isFlag,
//                                @"billType":billType,
//                                @"nowStatusCode":nowStatusCode,
//                                @"channelCode":channelCode,
                                @"type":type
                                };
    [self orderDetailNavi:orderInfo];
}

//执行跳转
- (void)orderDetailNavi:(NSDictionary*)orderInfo{
    
    UIViewController *currentViewController = [AppDelegate findCurrentShowingViewController];
    
    if([orderInfo[@"type"] isEqualToString:@"helpBuyCarInfo"]){
    [MGJRouter openURL:@"open://YTDetailViewController"
          withUserInfo:@{@"gotoVC" : currentViewController,
                         @"orderInfo" : orderInfo
                         }
            completion:nil];
    }
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
//FIXME:  -  前台调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
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
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
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

//极光推送 角标清0 未读消息不清空
//本地推送UILocalNotification的applicationIconBadgeNumber影响到角标的显示，不出对通知栏的消息造成影响
//3.UIApplication的applicationIconBadgeNumber属性既会影响角标的显示，又会影响通知栏通知的处理。
//1）当applicationIconBadgeNumber>0时，角标会随之变化，通知栏通知不变。
//2）当applicationIconBadgeNumber＝0时，角标变为0不显示，通知栏通知清空。
//3）当applicationIconBadgeNumber<0时，角标变为0不显示，通知栏通知清空。
//所以要想不清除通知栏内容，极光就不能设置这个：[UIApplication sharedApplication].applicationIconBadgeNumber = 0;,极光的cleanBadgeNum方法也不能用。
-(void)applicationWillResignActive:(UIApplication *)application {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
        } else {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            // 设置通知的发送时间,单位秒
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
            //收到通知时App icon的角标
            localNotification.applicationIconBadgeNumber = -1;
            // 3.发送通知(🐽 : 根据项目需要使用)
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
    [JPUSHService setBadge:0];
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
//#warning 更新APP下载地址
   [[YHJspathAndVersionManager sharedYHJspathAndVersionManager] versionManage:@"https://itunes.apple.com/us/app/%E6%8D%95%E8%BD%A6/id1207720514?mt=8"];
    
    //自动登录(MWF)
    if([YHTools getAccessToken]) {
        [[YHNetworkManager sharedYHNetworkManager]login:[YHTools getName]
                                               password:[[YHTools md5:[NSString stringWithFormat:@"%@",  [YHTools getPassword]]]lowercaseString]
                                               //password:[YHTools md5:[NSString stringWithFormat:@"%@%@", [YHTools getName], [YHTools getPassword]]]
                                             onComplete:^(NSDictionary *info)
        {
            NSLog(@"---------====缓存名:%@====自动登录:%@====%@====----------",[YHTools getName],info,info[@"retMsg"]);
             if ([info[@"retCode"] isEqualToString:@"0"]) {
                 NSDictionary *result = info[@"result"];
                 [YHTools setAccessToken:result[@"token"]];
             }else{
                 YHLogERROR(@"");
             }
         } onError:^(NSError *error) {
             
         }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        result = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
    if (!result) {
        // 跳转报告 buche779343://report/{报告id}
        NSString *codeValue = [url.query componentsSeparatedByString:@"="].lastObject;
        [YHTools setReportJumpCode:codeValue];
        if ([YHTools getAccessToken]) {
            
            // 此处调接口只是为了验证token是否失效
            [[YHNetworkManager sharedYHNetworkManager] userInfo:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
                
                NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
                if (![retCode isEqualToString:@"COMMON016"]) {
                
                    YHWebFuncViewController *webVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                  NSString *urlString =  [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk"/enquiryPrice.html?code=%@&token=%@",[YHTools getReportJumpCode],[YHTools getAccessToken]];
                    webVC.urlStr = urlString;
                    [YHTools setIsReportJump:YES];
                    YHMainViewController *mainVc = (YHMainViewController *)self.window.rootViewController;
                    UINavigationController *mainNaViVc = (UINavigationController *)mainVc.contentViewController;
                    [mainNaViVc pushViewController:webVC animated:YES];
                    
                    // 置空ReportJumpCode
                    [YHTools setReportJumpCode:nil];
                }
                
            } onError:^(NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
            
            }];
        }
    }
    return result;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    self.handler = completionHandler;
}


+ (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
/* 完整的描述请参见文件头部 */
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if([vc isKindOfClass:[YHMainViewController class]]){
        
        UIViewController *nextRootVC = [(YHMainViewController *)vc contentViewController];
         currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    }else{
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;
}

@end
