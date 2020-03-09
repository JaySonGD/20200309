//
//  FFM3u8Dowloader.h
//  ffmpeg
//
//  Created by Jay on 25/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFM3u8Dowloader : NSObject
+ (FFM3u8Dowloader *)sharedManager;
- (void)dowloadWithUrl:(NSString *)url
              fileName:(NSString *)fileName
          processBlock:(void (^)(float process,float kbs,long long size))processBlock
       completionBlock:(void (^)(NSError *error))completionBlock;

+ (NSURL *)getCacheUrl:(NSString *)ourl;
+ (BOOL)isDowloaded:(NSString *)ourl;
+ (NSMutableArray *)videoList;
@end

NS_ASSUME_NONNULL_END
