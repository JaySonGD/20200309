//
//  ZKRBaiWeiAdManager.m
//  VAPictureBoomAnimationDemo
//
//  Created by ZAKER on 2019/6/4.
//  Copyright © 2019 ZAKER. All rights reserved.
//

#import "ZKRBaiWeiAdManager.h"
//#import "UIView+lancinateAnimation.h"

static ZKRBaiWeiAdManager *shareManager_ = nil;

@interface ZKRBaiWeiAdManager ()

@property (nonatomic, weak) UIView *animationView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerLayer *palyLayer;

@property (nonatomic, assign) ZKRBaiWeiAVPlayerStatus status;

@property (nonatomic, weak) UIButton *maskBtn;

@property (nonatomic, strong) id listenObj;

@property (nonatomic, weak) id <ZKRBaiWeiAdManagerPlayerDelegate>delegate;

@end

@implementation ZKRBaiWeiAdManager

+ (instancetype)shareManager{
    
    shareManager_ = [[ZKRBaiWeiAdManager alloc] init];
    return shareManager_;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (shareManager_) {
        return shareManager_;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       shareManager_ = [super allocWithZone:zone];
    });
    return shareManager_;
}
- (UIImage *)clipTofullScreen{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;

        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

- (UIView *)lancinateAnimationView:(UIView *)view size:(CGSize)size{
    
    UIView* animationView = [[UIView alloc] initWithFrame:view.bounds];
    [view.superview addSubview:animationView];
    [self setAnimationView:animationView];
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:view.bounds] fill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSInteger maxX = floor(screenshotImage.size.width / size.width);
    NSInteger maxY = floor(screenshotImage.size.height / size.height);
    for (int i=0; i<maxX; i++) {
        for (int j = 0; j<maxY; j++) {
            
            @autoreleasepool {
                
                CALayer* layer = [[CALayer alloc] init];
                layer.frame = CGRectMake(i*size.width, (maxY-j-1)*size.height, size.width, size.height);
                CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                                      size.width,
                                                                      size.height,
                                                                      8,
                                                                      0,
                                                                      CGImageGetColorSpace(screenshotImage.CGImage),
                                                                      kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
                CGContextTranslateCTM(offscreenContext, -i*size.width, -j*size.height);
                CGContextDrawImage(offscreenContext, CGRectMake(0, 0, screenshotImage.size.width, screenshotImage.size.height), screenshotImage.CGImage);
                CGImageRef imageRef = CGBitmapContextCreateImage(offscreenContext);
                
                layer.contents = CFBridgingRelease(imageRef);
                CGContextRelease(offscreenContext);
                [self.animationView.layer addSublayer:layer];
                
            }
        }
    }
    return self.animationView;
    
}
- (void)lancinateAnimationView:(UIView *)view horizontalscale:(CGFloat)sublayerH animationDuration:(CGFloat)duration repeatCount:(NSInteger)conut completeBlock:(completeBlock)completeBlock{
    
    [self lancinateAnimationView:view size:CGSizeMake(view.bounds.size.width, sublayerH)];
    [self doLancinateAnimationKeyPath:@"transform.scale.x" duration:duration repeatCount:conut completeBlock:completeBlock];
    
}
- (void)lancinateAnimationView:(UIView *)view verticalScale:(CGFloat)sublayerW animationDuration:(CGFloat)duration repeatCount:(NSInteger)conut completeBlock:(completeBlock)completeBlock{
    
    [self lancinateAnimationView:view size:CGSizeMake(sublayerW, view.bounds.size.height)];
    [self doLancinateAnimationKeyPath:@"transform.scale.y" duration:duration repeatCount:conut completeBlock:completeBlock];
}

- (void)doLancinateAnimationKeyPath:(NSString *)key duration:(CGFloat)duration repeatCount:(NSInteger)conut completeBlock:(completeBlock)completeBlock{
    
    for (CALayer *shape in self.animationView.layer.sublayers) {
        @autoreleasepool {
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:key];
            scaleAnimation.fromValue = @(1.0);
            CGFloat rand1 = (float)random()/(float)RAND_MAX *0.07 - 0.035;
            CGFloat rand2 = (float)random()/(float)RAND_MAX *0.07 - 0.035;
            CGFloat rand3 = (float)random()/(float)RAND_MAX *0.07 - 0.035;
            CGFloat rand = (rand1 + rand2 + rand3)/3.0;
            scaleAnimation.toValue = @(rand+ 1.0);
            scaleAnimation.duration = duration;
            scaleAnimation.repeatCount  = conut;
            [shape addAnimation:scaleAnimation forKey:@"lancinateAnimationX"];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.animationView removeFromSuperview];
        self.animationView = nil;
        
        if (completeBlock) {
            completeBlock();
        }
    });
    
}

- (void)lancinateAnimateDefaultModeView:(UIView *)view completeBlock:(completeBlock)completeBlock{
    
    [self lancinateAnimationView:view horizontalscale:8.0 animationDuration:0.4 repeatCount:1 completeBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lancinateAnimationView:view verticalScale:2.5 animationDuration:0.4 repeatCount:1 completeBlock:^{
                
                [self lancinateAnimationView:view horizontalscale:8.0 animationDuration:0.4 repeatCount:1 completeBlock:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self lancinateAnimationView:view verticalScale:2.5 animationDuration:0.4 repeatCount:1 completeBlock:^{
                            
                            if (completeBlock) {
                                completeBlock();
                            }
                        }];
                    });
                }];
            }];
        });
    }];
}


/// 视频相关
- (void)playToFullScreen:(AVPlayer *)player delegate:(id<ZKRBaiWeiAdManagerPlayerDelegate>)delegate{
    
    [self playWithPlayer:player playToView:[UIApplication sharedApplication].keyWindow delegate:delegate];
}

- (void)playWithPlayer:(AVPlayer *)player playToView:(UIView *)view delegate:(id<ZKRBaiWeiAdManagerPlayerDelegate>)delegate{
    
    if (!player) {
        NSLog(@"player不能为空");
        return;
    }
     _player = player;
    
    if (!view) {
        NSLog(@"view不能为空");
        return;
    }
    
    if (delegate) {
        _delegate = delegate;
    }
    self.palyLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.palyLayer.frame = view.bounds;
    
    UIButton *maskBtn = [UIButton new];
    _maskBtn = maskBtn;
    [maskBtn addTarget:self action:@selector(touchedVideo) forControlEvents:UIControlEventTouchUpInside];
    maskBtn.backgroundColor = [UIColor clearColor];
    maskBtn.frame = view.bounds;
    [view addSubview:maskBtn];
    
    [view.layer addSublayer:self.palyLayer];
    [player play];
    if (@available(iOS 10.0, *)) {
        [player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    }

   __weak typeof(self)weakSelf = self;
   self.listenObj = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {

        CGFloat progress = CMTimeGetSeconds(player.currentItem.currentTime) / CMTimeGetSeconds(player.currentItem.duration);
       
       if ([weakSelf.delegate respondsToSelector:@selector(player:playProgress:)]) {
           [weakSelf.delegate player:weakSelf.player playProgress:progress];
       }
       
        if (progress == 1.0f) {
            if ([weakSelf.delegate respondsToSelector:@selector(playfinish:)]) {
                [weakSelf.delegate playfinish:weakSelf.player];
            }
            [weakSelf.player removeTimeObserver:weakSelf.listenObj];
        }
    }];
}
- (void)touchedVideo{
   
    if ([_delegate respondsToSelector:@selector(touchInsideVideoLayer:)]) {
         [_delegate touchInsideVideoLayer:_player];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == _player && [keyPath isEqualToString:@"timeControlStatus"]) {
        
            AVPlayerTimeControlStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            if (status ==  AVPlayerTimeControlStatusPaused) {
                _status = ZKRBaiWeiAVPlayerStatusPause;
            }
            
            if (status == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
                _status = ZKRBaiWeiAVPlayerStatusReadyToPlay;
            }
            
            if (status ==  AVPlayerTimeControlStatusPlaying) {
                _status = ZKRBaiWeiAVPlayerStatusPlaying;
            }
            if ([_delegate respondsToSelector:@selector(player:playStatusChanged:)]) {
                [_delegate player:_player playStatusChanged:_status];
            }
        }
}

- (void)playPause{
    if (_player) {
        [_player pause];
    }
}

- (void)removePlayLayer{
    
    [self playPause];
    
    [self.palyLayer removeFromSuperlayer];
    self.player = nil;
    self.palyLayer = nil;
    [_maskBtn removeFromSuperview];
    _maskBtn = nil;
}
@end
