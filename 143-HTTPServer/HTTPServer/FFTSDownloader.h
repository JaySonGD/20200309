//
//  FFTSDownloader.h
//  ffmpeg
//
//  Created by Jayson on 2019/6/28.
//  Copyright © 2019年 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDownloadProgressNotification @"downloadProgressNotification"
#define kDownloadCompletionNotification @"downloadCompletionNotification"



@interface FFTSDownloader : NSObject

+ (FFTSDownloader *)sharedManager;

- (void)cancel;

- (void)dowloadWithTs:(NSArray<NSString *> *)ts
                  url:(NSString *)url
                total:(CGFloat )total
             fileName:(NSString *)fileName
         processBlock:(void (^)(float, float))processBlock
      completionBlock:(void (^)(NSError *))completionBlock;

+ (NSString *)getState:(NSString *)url;

+ (NSMutableArray *)videoList;

+ (NSURL *)getURL:(NSString *)uri;

@end
