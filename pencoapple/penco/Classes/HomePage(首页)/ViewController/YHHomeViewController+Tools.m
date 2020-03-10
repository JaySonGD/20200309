//
//  YHHomeViewController+Tools.m
//  penco
//
//  Created by Zhu Wensheng on 2019/7/19.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import "PCPostureModel.h"
#import <objc/runtime.h>
#import "YHHomeViewController+Tools.h"
#import "YHCommon.h"
#import "YHTools.h"
#import <AFURLSessionManager.h>
#import "PCAlertViewController.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
NSString *const notificationLoad3d = @"YHNnotificationLoad3d";
@interface YHHomeViewController ()<CLLocationManagerDelegate>

//定位管理器
@property (nonatomic, strong) CLLocationManager *localM;

@property (nonatomic, strong)CLGeocoder *geocoder;


@property (weak, nonatomic) IBOutlet UIImageView *pcV;
@property (strong, nonatomic) NSMutableArray *imgs;
@property (strong,nonatomic)NSNumber *hipLC;
@property (strong,nonatomic)NSNumber *hipV;
@property (strong,nonatomic)NSNumber *shoulderLC;
@property (strong,nonatomic)NSNumber *shoulderV;
@end


static char localMKey;
static char geocoderKey;
@implementation YHHomeViewController (Tools)

- (void)setLocalM:(CLLocationManager *)localM
{
    objc_setAssociatedObject(self, &localMKey, localM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLLocationManager *)localM
{
    return objc_getAssociatedObject(self, &localMKey);
}

-(void)setGeocoder:(CLGeocoder *)geocoder{
    objc_setAssociatedObject(self, &geocoderKey, geocoder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLLocationManager *)geocoder
{
    return objc_getAssociatedObject(self, &geocoderKey);
}


#pragma mark - 3d模型下载和更新

-(NSString*)downloadModelPath:(PC3dModel)model{
    
    
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = NSHomeDirectory();
    switch (model) {
        case PC3dModelShaping:
        {
            return [cachePath stringByAppendingPathComponent:@"/Documents/models/shaping"];
        }
            break;
        case PC3dModelMuscleGrowth:
        {
            return [cachePath stringByAppendingPathComponent:@"/Documents/models/suscleGrowth"];
        }
            break;
        case PC3dModelMan:
        {
            return [cachePath stringByAppendingPathComponent:@"/Documents/models/man"];
        }
            break;
        case PC3dModelCancel:
        {
            
        }
        break;
    }
    return @"";
}

-(void)download3DModel:(PC3dModel)model url:(NSString*)urlStr modelId:(NSString*)modelId{
    return;
    if (([[YHTools shapingId] isEqualToString:modelId] && model == PC3dModelShaping)
        || ([[YHTools muscleId] isEqualToString:modelId] && model == PC3dModelMuscleGrowth)) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationLoad3d object:Nil userInfo:@{@"model" : @(model)}];
        return;
    }
    if (model == PC3dModelShaping) {
        [YHTools setshapingId:modelId];
    }
    if (model == PC3dModelMuscleGrowth) {
        [YHTools setmuscleId:modelId];
    }
//    return;
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* 下载路径 */
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByAppendingPathComponent:@"/Documents/download/type"];
    NSString *toDestination = [self downloadModelPath:model];
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *pathM5 = [[bundle resourcePath] stringByAppendingPathComponent:[self downloadModelPath:model]];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    {
        
        BOOL nn =  [[NSFileManager defaultManager] removeItemAtPath:toDestination error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:toDestination withIntermediateDirectories:YES attributes:nil error:nil];
    }
    WeakSelf
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
//        YHLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //        /Users/zhuwensheng/Library/Developer/CoreSimulator/Devices/A325D9DE-3D72-42F0-A044-890548C6D213/data/Containers/Bundle/Application/2C5DB8A2-C02E-4295-9380-78205D67DDD5/penco.app/index.html
        //        /Users/zhuwensheng/Library/Developer/CoreSimulator/Devices/A325D9DE-3D72-42F0-A044-890548C6D213/data/Containers/Data/Application/95C4DE77-ABF7-4F87-BFCA-BA006CBFD716/Documents/typical.zip
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        YHLog(@"下载完成");
        
        [weakSelf uSSZipArchiveWithFilePath:filePath.path toDestination:toDestination model:model];
    }];
    [downloadTask resume];
}

/**
 SSZipArchive解压
 
 */
-(void)uSSZipArchiveWithFilePath:(NSString *)zipFile toDestination:(NSString*)destination model:(PC3dModel)model
{
    //解压
//    BOOL isSuccess = [SSZipArchive unzipFileAtPath:zipFile toDestination:destination];
    
    //如果解压成功则获取解压后文件列表
//    if (isSuccess) {
//        [self obtainZipSubsetWithFilePath:destination model:model];
//    }
    
}


/**
 获取解压后文件列表
 
 @param path 解压后的文件路径
 */
- (void)obtainZipSubsetWithFilePath:(NSString *)path model:(PC3dModel)model
{
    YHLog(@"%@", path);
    // 读取文件夹内容
    NSError *error = nil;
    NSMutableArray*items = [[[NSFileManager defaultManager]
                             contentsOfDirectoryAtPath:path
                             error:&error] mutableCopy];
    if (error) {
        return;
    }
    
    for (NSString * item_str in items) {
        // 获取在libraryPath文件中加入file1的路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",  path, item_str];
        if ([YHHomeViewController isDirectory:filePath]) {
            
            
            NSMutableArray*files = [[[NSFileManager defaultManager]
                                     contentsOfDirectoryAtPath:filePath
                                     error:&error] mutableCopy];
            
            for (NSString * file in files) {
                // 创建文件管理对象
                NSFileManager *fileManage = [NSFileManager defaultManager];
                NSString *fileName = [NSString stringWithFormat:@"%@/%@",  filePath, file];
                
                NSString *toFilePath = [path stringByAppendingPathComponent:file];
                if ([fileManage fileExistsAtPath:toFilePath]) {
                    // 删除
                    [fileManage removeItemAtPath:toFilePath error:nil];
                }
                [fileManage moveItemAtPath:fileName toPath:toFilePath error:nil];
            }
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationLoad3d object:Nil userInfo:@{@"model" : @(model)}];
}

+ (BOOL)isDirectory:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}
//是否是否
- (BOOL)isCashModel:(NSString*)plyId{
    for (NSString *cashId in [YHTools user3dModels]) {
        if ([cashId isEqualToString:plyId]) {
            return YES;
        }
    }
    return NO;
}


//是否是否
- (void)cashModelClear{
    NSArray *cash = [[YHTools user3dModels] mutableCopy];
    if (cash.count <= 10 && cash) {
        return;
    }
    for (int i = 10; i < cash.count; i++) {
        NSString *delId = cash[i];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/download/ply/%@", delId]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [YHTools setuser3dModels:[cash subarrayWithRange:NSMakeRange(0, 10)]];
}


-(void)downloadPly:(NSString*)urlStr plyId:(NSString*)plyId{
    if (!urlStr) {
        return;
    }

    DebugTime
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* 下载路径 */
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/download/ply/%@", plyId]];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    //缓存
    if ([self isCashModel:plyId]) {
        NSString *fileContent = [[NSData dataWithContentsOfFile:filePath] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        if (fileContent) {
            [self pushUriModel:fileContent];
            return;
        }
    }
        
        NSMutableArray *cashs = [@[plyId]mutableCopy];
        NSArray *oldCashs = [YHTools user3dModels];
        if (oldCashs) {
            [cashs addObjectsFromArray:oldCashs];
        }
        [YHTools setuser3dModels:cashs];
        [self cashModelClear];
    
    {
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    WeakSelf
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
//        YHLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath2, NSError * _Nullable error) {
        
        YHLog(@"下载完成");
        NSString *fileContent = [[NSData dataWithContentsOfFile:filePath] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        [weakSelf pushUriModel:fileContent];
    }];
    [downloadTask resume];
}



- (void)loadWeb:(NSString*)url{
    if (!url) {
        return;
    }
    UIWebView *webView = [[UIWebView alloc] init];
    
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
}

-(void)loadAngle:(NSDictionary*)info{
    NSDictionary *resultData = [info objectForKey:@"resultData"];
    NSArray *frontLine = [resultData objectForKey:@"frontLine"];
    self.hipV = [resultData objectForKey:@"angleHip"];
    self.shoulderV = [resultData objectForKey:@"angleShoulder"];
    
    if (frontLine == nil) {
        frontLine = [resultData objectForKey:@"sideLine"];
    }
    NSDictionary *keypoints = [YHTools dictionaryWithJsonString:[resultData objectForKey:@"keypoints"]];
    //特殊点 右肩5 右胯11
    
    NSArray *p = keypoints[@"5"];
    
    self.shoulderLC = p[1];
    
    
    p = keypoints[@"11"];
    
    self.hipLC = p[1];
}

- (void)loadImage:(PCPostureModel*)info{
    self.imgs = [@[[NSNull null], [NSNull null]]mutableCopy];
    WeakSelf
    NSDictionary *analysisResult = info.analysisResult;
    NSString *positivePhotoUrl = info.positivePhotoUrl;
    NSString *sidePhotoUrl = info.sidePhotoUrl;
    
    NSDictionary *image1 = [analysisResult objectForKey:@"image1"];
    NSDictionary *image2 = [analysisResult objectForKey:@"image2"];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:positivePhotoUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            if (image == nil || image1 == nil) {
                return ;
            }
            [weakSelf.imgs replaceObjectAtIndex:0 withObject:[weakSelf load:image1 image:image dottedLine:YES]];
            [weakSelf loadAngle:image1];
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
//                [weakSelf.tableV reloadData];
            });        }
    }];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:sidePhotoUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            if (image == nil || image2 == nil) {
                return ;
            }
            [weakSelf.imgs replaceObjectAtIndex:1 withObject:[weakSelf load:image2 image:image dottedLine:NO]];
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
//                [weakSelf.tableV reloadData];
            });
        }
    }];
}


- (UIImage*)load:(NSDictionary*)info image:(UIImage*)image dottedLine:(BOOL)dottedLine{
    if (!info) {
        return [NSNull null];
    }
    NSDictionary *resultData = [info objectForKey:@"resultData"];
    NSArray *frontLine = [resultData objectForKey:@"frontLine"];
    if (frontLine == nil) {
        frontLine = [resultData objectForKey:@"sideLine"];
    }
    NSDictionary *keypoints = [YHTools dictionaryWithJsonString:[resultData objectForKey:@"keypoints"]];
    NSArray *limb = [resultData objectForKey:@"limb"];
    NSMutableArray *lines = [@[] mutableCopy];
    NSMutableArray *points = [@[] mutableCopy];
    if (dottedLine) {
        //        右肩5 左肩 2 左胯8 右胯11 左膝 9 右膝 12 左踝 10 右踝 13
        limb = @[@[@2, @5], @[@8, @11], @[@8, @9], @[@11, @12], @[@9, @10], @[@12, @13]];
    }
    for (NSArray *p in limb) {
        if (!keypoints[((NSNumber*)p[0]).stringValue]) {
            continue;
        }
        if (!keypoints[((NSNumber*)p[1]).stringValue]) {
            continue;
        }
        NSArray *itemP = @[keypoints[((NSNumber*)p[0]).stringValue], keypoints[((NSNumber*)p[1]).stringValue]];
        [lines addObject:@{@"color" : @(0X4CD0FF),
                           @"weight" : @4,
                           @"points" : itemP
                           }];
        [points addObjectsFromArray:itemP];//绘制的关键点
    }
    if (frontLine) {
        [lines addObject: @{@"color" : @(0X4CD0FF),
                            @"weight" : @1,
                            @"points" : frontLine
                            }];
    }
    
    
    if (dottedLine) {
        NSInteger dottedContent = 10;//虚线空白间隔
        NSInteger dottedContentW = 10;//虚线颜色间隔
        NSInteger dottedContentCount = 8;//虚线段数
        //特殊点 右肩5 左肩 2 左胯8 右胯11 左膝 9 右膝 12 左踝 10 右踝 13
        for (NSString *key in @[@"5", @"11"]) {
            NSArray *p = keypoints[key];
            //加须线
            for (NSInteger i = 0; i < dottedContentCount; i++) {//虚线分割成多段线
                NSNumber *xN = p[0];
                NSNumber *yN = p[1];
                //线起始点
                NSInteger xS = xN.integerValue + (dottedContentW * i) + (dottedContent * i);//
                NSInteger yS = yN.integerValue;
                
                //结束点
                NSInteger xE = xN.integerValue + (dottedContentW * (i + 1)) + (dottedContent * i);
                NSInteger yE = yN.integerValue;
                
                NSArray *startLine = @[@(xS), @(yS)];
                NSArray *endLine = @[@(xE), @(yE)];
                
                [lines addObject:@{@"color" : @(0X4CD0FF),
                                   @"weight" : @4,
                                   @"points" : @[startLine, endLine]
                                   }];
            }
        }
        
        //t特殊点 左肩 2 左胯8
        for (NSString *key in @[@"2", @"8"]) {
            NSArray *p = keypoints[key];
            //加须线
            for (NSInteger i = 0; i < dottedContentCount; i++) {//虚线分割成多段线
                NSNumber *xN = p[0];
                NSNumber *yN = p[1];
                //线起始点
                NSInteger xS = xN.integerValue - (dottedContentW * i) - (dottedContent * i);//
                NSInteger yS = yN.integerValue;
                
                //结束点
                NSInteger xE = xN.integerValue - (dottedContentW * (i + 1)) - (dottedContent * i);
                NSInteger yE = yN.integerValue;
                
                NSArray *startLine = @[@(xS), @(yS)];
                NSArray *endLine = @[@(xE), @(yE)];
                
                [lines addObject:@{@"color" : @(0X4CD0FF),
                                   @"weight" : @4,
                                   @"points" : @[startLine, endLine]
                                   }];
            }
        }
    }
    return [YHTools image:image withInfo:@{@"lines" : lines,
                                           @"points" : points
                                           }];
}


@end
