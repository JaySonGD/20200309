//
//  FFM3u8Dowloader.m
//  ffmpeg
//
//  Created by Jay on 25/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "FFM3u8Dowloader.h"
#import "FFmpegManager.h"

@interface FFM3u8Dowloader ()
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, assign) BOOL isRun;
@end

@implementation FFM3u8Dowloader

+ (FFmpegManager *)sharedManager {
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
+ (NSURL *)getCacheUrl:(NSString *)ourl{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"];
    NSString *fileName = dict[ourl];
    
    NSString *directory =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    directory = @"/Users/jay/Desktop/";

    return fileName? [NSURL fileURLWithPath:[directory stringByAppendingPathComponent:fileName]] : [NSURL URLWithString:ourl];
}

+ (BOOL)isDowloaded:(NSString *)ourl{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"];
    NSString *fileName = dict[ourl];
    return fileName? YES : NO;
}

+ (NSMutableArray *)videoList{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"];
    NSArray *names = dict.allValues;
    NSMutableArray *list = [NSMutableArray array];
    [names enumerateObjectsUsingBlock:^(NSString * name, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:@{
                          @"name":name,
                          @"loc":[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name],
                          @"url":dict.allKeys[idx]
                          }];
    }];
    
    return list;
}


// 转换视频
- (void)dowloadWithUrl:(NSString *)url
                 fileName:(NSString *)fileName
               processBlock:(void (^)(float process,float kbs,long long size))processBlock
            completionBlock:(void (^)(NSError *error))completionBlock {
    
    if (![url containsString:@"http"]) {
        completionBlock([NSError errorWithDomain:@"URL非法!"
                                            code:0
                                        userInfo:nil]);
        return;
    }
    
    if([FFM3u8Dowloader isDowloaded:url]){
        !(completionBlock)? : completionBlock(nil);
        return;
    }
    
    NSArray <NSString *>*urls = [self.tasks valueForKeyPath:@"url"];
    
    if(![urls containsObject:url]) {
        [self.tasks insertObject:@{
                                   @"url" : url,
                                   @"fileName":fileName,
                                   @"processBlock":processBlock,
                                   @"completionBlock":completionBlock
                                   } atIndex:0];
    }
    
    if (self.isRun) return;
    // 沙盒路径
    NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    

    
    NSLog(@"沙盒路径 : %@", directory);
    
    directory = @"/Users/jay/Desktop/";
    //NSString *url = @"http://yun.kubozy-youku-163.com/20190330/9540_fc900e04/index.m3u8";
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    
    //ffmpeg -i https://host/really.m3u8 xinxijuzhiwang.mp4
    
    //ffmpeg -i http://yun.kubo-zy-youku.com/20180619/8Ne1BjmP/index.m3u8 -c copy -bsf:a aac_adtstoasc /Users/jay/Desktop/output.mp4
    
    //ffmpeg -i http://yun.kubo-zy-youku.com/20180619/8Ne1BjmP/index.m3u8 -c copy -bsf:a aac_adtstoasc -y /Users/jay/Desktop/output.mp4
    
    
    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -c copy -bsf:a aac_adtstoasc -y %@",url,filePath];
    //cmd = @"ffmpeg -i http://yun.kubo-zy-youku.com/20180619/8Ne1BjmP/index.m3u8 -c copy -bsf:a aac_adtstoasc -y /Users/jay/Desktop/output.mp4";
    self.isRun = YES;
    [[FFmpegManager sharedManager] runCmd:cmd processBlock:^(float process,float kbs,long long size) {
        
        NSLog(@"%@--%f---%f---", fileName,process,kbs);
        !(processBlock)? : processBlock(process,kbs,0);

    } completionBlock:^(NSError *error) {
        self.isRun = NO;
        if (!error) {
            NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"m3u8list"].mutableCopy;
            if (!dict) {
                dict = [NSMutableDictionary dictionary];
            }
            
            dict[url] = fileName;
            
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"m3u8list"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        !(completionBlock)? : completionBlock(error);
        [self.tasks removeLastObject];
        
        if (self.tasks.count) {
            NSDictionary *task = self.tasks.lastObject;
            [self dowloadWithUrl:task[@"url"] fileName:task[@"fileName"] processBlock:task[@"processBlock"] completionBlock:task[@"completionBlock"]];
        }

    }];

}

@end
