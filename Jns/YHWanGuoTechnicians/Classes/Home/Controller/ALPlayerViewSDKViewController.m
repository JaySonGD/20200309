//
//  AliyunPlayerMediaUIDemoViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/21.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "ALPlayerViewSDKViewController.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>
#import "AppDelegate.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import <sys/utsname.h>

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface ALPlayerViewSDKViewController ()<AliyunVodPlayerViewDelegate,AliyunVodDownLoadDelegate>
@property (nonatomic,strong)AliyunVodPlayerView *playerView;
@property (nonatomic,copy)NSString *tempPlayauth;
@property (nonatomic, assign)BOOL isLock;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL isStatusHidden;

@end

@implementation ALPlayerViewSDKViewController
-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    CGFloat width = 0;
    CGFloat height = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = SCREEN_WIDTH;
        height = SCREEN_WIDTH * 9 / 16.0;
    }else{
        width = SCREEN_HEIGHT;
        height = SCREEN_HEIGHT * 9 / 16.0;
    }
    
    /****************UI播放器集成内容**********************/
    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,20, width, height) andSkin:AliyunVodPlayerViewSkinRed];
    
    //测试封面地址，请使用https 地址。
    //    self.playerView.coverUrl = [NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4046104436,1338839104&fm=27&gp=0.jpg"];
    //    [self.playerView setTitle:@"1234567890"];
    self.playerView.circlePlay = YES;
    [self.playerView setDelegate:self];
    //    [self.playerView setAutoPlay:YES];
    
    //设置清晰度。
    self.playerView.quality = 5;
    
    /*
     *备注：isLockScreen 会锁定，播放器界面尺寸。
     isLockPortrait yes：竖屏全屏；no：横屏全屏;
     isLockScreen对isLockPortrait无效。
     - (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen此方法在isLockPortrait==yes时，返回的islockscreen总是yes；
     isLockScreen和isLockPortrait，因为播放器时UIView，是否旋转需要配合UIViewController来控制物理旋转。
     假设：支持竖屏全屏
     self.playerView.isLockPortrait = YES;
     self.playerView.isLockScreen = NO;
     self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
     
     支持横屏全屏
     self.playerView.isLockPortrait = NO;
     self.playerView.isLockScreen = NO;
     self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
     
     锁定屏幕
     self.playerView.isLockPortrait = NO;
     self.playerView.isLockScreen = YES;
     self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
     
     self.isLock时来判定UIViewController 是否支持物理旋转。如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
     */
    self.playerView.isLockScreen = NO;
    self.playerView.isLockPortrait = NO;
    self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
    
    //边下边播缓存沙箱位置
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    //maxsize:单位 mb    maxDuration:单位秒 ,在prepare之前调用。
    [self.playerView setPlayingCache:YES saveDir:docDir maxSize:0XFFFF maxDuration:0XFFFF];
    
    [self setupDownload];
    
    //查看缓存文件时打开。
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerun) userInfo:nil repeats:YES];
    
    //播放本地视频
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"set.mp4" ofType:nil];
    //    [self.playerView playViewPrepareWithURL:[NSURL URLWithString:@"http://vod-test5.cn-shanghai.aliyuncs.com/84c80abba5e04fe9b57564d204a59585/b5a2911dd2c44c5d81ec568eb3b14431-f30978e8480a8c3a231ab2127d839b0c.mp4?auth_key=1512310022-0-0-c2f3ebd18ba1f4350edf1c5155f1e2dd"]];
    //播放器播放方式
    //    [self.playerView playViewPrepareWithVid:self.vid accessKeyId:self.appKey accessKeySecret:self.appSecret securityToken:self.playauth];
    
    //播放方式一：使用vid+STS方式播放（点播用户推荐使用）
    //    [self.playerView playViewPrepareWithVid:vid accessKeyId:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken];
    
    //播放方式三：使用vid+playAuth方式播放（V3.2.0之前版本使用，兼容老用户）
    [self.playerView playViewPrepareWithVid:self.vid playAuth:self.playauth];
    
    NSLog(@"%@",[self.playerView getSDKVersion]);
    [self.view addSubview:self.playerView];
    /**************************************/
    
}


- (void)setupDownload{
    
    [[AliyunVodDownLoadManager shareManager] setDownloadDelegate:self];
    
    //设置下载路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    [[AliyunVodDownLoadManager shareManager] setDownLoadPath:path];
    //设置最大下载个数，最多允许同时开启4个下载
    [[AliyunVodDownLoadManager shareManager] setMaxDownloadOperationCount:3];
    
    //将下载的加密文件集成到自己的项目中，确保加密文件的路径正确
    NSString *encryptedAppPath =  [[NSBundle mainBundle] pathForResource:@"encryptedApp" ofType:@"dat"];
    [[AliyunVodDownLoadManager shareManager] setEncrptyFile:encryptedAppPath];
    
    AliyunDataSource* source = [[AliyunDataSource alloc] init];
    source.vid = self.vid;
    
    source.playAuth = self.playauth;
    //设置下载的清晰度
    source.quality = AliyunVodPlayerVideoOD;
    //设置下载的视频格式，根据转码后的文件格式来选择，当前返回的格式优先级为m3u8>mp4>flv
    source.format = @"m3u8";
    //监听代理onPrepare，可以获取视频清晰度、长度、大小、格式等信息（异步接口）
    [[AliyunVodDownLoadManager shareManager] prepareDownloadMedia:source];

    

    AliyunDataSource* downloadSource = [[AliyunDataSource alloc] init];
    downloadSource.vid = self.vid;
    
    
    //以下方式使用playAuth下载方式的用户使用
    downloadSource.playAuth = self.playauth;
    //设置下载的清晰度
    downloadSource.quality = AliyunVodPlayerVideoOD;
    //设置下载的视频格式，根据转码后的文件格式来选择，当前返回的格式优先级为m3u8>mp4>flv
    downloadSource.format = @"m3u8";
    //监听代理onPrepare，可以获取视频清晰度、长度、大小、格式等信息（异步接口）
    [[AliyunVodDownLoadManager shareManager] startDownloadMedia:downloadSource];

}

-(void) onUnFinished:(NSArray<AliyunDataSource*>*)mediaInfos{
    //异常中断导致下载未完成，下次启动后会接收到此回调。
    NSLog(@"异常中断导致下载未完成，下次启动后会接收到此回调");
}
/*
 功能：开始下载后收到回调，更新最新的playAuth。主要场景是开始多个下载时，等待下载的任务自动开始下载后，playAuth有可能已经过期了，需通过此回调更新
 参数：返回当前数据
 返回：使用代理方法，设置playauth来更新数据。
 */
//-(NSString*)onGetPlayAuth:(NSString*)vid format:(NSString*)format quality:(AliyunVodPlayerVideoQuality)quality{
//
//}
/*
 功能：开始下载后收到回调，更新最新的stsData。主要场景是开始多个下载时，等待下载的任务自动开始下载后，stsData有可能已经过期了，需通过此回调更新
 参数：返回当前数据
 返回：使用代理方法，设置AliyunStsData来更新数据。
 */
//- (AliyunStsData*)onGetAliyunStsData:(NSString *)videoID
//                              format:(NSString*)format
//                             quality:(AliyunVodPlayerVideoQuality)quality{
//
//}
/*
 功能：开始下载后收到回调，更新最新的MtsData。主要场景是开始多个下载时，等待下载的任务自动开始下载后，MtsData有可能已经过期了，需通过此回调更新
 参数：返回当前数据
 返回：使用代理方法，设置AliyunMtsData来更新数据。
 */
//- (AliyunMtsData*)onGetAliyunMtsData:(NSString *)videoID
//                              format:(NSString*)format
//                             quality:(NSString *)quality{
//
//}
-(void) onPrepare:(NSArray<AliyunDownloadMediaInfo*>*)mediaInfos{
    //准备下载时回调
    NSLog(@"准备下载时回调");
}
-(void) onStart:(AliyunDownloadMediaInfo*)mediaInfo{
    //开始下载时回调
    NSLog(@"开始下载时回调：%@", mediaInfo.downloadFilePath);
}
-(void) onProgress:(AliyunDownloadMediaInfo*)mediaInfo{
    //下载过程中回调下载进度，通过mediaInfo.downloadProgress获取进度
    NSLog(@"下载过程中回调下载进度：%d", mediaInfo.downloadProgress);
}
-(void) onStop:(AliyunDownloadMediaInfo*)mediaInfo{
    //使用stop结束下载时回调
    NSLog(@"使用stop结束下载时回调：%@", mediaInfo.downloadFilePath);

}
-(void) onCompletion:(AliyunDownloadMediaInfo*)mediaInfo{
    //下载完成时回调
    NSLog(@"下载完成时回调：%@", mediaInfo.downloadFilePath);
}
-(void)onError:(AliyunDownloadMediaInfo*)mediaInfo code:(int)code msg:(NSString *)msg{
    //错误回调，错误码和错误信息详见接口文档中的错误信息表
    NSLog(@"下载错误回调：%@", msg);
}


- (void)dealloc {
    
    [[AliyunVodDownLoadManager shareManager] stopAllDownloadMedia];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
}

- (NSString*)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

//适配iphone x 界面问题，没有在 viewSafeAreaInsetsDidChange 这里做处理 ，主要 旋转监听在 它之后获取。
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSString *platform =  [self iphoneType];
    
    //iphone x
    if (![platform isEqualToString:@"iPhone10,3"] && ![platform isEqualToString:@"iPhone10,6"]) {
        return;
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    UIDevice *device = [UIDevice currentDevice] ;
    switch (device.orientation) {//device.orientation
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortraitUpsideDown:{
            if (self.isStatusHidden) {
                CGRect frame = self.playerView.frame;
                frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
                frame.size.width = SCREEN_WIDTH-VIEWSAFEAREAINSETS(self.view).left*2;
                frame.size.height = SCREEN_HEIGHT-VIEWSAFEAREAINSETS(self.view).bottom-VIEWSAFEAREAINSETS(self.view).top;
                self.playerView.frame = frame;
            }else{
                CGRect frame = self.playerView.frame;
                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
                //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
                if (self.playerView.isLockPortrait&&self.isStatusHidden) {
                    frame.size.height = SCREEN_HEIGHT- VIEWSAFEAREAINSETS(self.view).top- VIEWSAFEAREAINSETS(self.view).bottom;
                }
                self.playerView.frame = frame;
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            //
            CGRect frame = self.playerView.frame;
            frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            frame.size.width = SCREEN_WIDTH-VIEWSAFEAREAINSETS(self.view).left*2;
            frame.size.height = SCREEN_HEIGHT-VIEWSAFEAREAINSETS(self.view).bottom;
            self.playerView.frame = frame;
        }
            
            break;
        case UIDeviceOrientationPortrait:
        {
            //
            CGRect frame = self.playerView.frame;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
            if (self.playerView.isLockPortrait&&self.isStatusHidden) {
                frame.size.height = SCREEN_HEIGHT- VIEWSAFEAREAINSETS(self.view).top- VIEWSAFEAREAINSETS(self.view).bottom;
            }
            self.playerView.frame = frame;
            
        }
            
            break;
        default:
            
            break;
    }
    
#else
#endif
    NSLog(@"top----%f",self.playerView.frame.origin.y);
    
}


#pragma mark - AliyunVodPlayerViewDelegate
- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    if (self.playerView != nil) {
        [self.playerView stop];
        [self.playerView releasePlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    
    self.isStatusHidden = isFullScreen  ;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

/**
 * 功能：获取媒体信息
 */
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView mediaInfo:(AliyunVodPlayerVideo*)mediaInfo{
    
}

-(void)timerun{
    [self fileSize];
}

-(void)fileSize{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    NSString *filePath = docDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:docDir isDirectory:nil]){
        NSArray *subpaths = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
        for (NSString *subpath in subpaths) {
            
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            if ([subpath hasSuffix:@".mp4"]) {
                long long fileSize =  [fileManager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
                NSLog(@"%@Size ---- %lld",subpath, fileSize);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 锁屏功能
/**
 * 说明：播放器父类是UIView。
 屏幕锁屏方案需要用户根据实际情况，进行开发工作；
 如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (self.isLock) {
        return toInterfaceOrientation = UIInterfaceOrientationPortrait;
    }else{
        return YES;
    }
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return !self.isLock;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.isLock) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return self.isStatusHidden;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

