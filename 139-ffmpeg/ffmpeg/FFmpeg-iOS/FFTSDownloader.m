//
//  FFTSDownloader.m
//  ffmpeg
//
//  Created by Jayson on 2019/6/28.
//  Copyright © 2019年 AA. All rights reserved.
//

#import "FFTSDownloader.h"
#import "FFmpegManager.h"

#import <CommonCrypto/CommonCrypto.h>

#define MaxDownloadCount 20

@interface FFTSDownloader ()

@property (nonatomic, assign) NSInteger tsCount;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) BOOL isRun;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, copy) void (^processBlock)(float process,float kbs);
@property (nonatomic, copy) void (^completionBlock)(NSError *error);
@property (nonatomic, weak) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) CGFloat total;
@end


@implementation FFTSDownloader

+ (FFTSDownloader *)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

+ (NSString *)getState:(NSString *)url{
    __block NSString *state = @"\t\t";
    [self.videoList enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([url isEqualToString:obj[@"url"]]) {
            state = obj[@"loc"]? @"✔" : @"↓";
            *stop = YES;
        }
        
    }];
    
    return state;
}


+ (NSMutableArray *)videoList{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"];
    NSArray *urls = dict.allKeys;
    NSMutableArray *list = [NSMutableArray array];
    [urls enumerateObjectsUsingBlock:^(NSString * url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        NSString *file = [NSString stringWithFormat:@"%@.mp4",[[FFTSDownloader sharedManager] md5:url]];
        
        NSString *filePath = [[[FFTSDownloader sharedManager] cacheDirectory] stringByAppendingPathComponent:file];
        
        [list addObject:@{
                          @"fileName":dict.allValues[idx],
                          @"loc":filePath,
                          @"url":url
                          }.mutableCopy];
    }];
    
    
    NSArray <NSString *>*turls = [[[FFTSDownloader sharedManager] tasks] valueForKeyPath:@"url"];
    NSMutableDictionary *progresslist = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
    [progresslist enumerateKeysAndObjectsUsingBlock:^(NSString * url, NSDictionary * obj, BOOL * _Nonnull stop) {
        
        if(![turls containsObject:url]) {
            [list addObject:obj.mutableCopy];
        }
        
    }];
    
    [list addObjectsFromArray:[FFTSDownloader sharedManager].tasks];
    
    return list;
}


- (void)dowloadWithTs:(NSArray<NSString *> *)ts
                  url:(NSString *)url
                total:(CGFloat )total
               fileName:(NSString *)fileName
           processBlock:(void (^)(float, float))processBlock
        completionBlock:(void (^)(NSError *))completionBlock{
    
    if ([FFTSDownloader isDownloaded:url]) {
        !(completionBlock)? : completionBlock(nil);
        return;
    }
    
    NSArray <NSString *>*urls = [self.tasks valueForKeyPath:@"url"];
    
    if(![urls containsObject:url]) {
        [self.tasks insertObject:@{
                                   @"ts":ts,
                                   @"url" : url,
                                   @"total" : @(total),
                                   @"fileName":fileName,
                                   @"processBlock":processBlock,
                                   @"completionBlock":completionBlock
                                   }.mutableCopy atIndex:0];
    }
    
    if (self.isRun) return;

    _total = total;
    _tsCount = ts.count;
    _url = url;
    _fileName = fileName;
    _processBlock = processBlock;
    _completionBlock = completionBlock;
    // 下载 ts 文件
    //[self downloadVideoWithArr:ts andIndex:0];
    
    for (NSInteger i = 0; i < MaxDownloadCount; i++) {
        [self downloadVideoWithArr:ts andIndex:i];
    }

    
}

+ (BOOL)isDownloaded:(NSString *)url{
    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
    
    if (!dict) return NO;
    
    
    NSString *fileName = dict[url];
    
    if (!fileName) return NO;
    
    NSString *file = [NSString stringWithFormat:@"%@.mp4",[[FFTSDownloader sharedManager] md5:url]];
    NSString *filePath = [[[FFTSDownloader sharedManager] cacheDirectory] stringByAppendingPathComponent:file];
    

    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ){
        return YES;
    }
    
    [dict removeObjectForKey:url];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return  NO;
}


// 循环下载 ts 文件
- (void)downloadVideoWithArr:(NSArray *)listArr andIndex:(NSInteger)index{
   
    NSInteger downloadCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self tsDirectory]
                                                    error:nil] count];
    //CGFloat process = (float)index/(listArr.count+1);
    CGFloat process = (float)downloadCount/(listArr.count+1);
    NSMutableDictionary *obj = self.tasks.lastObject;
    obj[@"process"] = @(process);
    obj[@"speed"] = @(0);

    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }

    dict[self.url] = obj;

//    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"progresslist"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//

    
    !(_processBlock)? : _processBlock(process , 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:@{@"url":self.url,@"process":@(process),@"speed":@(0)}];
    

    if (downloadCount >= listArr.count) {
        //self.tipLab.text = @"视频下载完成";
        NSLog(@"%s------视频下载完成", __func__);
        [self combVideos];
        return;
    }
    
    //self.tipLab.text = [NSString stringWithFormat:@"共有 %lu 个ts文件, 下载中：%.2f%%", (unsigned long)listArr.count, (float)index/listArr.count * 100];
    //self.progressView.progress = (float)index/listArr.count;
    //!(_processBlock)? : _processBlock((float)index/listArr.count+1 , 0);

    if (index >= listArr.count) {
        NSLog(@"%s------该线路下载完成", __func__);
        return;
    }
    
    NSString *downloadURL = listArr[index];
    NSString *tsName = [NSString stringWithFormat:@"video_%ld.ts",(long)index];
    
    NSString *destinationPath = [self.tsDirectory stringByAppendingPathComponent:tsName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        //[self downloadVideoWithArr:listArr andIndex:index+1];
        [self downloadVideoWithArr:listArr andIndex:index+MaxDownloadCount];
        return;
    }
    
    __weak typeof(self)wkSelf = self;
    [self downloadURL:downloadURL
      destinationPath:destinationPath
           completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
               if (!error) {
                   NSLog(@"%s------%@-下载完成", __func__,tsName);
                   //[wkSelf downloadVideoWithArr:listArr andIndex:index+1];
                   [wkSelf downloadVideoWithArr:listArr andIndex:index+MaxDownloadCount];
               }
           }];
}

// 合成为一个ts文件
- (void)combVideos {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:[self tsPath]]) {
        [self convert];
        //self.tipLab.text = @"已合成视频";
        NSLog(@"%s------已合成视频", __func__);
        return;
    }
    
    NSArray *contentArr = [mgr contentsOfDirectoryAtPath:[self tsDirectory]
                                                   error:nil];
    
    [[NSFileManager defaultManager] createFileAtPath:[self tsPath] contents:nil attributes:nil];
    // 文件句柄
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:[self tsPath]];
    
    int videoCount = 0;
    for (NSString *str in contentArr) {
        @autoreleasepool {
            // 按顺序拼接 TS 文件
            if ([str containsString:@"video_"]) {
                NSString *videoName = [NSString stringWithFormat:@"video_%d.ts",videoCount];
                NSString *ts = [[self tsDirectory] stringByAppendingPathComponent:videoName];
                // 读出数据
                NSData *data = [[NSData alloc] initWithContentsOfFile:ts];
                //设置指向文件的末尾
                [handle seekToEndOfFile];
                // 写数据
                [handle writeData:data];
                
                
                videoCount++;
            }
        }
    }
    NSLog(@"%s------合成视频", __func__);
    [self convert];
}

// 视频列表路径
- (NSString *)tsDirectory {
    
    NSString *vedioPath = [self.cacheDirectory stringByAppendingPathComponent:[self md5:self.url]];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:vedioPath]) {
        [mgr createDirectoryAtPath:vedioPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
    return vedioPath;
}

// 沙盒 document 路径
- (NSString *)cacheDirectory  {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return docDir;
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

// 下载方法
- (void)downloadURL:(NSString *)downloadURL
    destinationPath:(NSString *)destinationPath
         completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
    
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString: downloadURL] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:destinationPath error:NULL];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response, error? nil :[NSURL fileURLWithPath:destinationPath], error);
        });
    }];
    [downloadTask resume];
    self.downloadTask = downloadTask;
    return;
}

- (void)cancel{
    [self.downloadTask cancel];
    self.downloadTask = nil;
}

- (NSString *)tsPath{
    NSString *ifilePath = [NSString stringWithFormat:@"%@.ts",[self md5:self.url]];
    NSString *inPut = [[self tsDirectory] stringByAppendingPathComponent:ifilePath];
    return inPut;
}

- (NSString *)mp4Path{
    NSString *ofilePath = [NSString stringWithFormat:@"%@.mp4",[self md5:self.url]];
    
    NSString *outPut = [[self cacheDirectory] stringByAppendingPathComponent:ofilePath];
    
    return outPut;
}

- (void)convert {

    NSString *header = [NSString stringWithFormat:@"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-TARGETDURATION:%ld\n",(long)(self.total + 10)];
    //文件名
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.ts", [self md5:self.url],[self md5:self.url]];
    //文件时长
    NSString* length = [NSString stringWithFormat:@"#EXTINF:%f,\n",self.total];
    //拼接M3U8
    header = [header stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", length, fileName]];
    
    header = [header stringByAppendingString:@"#EXT-X-ENDLIST"];
    
    NSString *m3u8File = [NSString stringWithFormat:@"%@.m3u8",[self md5:self.url]];
    NSString *m3u8Path = [[self cacheDirectory] stringByAppendingPathComponent:m3u8File];
    [header writeToFile:m3u8Path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    return;
    
//    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -c copy -bsf:a aac_adtstoasc -y %@",[self tsPath],[self mp4Path]];
    
//    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -c:v copy -c:a libfaac -y %@",[self tsPath],[self mp4Path]];

    
    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -acodec copy -vcodec copy -absf aac_adtstoasc -y %@",[self tsPath],[self mp4Path]];

    
    [[FFmpegManager sharedManager] runCmd:cmd processBlock:^(float process, float kbs, long long size) {
        NSLog(@"%s--TS<->MP4-%f", __func__,process);
        
        CGFloat p = (self.tsCount+process)/(self.tsCount+1);
        NSMutableDictionary *obj = self.tasks.lastObject;
        obj[@"process"] = @(p);
        obj[@"speed"] = @(kbs);
        
        !(self.processBlock)? : self.processBlock( p , kbs);
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:@{@"url":self.url,@"process":@(p),@"speed":@(kbs)}];

        
    } completionBlock:^(NSError *error) {
        NSLog(@"%s---ok---%@", __func__,[self mp4Path]);
        
        if (!error) {
            NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
            if (!dict) {
                dict = [NSMutableDictionary dictionary];
            }
            
            

            dict[self.url] = self.fileName;

            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
            
            NSMutableDictionary *progresslist = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
            [progresslist removeObjectForKey:self.url];
            [[NSUserDefaults standardUserDefaults] setObject:progresslist forKey:@"progresslist"];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            

            
            [[NSFileManager defaultManager] removeItemAtPath:[self tsDirectory] error:NULL];
        }
        !(self.completionBlock)? : self.completionBlock(error);
        [self.tasks removeLastObject];
        self.isRun = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadCompletionNotification object:nil userInfo:@{@"url":self.url,@"completion":@(error? 0 : 1)}];

        if (self.tasks.count) {
            NSDictionary *task = self.tasks.lastObject;
            [self dowloadWithTs:task[@"ts"] url:task[@"url"] total:[task[@"total"] floatValue] fileName:task[@"fileName"] processBlock:task[@"processBlock"] completionBlock:task[@"completionBlock"]];
        }

        
    }];
}


@end
