//
//  FFmpegManager.h
//  ZJHVideoProcessing
//
//  Created by ZhangJingHao2345 on 2018/1/29.
//  Copyright © 2018年 ZhangJingHao2345. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFmpegManager : NSObject

+ (FFmpegManager *)sharedManager;



- (void)runCmd:(NSString *)commandStr
  processBlock:(void (^)(float process,float kbs,long long size))processBlock
completionBlock:(void (^)(NSError *error))completionBlock;


+ (void)setKbs:(float)kbs;

+ (void)setTotalSize:(long long)size;
// 设置总时长
+ (void)setDuration:(long long)time;

// 设置当前时间
+ (void)setCurrentTime:(long long)time;

// 转换停止
+ (void)stopRuning;

@end
