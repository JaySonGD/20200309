//
//  AppDelegate.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/17.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppDelegate.h"
#import "PCBluetoothManager.h"
#import "LenovoIDInlandSDK.h"

#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "ThirdLoginViewController.h"
#import "ThirdLoginOverseasViewController.h"
//#import "YHNetworkManager.h"
//#import "YHTools.h"
#import "YHTools.h"
#import "WXApi.h"
#import "WeChatManager.h"
#import "Constant.h"
#import <UMCommon/UMCommon.h>   // 公共组件是所有友盟产品的基础组件，必选
#import <UMShare/UMShare.h>     // 分享组件
#import "YHCommon.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


static const DDLogLevel ddLogLevel = DDLogLevelInfo;
extern NSString *const notificationAppActive;

extern NSString *const notificationRefreshTokenDelegate;

@interface AppDelegate (){
    
    HTTPServer *httpServer;
}

@property (nonatomic,assign) BOOL idle;
@property (nonatomic,strong)UINavigationController *thidLoginSDKVav;

@property (nonatomic,strong)UIVisualEffectView *visualEffectView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//#ifdef YHTest
    [self DDLogInit];
    [self setupWebServer];
//#endif
    [YHTools setPersonId:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:@"APPSurplusGoods" object:nil];
    
    // Override point for customization after application launch.
    NSDictionary *dict = @{@"weChat":@(1),@"qqsns":@(1),@"sina":@(1)};
    [[LenovoIDInlandSDK shareInstance] leInlandApiInit:@"com.lenovoruler.common" andThirdLoginCB:@"" withThirdDictionary:dict];
    [WXApi registerApp:kWXAppID];
    [self configUSharePlatforms];
    //    [self checkAppUpdate];
    
    [self getNoti];//接收三方按钮点击通知事件
    return YES;
}

-(void)applicationDidTimeout:(NSNotification *)notif {
    
    [[PCBluetoothManager sharedPCBluetoothManager] stop];
    NSLog (@"time exceeded!!");
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:[WeChatManager singleton]];
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:@"com.lenovo.lsf.sdk.test.openapp.lenovoid"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LenovoIDQQWebLoginNotification" object:url.absoluteString];
        return YES;
    }else {
        return [WXApi handleOpenURL:url delegate:[WeChatManager singleton]];
    }
    
}



//大拿to do....
- (void)getNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdLoginClick:) name:@"LenovoIDThirdButtonClickedNotification" object:nil];
}
//大拿to do....
- (void)thirdLoginClick:(NSNotification *)noti {
    ThirdLoginViewController *thirdLoginVC = [[ThirdLoginViewController alloc] init];
    switch ([noti.userInfo[@"type"] integerValue]) {
        case 1:
            [[WeChatManager singleton] loginByWechat];
            return;
            break;
        case 2:
            thirdLoginVC.loginMethod = NSLocalizedString(@"com_lenovo_lsf_qq_login", nil);
            [self inLandJump:noti thirdVC:thirdLoginVC];
            break;
            
        case 3:
            //微博
            thirdLoginVC.loginMethod = NSLocalizedString(@"com_lenovo_lsf_sina_login", nil);
            [self inLandJump:noti thirdVC:thirdLoginVC];
            break;
        case 4:
            //google
            [self overseasJump:noti thirdMethod:@"Google"];
            break;
        case 5:
            //faceBook
            [self overseasJump:noti thirdMethod:@"Facebook"];
            break;
            
        default:
            break;
    }
}
//大拿to do....
- (void)inLandJump:(NSNotification *)noti thirdVC:(UIViewController *)thirdLoginVC{
    UINavigationController *nav = noti.userInfo[@"controller"];
    self.thidLoginSDKVav = nav;
    [WeChatManager singleton].nav = nav;
    [nav pushViewController:thirdLoginVC animated:YES];
}
//大拿to do....
- (void)overseasJump:(NSNotification *)noti thirdMethod:(NSString *)thirdMethod{
    ThirdLoginOverseasViewController *thirdLoginVC = [[ThirdLoginOverseasViewController alloc] init];
    thirdLoginVC.loginMethod = thirdMethod;
    UINavigationController *nav = noti.userInfo[@"controller"];
    self.thidLoginSDKVav = nav;
    [nav pushViewController:thirdLoginVC animated:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    [[PCBluetoothManager sharedPCBluetoothManager] stop];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //      [[NSNotificationCenter defaultCenter]postNotificationName:notificationAppActive object:Nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationRefreshTokenDelegate object:Nil userInfo:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"penco"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)configUSharePlatforms
{
    [UMConfigure initWithAppkey:kUMengKey channel:@"App Store"];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppID appSecret:@"e7637c7ec5e15f0ef2723b935967bb3b" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:kWXAppID appSecret:@"e7637c7ec5e15f0ef2723b935967bb3b" redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}


-(void)applicationWillResignActive:(UIApplication *)application{
    
    //  [self addBlurEffectWithUIVisualEffectView];
    
    
    
}

-(UIVisualEffectView *)visualEffectView {
    
    if (!_visualEffectView) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        _visualEffectView.frame = [UIScreen mainScreen].bounds;
        
    }
    
    return _visualEffectView;
    
}

-(void) addBlurEffectWithUIVisualEffectView {
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.visualEffectView];
    
}

-(void) removeBlurEffectWithUIVisualEffectView {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.visualEffectView removeFromSuperview];
        
    }];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self removeBlurEffectWithUIVisualEffectView];
    
}

#pragma mark - weblog

-(void)DDLogInit{
    
    //  [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // We also want to direct our log messages to a file.
    // So we're going to setup file logging.
    //
    // We start by creating a file logger.
    
    NSString *logsRoot = [NSString stringWithFormat:@"%@/Logs", [self webLogRoot]];
    
    self.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:[[DDLogFileManagerDefault alloc] initWithLogsDirectory:logsRoot]];
    
    // Configure some sensible defaults for an iPhone application.
    //
    // Roll the file when it gets to be 512 KB or 24 Hours old (whichever comes first).
    //
    // Also, only keep up to 4 archived log files around at any given time.
    // We don't want to take up too much disk space.
    
    self.fileLogger.maximumFileSize = 1024 * 512;    // 512 KB
    self.fileLogger.rollingFrequency = 60 * 60 * 24; //  24 Hours
    
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    
    // Add our file logger to the logging system.
    
    [DDLog addLogger:self.fileLogger];
    
}



#pragma mark - weblog

+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    /* createDirectoryAtPath:withIntermediateDirectories:attributes:error:
     * 参数1：创建的文件夹的路径
     * 参数2：是否创建媒介的布尔值，一般为YES
     * 参数3: 属性，没有就置为nil
     * 参数4: 错误信息
     */
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

/*参数1、被复制文件路径
 *参数2、要复制到的目标文件路径
 *参数3、当要复制到的文件路径文件存在，会复制失败，这里传入是否覆盖
 *参数4、错误信息
 */
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    //获得目标文件的上级目录
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        // 创建复制路径
        if (![self createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    // 如果覆盖，那么先删掉原文件
    if (overwrite) {
        if ([self isExistsAtPath:toPath]) {
            [self removeItemAtPath:toPath error:error];
        }
    }
    // 复制文件，如果不覆盖且文件已存在则会复制失败
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
    
    return isSuccess;
}

#pragma mark - 判断文件(夹)是否存在
+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
- (void)setupWebServer
{
    [self webServerInit];
    // Create server using our custom MyHTTPServer class
    httpServer = [[HTTPServer alloc] init];
    
    // Configure it to use our connection class
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    // Set the bonjour type of the http server.
    // This allows the server to broadcast itself via bonjour.
    // You can automatically discover the service in Safari's bonjour bookmarks section.
    [httpServer setType:@"_http._tcp."];
    
    // Normally there is no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for testing purposes, it may be much easier if the port doesn't change on every build-and-go.
    [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    //    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    [httpServer setDocumentRoot:[self webLogRoot]];
    
    // Start the server (and check for problems)
    DDLogInfo(@"%@", [self webLogRoot]);
    NSError *error = nil;
    if (![httpServer start:&error])
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
}

-(NSString*)webLogRoot{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/weblog", cachePaths.firstObject];
    
//        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *path = [documentsPath stringByAppendingPathComponent:@"/Documents"];
//
//        return [NSString stringWithFormat:@"%@/weblog", path];
}

-(void)webServerInit{
    
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    NSError *error = [NSError new];
    [AppDelegate copyItemAtPath:webPath toPath:[self webLogRoot] overwrite:NO error:&error];
    
}

@end
