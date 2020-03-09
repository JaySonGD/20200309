//
//  ZKRBaiWeiAdManager.h
//  VAPictureBoomAnimationDemo
//
//  Created by ZAKER on 2019/6/4.
//  Copyright © 2019 ZAKER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^completeBlock)(void);

typedef NS_ENUM(NSInteger, ZKRBaiWeiAVPlayerStatus) {
    
    ZKRBaiWeiAVPlayerStatusUnKnown  = 0, // 未知
    ZKRBaiWeiAVPlayerStatusReadyToPlay = 1, // 缓冲
    ZKRBaiWeiAVPlayerStatusPlaying  = 2, // 正在播放
    ZKRBaiWeiAVPlayerStatusPause  = 3, // 播放停止
    ZKRBaiWeiAVPlayerStatusFailed = 4  // 播放失败
};

@protocol ZKRBaiWeiAdManagerPlayerDelegate <NSObject>
/**
 * 点击播放视频
 */
- (void)touchInsideVideoLayer:(AVPlayer *)player;
- (void)playfinish:(AVPlayer *)player;
/**
 * 播放状态
 */
- (void)player:(AVPlayer*)player playStatusChanged:(ZKRBaiWeiAVPlayerStatus)status;

- (void)player:(AVPlayer *)player playProgress:(CGFloat)progress;

@end

@interface ZKRBaiWeiAdManager : NSObject

+ (instancetype)shareManager;

- (UIImage *)clipTofullScreen;
/**
 *  size: 切割layer的大小
 *  return: 用于做动画的蒙版view
 */
- (UIView *)lancinateAnimationView:(UIView *)view size:(CGSize)size;
/**
 *  sublayerH: 切割layer时高度
 *  duration: 动画时间
 *  repeatCount: 动画重复次数
 *  completeBlock: 动画完成回调
 */
- (void)lancinateAnimationView:(UIView *)view horizontalscale:(CGFloat)sublayerH animationDuration:(CGFloat)duration repeatCount:(NSInteger)conut completeBlock:(completeBlock)completeBlock;
/**
 *  sublayerW: 切割layer时宽度
 *  duration: 动画时间
 *  repeatCount: 动画重复次数
 *  completeBlock: 动画完成回调
 */
- (void)lancinateAnimationView:(UIView *)view verticalScale:(CGFloat)sublayerW animationDuration:(CGFloat)duration repeatCount:(NSInteger)conut completeBlock:(completeBlock)completeBlock;
/**
 * 针对百威广告特效设置的默认效果
 */
- (void)lancinateAnimateDefaultModeView:(UIView *)view completeBlock:(completeBlock)completeBlock;


///  ----->>>>>>>>>>> 视频播放
/**
 * 全屏播放
 */
- (void)playToFullScreen:(AVPlayer *)player delegate:(id<ZKRBaiWeiAdManagerPlayerDelegate>)delegate;
/**
 * 指定view作为容器播放
 */
- (void)playWithPlayer:(AVPlayer *)player playToView:(UIView *)view delegate:(id<ZKRBaiWeiAdManagerPlayerDelegate>)delegate;

- (void)playPause;
/**
 * 结束播放
 */
- (void)removePlayLayer;

@end

NS_ASSUME_NONNULL_END
