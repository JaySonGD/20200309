//
//  ViewController.m
//  m3u8
//
//  Created by Jay on 24/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "FFmpegManager.h"
#import "FFM3u8Dowloader.h"
#import "FFTSDownloader.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <CommonCrypto/CommonCrypto.h>

#import "xx/AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *kbs;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** <##> */
@property (nonatomic, copy) NSString *url;

@end

@implementation ViewController
- (IBAction)d:(id)sender {
    [self dealPlayList];
    
}
- (IBAction)cannel:(id)sender {
    [[FFTSDownloader sharedManager] cancel];
}

// 处理m3u8文件
- (void)dealPlayList {
    self.tipLab.text = @"处理m3u8文件";
    
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1/app/public/api/d?debug=99&url=%@",self.url]]];
    
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    NSArray *listArr = obj[@"ts"];
    CGFloat total = [obj[@"total"] floatValue];
    
    [[FFTSDownloader sharedManager] dowloadWithTs:listArr url:self.url total:total fileName:@"333" processBlock:^(float p, float kbs) {
        self.progressView.progress = p;

    } completionBlock:^(NSError *rr) {
        
    }];
    
    return;
    NSString *firstStr = listArr.firstObject;
    NSString *videoName = [firstStr componentsSeparatedByString:@"."].firstObject;
    self.tipLab.text = [NSString stringWithFormat:@"共有 %lu 个视频", (unsigned long)listArr.count];
    // 下载 ts 文件
    [self downloadVideoWithArr:listArr andIndex:0 videoName:videoName];
}

// 循环下载 ts 文件
- (void)downloadVideoWithArr:(NSArray *)listArr andIndex:(NSInteger)index videoName:(NSString *)videoName {
    if (index >= listArr.count) {
        self.tipLab.text = @"视频下载完成";
        [self combVideos];
        return;
    }
    
    self.tipLab.text = [NSString stringWithFormat:@"共有 %lu 个ts文件, 下载中：%.2f%%", (unsigned long)listArr.count, (float)index/listArr.count * 100];
    self.progressView.progress = (float)index/listArr.count;
    
    // 拼接ts全路径，有的文件直接包含，不需要拼接
    
    NSString *downloadURL = listArr[index];//[self.textView.text stringByReplacingOccurrencesOfString:self.textView.text.lastPathComponent withString:listArr[index]];
    
    // 存储路径
    //NSString *listName = listArr[index];
    NSString *fileName = [NSString stringWithFormat:@"video_%ld.ts",(long)index];
    
    //NSString *fileName = listName.pathComponents.lastObject;//[NSString stringWithFormat:@"video_%ld.%@",(long)index,listName.pathExtension];
    NSString *destinationPath = [self.videoPath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        [self downloadVideoWithArr:listArr andIndex:index+1 videoName:videoName];
        return;
    }
    
    __weak typeof(self)wkSelf = self;
    [self downloadURL:downloadURL
      destinationPath:destinationPath
             progress:nil
           completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
               if (!error) {
                   [wkSelf downloadVideoWithArr:listArr andIndex:index+1 videoName:videoName];
               }
           }];
}


// 合成为一个ts文件
- (void)combVideos {
    NSString *fileName = [NSString stringWithFormat:@"%@.ts",[self md5:self.url]];
    NSString *filePath = [[self videoPath] stringByAppendingPathComponent:fileName];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:filePath]) {
        [self convert];
        self.tipLab.text = @"已合成视频";
        return;
    }
    
    NSArray *contentArr = [mgr contentsOfDirectoryAtPath:[self videoPath]
                                                   error:nil];
    //NSMutableData *dataArr = [NSMutableData alloc];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    // 文件句柄
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    int videoCount = 0;
    for (NSString *str in contentArr) {
        @autoreleasepool {
            // 按顺序拼接 TS 文件
            if ([str containsString:@"video_"]) {
                NSString *videoName = [NSString stringWithFormat:@"video_%d.ts",videoCount];
                NSString *videoPath = [[self videoPath] stringByAppendingPathComponent:videoName];
                // 读出数据
                NSData *data = [[NSData alloc] initWithContentsOfFile:videoPath];
                // 合并数据
                //[dataArr appendData:data];
                //设置指向文件的末尾
                [handle seekToEndOfFile];
                // 写数据
                [handle writeData:data];

                
                videoCount++;
            }
        }
    }
    
    
    //[dataArr writeToFile:filePath atomically:YES];
    
    [self convert];
}

- (void)convert {
    

    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *ifilePath = [NSString stringWithFormat:@"%@.ts",[self md5:self.url]];
    NSString *ofilePath = [NSString stringWithFormat:@"%@.mp4",[self md5:self.url]];
    
    NSString *inPut = [[self videoPath] stringByAppendingPathComponent:ifilePath];
    NSString *outPut = [docDir stringByAppendingPathComponent:ofilePath];
    
    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -c copy -bsf:a aac_adtstoasc -y %@",inPut,outPut];
    [[FFmpegManager sharedManager] runCmd:cmd processBlock:^(float process, float kbs, long long size) {
        NSLog(@"%s", __func__);
        
    } completionBlock:^(NSError *error) {
        NSLog(@"%s", __func__);
    }];
}


// 视频列表路径
- (NSString *)videoPath {
    
    NSString *vedioPath = [self.documentPath stringByAppendingPathComponent:[self md5:self.url]];
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
- (NSString *)documentPath  {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return docDir;
}

// 下载方法
- (void)downloadURL:(NSString *)downloadURL
    destinationPath:(NSString *)destinationPath
           progress:(void (^)(NSProgress *downloadProgress))progress
         completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
    
    
    
    AFHTTPSessionManager *manage  = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: downloadURL]];
    
    NSURLSessionDownloadTask *downloadTask =
    [manage downloadTaskWithRequest:request
                           progress:^(NSProgress * _Nonnull downloadProgress) {
                               if (progress) {
                                   progress(downloadProgress);
                               }
                           }
                        destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                            
                            NSURL *filePathUrl = nil;
                            if (destinationPath) {
                                filePathUrl = [NSURL fileURLWithPath:destinationPath];
                            }
                            if (filePathUrl) {
                                return filePathUrl;
                            }
                            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                            NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
                            filePathUrl = [NSURL fileURLWithPath:fullpath];
                            return filePathUrl;
                        }
                  completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                      if (completion) {
                          completion(response, filePath, error);
                      }
                  }];
    
    [downloadTask resume];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url = @"http://yun.kubozy-youku-163.com/20190427/11956_d7043f8b/index.m3u8"; ;//@"http://zy.kubozy-youku-163-aiqi.com/20190710/13979_c1e699f0/index.m3u8";//@"http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8";
    // Do any additional setup after loading the view.
    self.textView.text = @"http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8";
    // @"https://dco4urblvsasc.cloudfront.net/811/81095_ywfZjAuP/game/1000kbps.m3u8";
    //http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8
    
//    [[FFM3u8Dowloader sharedManager] dowloadWithUrl:@"http://zy.kubozy-youku-163-aiqi.com/20190708/13827_8294e3e9/index.m3u8" fileName:@"[HD][2019-06-21]正午体育新闻：静待对手的感觉很不同.mp4" processBlock:^(float process, float kbs, long long size) {
//        
//    } completionBlock:^(NSError * _Nonnull error) {
//        
//    }];
    
    NSLog(@"%s---%@", __func__,self.documentPath);
    
    
    //    [[FFM3u8Dowloader sharedManager] dowloadWithUrl:@"http://zy.kubozy-youku-163-aiqi.com/20190423/6773_3d741253/index.m3u8" fileName:@"三国演义动画版-第01集.mp4" processBlock:^(float process, float kbs, long long size) {
    //
    //    } completionBlock:^(NSError * _Nonnull error) {
    //
    //    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //步骤1：获取视频路径
    // 沙盒路径
    //    NSString *directory = NSHomeDirectory();
    //    NSLog(@"沙盒路径 : %@", directory);
    //    NSString *file = [directory stringByAppendingPathComponent:@"88.mp4"];
    
    NSURL *webVideoUrl = [FFM3u8Dowloader getCacheUrl:@"http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8"];//[NSURL fileURLWithPath:file];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
}

@end
