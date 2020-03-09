//
//  FFmpegConverOC.m
//  ZJHVideoProcessing
//
//  Created by ZhangJingHao2345 on 2018/1/29.
//  Copyright © 2018年 ZhangJingHao2345. All rights reserved.
//

#import "FFmpegConverOC.h"
#import <Foundation/Foundation.h>
#import "FFmpegManager.h"

// 转换停止回调
void stopRuning(void) {
    [FFmpegManager stopRuning];
}

// 获取总时间长度
void setDuration(long long int time) {
    // 将这个数值除以1000000后得到的是秒数
    [FFmpegManager setDuration:time/1000000 + 1];
//    [FFmpegManager setTotalSize:size];
}

static int lastSize;
static float lastTime;

// 获取当前时间
void setCurrentTime(char info[1024]) {
    

    
    NSString *string = [NSString stringWithFormat:@"%s",info];
    //frame=   67 fps=0.0 q=-1.0 size=     320kB time=00:00:02.66 bitrate= 985.8kbits/s speed=4.21x
    NSString *regexStr = @"size=(.*?)kB time=(.*?)bitrate";
    
    //NSArray *res = matchString(string, sizeReg);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [res addObject:component];
            
        }
    }

    
    NSString *temp = @"";
    BOOL isBegin = false;
    int j = 5;
    for (int i = 0; i < 1024; i++) {
        // 获得时间开始的标记t
        if (info[i] == 't') {
            isBegin = true;
        }
        if (isBegin) {
            // 判断是否结束,结束了会输出空格
            if (info[i] == ' ') {
                break;
            }
            if (j > 0) {
                j--;
                continue;
            }else{
                temp = [temp stringByAppendingFormat:@"%c",info[i]];
            }
        }
    }
    //结果是00:00:00.00格式,转换为秒的格式
    int hour,min,second;
    hour = [[temp substringWithRange:NSMakeRange(0, 2)] intValue];
    min = [[temp substringWithRange:NSMakeRange(3, 2)] intValue];
    second = [[temp substringWithRange:NSMakeRange(6, 2)] intValue];
    second = hour * 3600 + min * 60 + second + 1;
    
    int size = [res[1] intValue];
    float time = hour * 3600 + min * 60 + [[temp substringWithRange:NSMakeRange(6, 4)] floatValue];
    
    float kbs = (time>lastTime)? (size - lastSize)/ (time - lastTime):0;

    lastSize = size;
    lastTime = time;
    
    [FFmpegManager setKbs:kbs];
    [FFmpegManager setCurrentTime:second];

}


NSArray* matchString(NSString *string,NSString *regexStr){
    
    if(!string) return @[];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
            
        }
        
    }
    
    return array;
}
