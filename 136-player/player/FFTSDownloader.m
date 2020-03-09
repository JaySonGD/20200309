//
//  FFTSDownloader.m
//  ffmpeg
//
//  Created by Jayson on 2019/6/28.
//  Copyright © 2019年 AA. All rights reserved.
//

#import "FFTSDownloader.h"

#import <CommonCrypto/CommonCrypto.h>
#import <HTTPServer.h>

@implementation FFTSegTs



@end

@interface FFTSDownloader ()

@property (nonatomic, assign) NSInteger tsCount;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSMutableArray *tasks;

@property (nonatomic, copy) void (^processBlock)(float process,float kbs);
@property (nonatomic, copy) void (^completionBlock)(NSError *error);

@property (nonatomic, strong) NSMutableDictionary *downloadTask;

@property (nonatomic, assign) NSInteger  maxCount;

@property (nonatomic, assign) CGFloat total;


@property (strong, nonatomic) HTTPServer *httpServer;

@property (nonatomic, copy) NSString *extm3u;

@end


@implementation FFTSDownloader

+ (FFTSDownloader *)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        FFTSDownloader *obj = [self new];
        obj.maxCount = 20;
        instance = obj;
    });
    return instance;
}
- (NSMutableDictionary *)downloadTask{
    if (!_downloadTask) {
        _downloadTask = [NSMutableDictionary dictionary];
    }
    return _downloadTask;
}
- (NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

+ (NSString *)getCacheUrl:(NSString *)url{
    
    
//    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
//
//    if (!dict) return url;
//
//
//    NSString *fileName = dict[url];
//
//    if (!fileName) return url;
//
    NSString *file = [NSString stringWithFormat:@"%@.m3u8",[[FFTSDownloader sharedManager] md5:url]];
    NSString *filePath = [[[FFTSDownloader sharedManager] mainDirectory] stringByAppendingPathComponent:file];
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ){
        if(![[FFTSDownloader sharedManager] openServer]) return url;
        return [NSString stringWithFormat:@"http://127.0.0.1:%hu/%@",[FFTSDownloader sharedManager].httpServer.listeningPort,file];
    }
    
//    [dict removeObjectForKey:url];
//    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return  url;
    
}


+ (NSString *)getState:(NSString *)url{
    __block NSString *state = @"";
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
        
        NSString *filePath = [[[FFTSDownloader sharedManager] mainDirectory] stringByAppendingPathComponent:file];
        
        [list addObject:@{
                          @"state" : @"已完成",
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


- (void)dowloadWithUrl:(NSString *)url
              fileName:(NSString *)fileName
          processBlock:(void (^)(float, float))processBlock
       completionBlock:(void (^)(NSError *))completionBlock{
    //url = @"http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1/app/public/api/d1?debug=99&url=%@",url]]];

        if(!data){
            completionBlock([NSError errorWithDomain:@"接口出错"
                                                code:0
                                            userInfo:nil]);
            return ;
        }

        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
        NSArray *ts = obj[@"ts"];
        CGFloat total = [obj[@"total"] floatValue];
        
        
        
        if(!ts){
            completionBlock([NSError errorWithDomain:@"下载数据为空"
                                                code:0
                                            userInfo:nil]);
            return ;
        }
        
        __block NSString *header = [NSString stringWithFormat:@"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-TARGETDURATION:%ld\n",(long)(total + 10)];
        
        
        [ts enumerateObjectsUsingBlock:^(NSDictionary *ts, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //文件名
            //NSString *fileName = [NSString stringWithFormat:@"%@/%@.ts", [self md5:self.url],[self md5:self.url]];
            //NSString *fileName = ts[@"url"];
            NSString *fileName = [NSString stringWithFormat:@"%@/video_%ld.ts",[self md5:url],idx];

            //文件时长
            NSString* length = [NSString stringWithFormat:@"#EXTINF:%@,\n",ts[@"duration"]];
            //拼接M3U8
            header = [header stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", length, fileName]];
            
        }];
        
        header = [header stringByAppendingString:@"#EXT-X-ENDLIST"];
        
        NSString *m3u8File = [NSString stringWithFormat:@"%@.m3u8",[self md5:url]];
        NSString *m3u8Path = [[self mainDirectory] stringByAppendingPathComponent:m3u8File];
        [header writeToFile:m3u8Path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        self.extm3u = header;
        
        __block CGFloat startProgress = 0;
        __block NSMutableArray *tss = [NSMutableArray array];
        
        [ts enumerateObjectsUsingBlock:^(NSDictionary *ts, NSUInteger idx, BOOL * _Nonnull stop) {
            FFTSegTs *tsModel = [[FFTSegTs alloc] init];
            tsModel.url = ts[@"url"];
            tsModel.duration = [ts[@"duration"] floatValue];
            tsModel.file = [NSString stringWithFormat:@"%@/video_%ld.ts",[self md5:url],idx];
            CGFloat st = startProgress;
            startProgress += tsModel.duration / total;
            tsModel.segments = @[@(st),@(startProgress)];
            [tss addObject:tsModel];
        }];

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dowloadWithTs:tss url:url total:total  fileName:fileName processBlock:processBlock completionBlock:completionBlock];
        });
        
    });
}



- (void)dowloadWithTs:(NSArray<FFTSegTs *> *)ts
                  url:(NSString *)url
                total:(CGFloat )total
             fileName:(NSString *)fileName
         processBlock:(void (^)(float, float))processBlock
      completionBlock:(void (^)(NSError *))completionBlock{
    
    if (![url containsString:@"http"] || !ts.count) {
        completionBlock([NSError errorWithDomain:@"参数非法!"
                                            code:0
                                        userInfo:nil]);
        return;
    }
    
    
    if ([FFTSDownloader isDownloaded:url]) {
        !(completionBlock)? : completionBlock(nil);
        return;
    }
    
    NSArray <NSString *>*urls = [self.tasks valueForKeyPath:@"url"];
    
    if(![urls containsObject:url]) {
        [self.tasks insertObject:@{
                                   @"state" : @"等待中",
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
    self.isRun = YES;
    // 下载 ts 文件
    //[self downloadVideoWithArr:ts andIndex:0];
    for (NSInteger i = 0; i < self.maxCount; i++) {
        [self downloadVideoWithArr:ts andIndex:i];
    }
    
    
}

+ (BOOL)isDownloaded:(NSString *)url{
    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
    
    if (!dict) return NO;
    
    
    NSString *fileName = dict[url];
    
    if (!fileName) return NO;
    
    NSString *file = [NSString stringWithFormat:@"%@.m3u8",[[FFTSDownloader sharedManager] md5:url]];
    NSString *filePath = [[[FFTSDownloader sharedManager] mainDirectory] stringByAppendingPathComponent:file];
    
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ){
        return YES;
    }
    
    [dict removeObjectForKey:url];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return  NO;
}


// 循环下载 ts 文件
- (void)downloadVideoWithArr:(NSArray <FFTSegTs *>*)listArr andIndex:(NSInteger)index{
    
    NSInteger downedCount = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self tsDirectory]
                                                                                error:nil].count;
    CGFloat process = (float)downedCount/(listArr.count+1);
    
    [self.tasks enumerateObjectsUsingBlock:^(NSMutableDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[@"url"] isEqualToString:self.url]) {
            obj[@"process"] = @(process);
            obj[@"state"] = @"下载中";
            obj[@"speed"] = [self speedString:0];
            *stop = YES;
        }
    }];
    
    //    NSMutableDictionary *obj = self.tasks.lastObject;
    //    obj[@"process"] = @(process);
    //    obj[@"speed"] = [self speedString:0];
    
    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[self.url] = @{
                       @"state" : @"暂停中",
                       @"url" : self.url,
                       @"fileName":self.fileName,
                       @"process" : @(process),
                       @"speed":   [self speedString:0]
                       };
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"progresslist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    !(_processBlock)? : _processBlock(process , 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:@{@"url":self.url,@"process":@(process),@"speed":[self speedString:0]}];
    
    
    if (downedCount >= listArr.count) {
        //self.tipLab.text = @"视频下载完成";
        NSLog(@"%s------视频下载完成", __func__);
        //[self combVideos];
        return;
    }
    
    //self.tipLab.text = [NSString stringWithFormat:@"共有 %lu 个ts文件, 下载中：%.2f%%", (unsigned long)listArr.count, (float)index/listArr.count * 100];
    //self.progressView.progress = (float)index/listArr.count;
    //!(_processBlock)? : _processBlock((float)index/listArr.count+1 , 0);
    
    if(index >= listArr.count){
        NSLog(@"%s-------该线程已处理完毕", __func__);
        return;
    }
    
    //NSString *downloadURL = listArr[index].url;
    NSString *tsName = [NSString stringWithFormat:@"video_%ld.ts",(long)index];
    
    NSString *destinationPath = [self.tsDirectory stringByAppendingPathComponent:tsName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        //        [self downloadVideoWithArr:listArr andIndex:index+1];
        [self downloadVideoWithArr:listArr andIndex:index + self.maxCount];
        
        return;
    }
    
    __weak typeof(self)wkSelf = self;
    NSURLSessionDownloadTask *downloadTask = [self downloadURL:listArr[index]//downloadURL
                                               destinationPath:destinationPath
                                                    completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                        if (!error) {
                                                            NSLog(@"%s---%@---%@-下载完成", __func__,self.fileName,tsName);
                                                            //                   [wkSelf downloadVideoWithArr:listArr andIndex:index+1];
                                                            [wkSelf downloadVideoWithArr:listArr andIndex:index + self.maxCount];
                                                        }
                                                    }];
    self.downloadTask[[NSString stringWithFormat:@"%ld",index]] = downloadTask;
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
    NSLog(@"%s-------合成视频", __func__);
    [self convert];
}

// 视频列表路径
- (NSString *)tsDirectory {
    
    NSString *vedioPath = [self.mainDirectory stringByAppendingPathComponent:[self md5:self.url]];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:vedioPath]) {
        [mgr createDirectoryAtPath:vedioPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
    return vedioPath;
}

// xiazai 路径
- (NSString *)mainDirectory  {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *ffPath = [docDir stringByAppendingPathComponent:@"ffts"];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:ffPath]) {
        [mgr createDirectoryAtPath:ffPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
    return ffPath;
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
- (NSURLSessionDownloadTask *)downloadURL:(FFTSegTs *)ts//:(NSString *)downloadURL
                          destinationPath:(NSString *)destinationPath
                               completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
    
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString: ts.url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
            
            [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:destinationPath error:NULL];
            
            self.extm3u = [self.extm3u stringByReplacingOccurrencesOfString:ts.url withString:ts.file];
            NSString *m3u8File = [NSString stringWithFormat:@"%@.m3u8",[self md5:self.url]];
            NSString *m3u8Path = [[self mainDirectory] stringByAppendingPathComponent:m3u8File];
            
            NSError *error;
            [self.extm3u writeToFile:m3u8Path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            NSLog(@"%s------error:%@", __func__,error);

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response, error? nil :[NSURL fileURLWithPath:destinationPath], error);
        });
    }];
    [downloadTask resume];
    return downloadTask;
}

- (void)cancel{
    
    [self.tasks enumerateObjectsUsingBlock:^(NSMutableDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[@"url"] isEqualToString:self.url]) {
            obj[@"state"] = @"暂停中";
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:@{@"url":self.url,@"process":obj[@"process"],@"speed":obj[@"speed"]}];
            *stop = YES;
        }
    }];
    
    
    NSLog(@"%s---%@---暂停了", __func__,self.fileName);
    [self.downloadTask enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSURLSessionDownloadTask * obj, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    //[self.downloadTask makeObjectsPerformSelector:@selector(cancel)];
    self.downloadTask = nil;
    self.isRun = NO;
    self.url = nil;
    self.fileName = nil;
    self.processBlock = nil;
    self.completionBlock = nil;
    self.tsCount = 0;
}

- (NSString *)tsPath{
    NSString *ifilePath = [NSString stringWithFormat:@"%@.ts",[self md5:self.url]];
    //NSString *inPut = [[self tsDirectory] stringByAppendingPathComponent:ifilePath];
    NSString *inPut = [[self mainDirectory] stringByAppendingPathComponent:ifilePath];

    return inPut;
}

- (NSString *)mp4Path{
    NSString *ofilePath = [NSString stringWithFormat:@"%@.mp4",[self md5:self.url]];
    
    NSString *outPut = [[self mainDirectory] stringByAppendingPathComponent:ofilePath];
    
    return outPut;
}

- (void)convert {
    
    
    NSString *header = [NSString stringWithFormat:@"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-TARGETDURATION:%ld\n",(long)(self.total + 10)];
    //文件名
    //NSString *fileName = [NSString stringWithFormat:@"%@/%@.ts", [self md5:self.url],[self md5:self.url]];
    NSString *fileName = [NSString stringWithFormat:@"%@.ts",[self md5:self.url]];

    //文件时长
    NSString* length = [NSString stringWithFormat:@"#EXTINF:%f,\n",self.total];
    //拼接M3U8
    header = [header stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", length, fileName]];
    
    header = [header stringByAppendingString:@"#EXT-X-ENDLIST"];
    
    NSString *m3u8File = [NSString stringWithFormat:@"%@.m3u8",[self md5:self.url]];
    NSString *m3u8Path = [[self mainDirectory] stringByAppendingPathComponent:m3u8File];
    [header writeToFile:m3u8Path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
  
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
    
    !(self.completionBlock)? : self.completionBlock(nil);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadCompletionNotification object:nil userInfo:@{@"url":self.url,@"completion":@(1)}];
    
    [self.tasks removeLastObject];
    
    self.isRun = NO;
    self.url = nil;
    self.fileName = nil;
    self.processBlock = nil;
    self.completionBlock = nil;
    self.tsCount = 0;
    self.downloadTask = nil;
    
    if (self.tasks.count) {
        NSDictionary *task = self.tasks.lastObject;
        [self dowloadWithTs:task[@"ts"] url:task[@"url"] total:[task[@"total"] floatValue] fileName:task[@"fileName"] processBlock:task[@"processBlock"] completionBlock:task[@"completionBlock"]];
    }

    
    return;

    
    //NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -c copy -bsf:a aac_adtstoasc -y %@",[self tsPath],[self mp4Path]];
    //NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -y %@",[self tsPath],[self mp4Path]];
    //NSString *cmd = [NSString stringWithFormat:@"ffmpeg -ss 00:00:00 -i %@ -b:v 2000K -y %@",[self tsPath],[self mp4Path]];
//    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -acodec copy -vcodec copy -absf aac_adtstoasc -y %@",[self tsPath],[self mp4Path]];
    
    
    //NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -vcodec libx264 -vb 450k -acodec libvo_amrwbenc -ab 96k -y %@",[self tsPath],[self mp4Path]];
    
    return;
//    [[FFmpegManager sharedManager] runCmd:cmd processBlock:^(float process, float kbs, long long size) {
//        NSLog(@"%s--TS<->MP4-%f", __func__,process);
//
//        CGFloat p = (self.tsCount+process)/(self.tsCount+1);
//        NSMutableDictionary *obj = self.tasks.lastObject;
//        obj[@"process"] = @(p);
//        obj[@"speed"] = [self speedString:kbs];
//
//        !(self.processBlock)? : self.processBlock( p , kbs);
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:@{@"url":self.url,@"process":@(p),@"speed":[self speedString:kbs]}];
//
//
//    } completionBlock:^(NSError *error) {
//        NSLog(@"%s---ok---", __func__);
//
//        if (!error) {
//            NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
//            if (!dict) {
//                dict = [NSMutableDictionary dictionary];
//            }
//
//            dict[self.url] = self.fileName;
//
//            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
//
//            NSMutableDictionary *progresslist = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
//            [progresslist removeObjectForKey:self.url];
//            [[NSUserDefaults standardUserDefaults] setObject:progresslist forKey:@"progresslist"];
//
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            [[NSFileManager defaultManager] removeItemAtPath:[self tsDirectory] error:NULL];
//        }
//        !(self.completionBlock)? : self.completionBlock(error);
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadCompletionNotification object:nil userInfo:@{@"url":self.url,@"completion":@(error? 0 : 1)}];
//
//        [self.tasks removeLastObject];
//
//        self.isRun = NO;
//        self.url = nil;
//        self.fileName = nil;
//        self.processBlock = nil;
//        self.completionBlock = nil;
//        self.tsCount = 0;
//        self.downloadTask = nil;
//
//        if (self.tasks.count) {
//            NSDictionary *task = self.tasks.lastObject;
//            [self dowloadWithTs:task[@"ts"] url:task[@"url"] fileName:task[@"fileName"] processBlock:task[@"processBlock"] completionBlock:task[@"completionBlock"]];
//        }
//
//
//    }];
}

- (BOOL)urlIsRun:(NSString *)url{
    if ([self.url isEqualToString:url] && self.downloadTask) {
        return YES;
    }
    
    return NO;
}

- (NSString *)speedString:(NSInteger)speed{
    NSString *speedStr = @"";
    if (speed >= 0 && speed < 1024) {
        //B
        speedStr = [NSString stringWithFormat:@"%ldkb/s", (long)speed];
    } else if (speed >= 1024 && speed < 1024 * 1024) {
        //KB
        speedStr = [NSString stringWithFormat:@"%.2lfmb/s", (long)speed / 1024.0];
    }
    return speedStr;
}

+ (BOOL)canDelete:(NSString *)url{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"];
    NSMutableArray <NSString *>*urls = dict.allKeys.mutableCopy;
    
    
    NSMutableDictionary *progresslist = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
    
    [urls addObjectsFromArray:progresslist.allKeys];
    
    return [urls containsObject:url];
    
}

+ (void)delete:(NSString *)url{
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
    NSMutableDictionary *progresslist = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"progresslist"].mutableCopy;
    
    [dict removeObjectForKey:url];
    [progresslist removeObjectForKey:url];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
    [[NSUserDefaults standardUserDefaults] setObject:progresslist forKey:@"progresslist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSString *tsDir = [[[FFTSDownloader sharedManager] mainDirectory] stringByAppendingPathComponent:[[FFTSDownloader sharedManager] md5:url]];
    
    NSString *file = [NSString stringWithFormat:@"%@.m3u8",[[FFTSDownloader sharedManager] md5:url]];
    NSString *filePath = [[[FFTSDownloader sharedManager] mainDirectory] stringByAppendingPathComponent:file];
    
    NSString *tsFile = [NSString stringWithFormat:@"%@.ts",[[FFTSDownloader sharedManager] md5:url]];
    NSString *tsFilePath = [[[FFTSDownloader sharedManager] mainDirectory] stringByAppendingPathComponent:tsFile];
    
    [[NSFileManager defaultManager] removeItemAtPath:tsDir error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:tsFilePath error:NULL];

}



- (BOOL)openServer {
    
    if (!self.httpServer) {
        self.httpServer=[[HTTPServer alloc]init];
        [self.httpServer setType:@"_http._tcp."];
        [self.httpServer setPort:9479];
        NSString *webPath = [self mainDirectory];//[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        [self.httpServer setDocumentRoot:webPath];
        NSLog(@"服务器路径：%@", webPath);
    }
    
    NSError *error;
    if (!self.httpServer.isRunning && [self.httpServer start:&error]) {
        NSLog(@"开启HTTP服务器 端口:%hu",[self.httpServer listeningPort]);
        return YES;
    }
    else{
        NSLog(@"服务器启动失败错误为:%@",error);
        return NO;
    }
}


@end
