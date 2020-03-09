//
//  AAPlayer.m
//  player
//
//  Created by xin on 2019/6/23.
//  Copyright © 2019年 Adc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import "AAPlayer.h"


@interface AAPLPlayerView : UIView
@property (readonly) AVPlayerLayer *playerLayer;
@end


@implementation AAPLPlayerView

// override UIView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end


typedef NS_ENUM(NSUInteger, AAPlayerState) {
    AAPlayerStateSmall,
    AAPlayerStateAnimating,
    AAPlayerStateRight,
    AAPlayerStateLeft,
};


// Private properties
@interface AAPlayer ()

@property (strong, nonatomic) AVPlayerItem *playerItem;
//@property (weak, nonatomic) AAPLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *coverView;


@property (weak, nonatomic) IBOutlet AAPLPlayerView *playerView;
@property (weak) IBOutlet UISlider *timeSlider;
@property (weak) IBOutlet UILabel *startTimeLabel;
@property (weak) IBOutlet UILabel *durationLabel;
@property (weak) IBOutlet UIButton *fullButton;
@property (weak) IBOutlet UIButton *playPauseButton;
@property (weak) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIProgressView *loadBufView;
@property (weak, nonatomic) IBOutlet UILabel *bufProgress;


@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVURLAsset *asset;

@property (strong, nonatomic) id<NSObject> timeObserverToken;

@property (assign, nonatomic) float rate;
@property (assign, nonatomic) CMTime currentTime;

@property (assign, nonatomic,readonly) CMTime duration;


@property (nonatomic, assign) AAPlayerState state;

@property (nonatomic, assign) CGRect playViewSmallFrame;

@property (nonatomic, weak) UIView *playViewParentView;

@end

static int AAPLPlayerViewControllerKVOContext = 0;

@implementation AAPlayer


+ (instancetype)player{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}

- (void)layoutSubviews{
    [super layoutSubviews];

}


- (void)setUI{
    
    [self addObserver];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"Line"] forState:UIControlStateNormal];
    [self.timeSlider addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(progressSliderTapped:)];
        tap;
    })];
    
    [self addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTapGesture)];
        tap;
    })];


    self.playerView.playerLayer.player = self.player;
    
    //NSURL *movieURL = [NSURL URLWithString:@"http://yun.kubozy-youku-163.com/20190517/13269_6b28fe19/index.m3u8"];
    //self.asset = [AVURLAsset assetWithURL:movieURL];
    
    // Use a weak self variable to avoid a retain cycle in the block.
    __weak typeof(self) weakSelf = self;
    _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:
                          ^(CMTime time) {
                              
                              double newDurationSeconds = CMTimeGetSeconds(time);
                              int wholeMinutes = (int)trunc(newDurationSeconds / 60);
                              
                              weakSelf.timeSlider.value = CMTimeGetSeconds(time);
                              weakSelf.startTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];
                              NSLog(@"%s---%f", __func__,CMTimeGetSeconds(time));
                          }];
    


}

- (void)play:(NSString *)url{
    
    NSURL *movieURL = [NSURL URLWithString:url];
    self.asset = [AVURLAsset assetWithURL:movieURL];
    
}


//FIXME:  -  视频触摸的回调
- (void)handleTapGesture{
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControll) object:nil];
    if (self.coverView.isHidden) {//不隐藏的时候
        [self performSelector:@selector(hiddenControll) withObject:nil afterDelay:5.0];
    }
    
    
    //if (self.state == AAPlayerStateSmall) {
        self.coverView.hidden = !self.coverView.isHidden;
    //    return;
    //}

    
}

//FIXME:  -  隐藏工具菜单
- (void)hiddenControll{
    self.coverView.hidden = YES;
}

//FIXME:  -  向左
- (void)enterFullscreenLeft {
    

    
    if (self.state == AAPlayerStateLeft) {
        return;
    }



    self.state = AAPlayerStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    if(CGRectEqualToRect(CGRectZero, self.playViewSmallFrame)) {
        self.playViewSmallFrame = self.frame;
        self.playViewParentView = self.superview;
    }
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self removeFromSuperview];
    self.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    /*
     * 执行动画
     */
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));

        
    } completion:^(BOOL finished) {
        self.state = AAPlayerStateLeft;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
}
//FIXME:  -  向右
- (void)enterFullscreenRight {
    
    
    if (self.state == AAPlayerStateRight) {
        return;
    }
    
    self.state = AAPlayerStateRight;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    if(CGRectEqualToRect(CGRectZero, self.playViewSmallFrame)) {
        self.playViewSmallFrame = self.frame;
        self.playViewParentView = self.superview;
    }
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self removeFromSuperview];
    self.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    /*
     * 执行动画
     */
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
        
        
    } completion:^(BOOL finished) {
        self.state = AAPlayerStateRight;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

//FIXME:  -  竖屏
- (void)exitFullscreen {
    
    
    
    if (self.state == AAPlayerStateSmall) {
        return;
    }
    

    
    self.state = AAPlayerStateAnimating;
    
    CGRect frame = [self.playViewParentView convertRect:self.playViewSmallFrame toView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        /*
         * movieView回到小屏位置
         */
        [self removeFromSuperview];
        self.frame = self.playViewSmallFrame;
        [self.playViewParentView addSubview:self];
        self.state = AAPlayerStateSmall;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)setState:(AAPlayerState)state{
    _state = state;
    if(state == AAPlayerStateSmall) self.fullButton.selected = NO;
    else if (state == AAPlayerStateRight || state == AAPlayerStateLeft) self.fullButton.selected = YES;
    
    self.backButton.hidden = (BOOL)(state == AAPlayerStateSmall);
}

//FIXME:  -  屏幕旋转回调
- (void)changeRotate:(NSNotification*)noti {
    //NSLog(@"playView所在的控制器:%@;topVC:%@",[self dd_viewController],[self dd_topViewController]);
    
    //if(self.lockBtn.isSelected) return;
    if(self.state == AAPlayerStateAnimating) return;
    // 播放器所在的控制器不是最顶层的控制器就不执行
    //if([self dd_viewController] && [self dd_topViewController] && [self dd_viewController] != [self dd_topViewController]) return;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (self.state == AAPlayerStateSmall) {
        
        switch (orientation) {
            case UIDeviceOrientationLandscapeRight://home button就在左边了。
                NSLog(@"home向左");
                [self enterFullscreenLeft];
                break;
            case UIDeviceOrientationLandscapeLeft:
                NSLog(@"home向右");
                [self enterFullscreenRight];
                break;
                
            default:
                
                break;
                
        }
        
    }else  if (self.state != AAPlayerStateSmall){
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                NSLog(@"竖屏");
                [self exitFullscreen];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                NSLog(@"倒屏");
                break;
            case UIDeviceOrientationLandscapeRight://home button就在左边了。
                NSLog(@"home向左");
                [self enterFullscreenLeft];
                
                
                break;
            case UIDeviceOrientationLandscapeLeft:
                NSLog(@"home向右");
                [self enterFullscreenRight];
                
                
                break;
                
            default:
                
                break;
        }
        
    }
}

//FIXME:  -  旋转状态栏
- (void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
//    [self.topView setNeedsLayout];
//    [self.topView layoutIfNeeded];
//
//    NSLog(@"%s--%@", __func__,NSStringFromCGRect(self.topView.frame));
//    NSLog(@"%s--%@", __func__,NSStringFromCGRect(self.frame));
}

- (IBAction)fullAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if(sender.isSelected) [self enterFullscreenLeft];
    else [self exitFullscreen];
}

- (IBAction)playPauseButtonWasPressed:(UIButton *)sender {
    if (self.player.rate != 1.0) {
        // not playing foward so play
        if (CMTIME_COMPARE_INLINE(self.currentTime, ==, self.duration)) {
            // at end so got back to begining
            self.currentTime = kCMTimeZero;
        }
        [self.player play];
    } else {
        // playing so pause
        [self.player pause];
    }
}



-(IBAction)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted) return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    self.currentTime = CMTimeMakeWithSeconds(s.value, 1000);
}


- (IBAction)timeSliderDidChange:(UISlider *)sender {
    self.currentTime = CMTimeMakeWithSeconds(sender.value, 1000);
}

// MARK: - Asset Loading

- (void)asynchronouslyLoadURLAsset:(AVURLAsset *)newAsset {
    
    /*
     Using AVAsset now runs the risk of blocking the current thread
     (the main UI thread) whilst I/O happens to populate the
     properties. It's prudent to defer our work until the properties
     we need have been loaded.
     */
    [newAsset loadValuesAsynchronouslyForKeys:AAPlayer.assetKeysRequiredToPlay completionHandler:^{
        
        /*
         The asset invokes its completion handler on an arbitrary queue.
         To avoid multiple threads using our internal state at the same time
         we'll elect to use the main thread at all times, let's dispatch
         our handler to the main queue.
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (newAsset != self.asset) {
                /*
                 self.asset has already changed! No point continuing because
                 another newAsset will come along in a moment.
                 */
                return;
            }
            
            /*
             Test whether the values of each of the keys we need have been
             successfully loaded.
             */
            for (NSString *key in self.class.assetKeysRequiredToPlay) {
                NSError *error = nil;
                if ([newAsset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                    
                    NSString *message = [NSString localizedStringWithFormat:NSLocalizedString(@"error.asset_key_%@_failed.description", @"Can't use this AVAsset because one of it's keys failed to load"), key];
                    
                    [self handleErrorWithMessage:message error:error];
                    
                    return;
                }
            }
            
            // We can't play this asset.
            if (!newAsset.playable || newAsset.hasProtectedContent) {
                NSString *message = NSLocalizedString(@"error.asset_not_playable.description", @"Can't use this AVAsset because it isn't playable or has protected content");
                
                [self handleErrorWithMessage:message error:nil];
                
                return;
            }
            
            /*
             We can play this asset. Create a new AVPlayerItem and make it
             our player's current item.
             */
            self.playerItem = [AVPlayerItem playerItemWithAsset:newAsset];
            
            //[self.player play];
        });
    }];
}

// Update our UI when player or player.currentItem changes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context != &AAPLPlayerViewControllerKVOContext) {
        // KVO isn't for us.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"asset"]) {
        if (self.asset) {
            [self asynchronouslyLoadURLAsset:self.asset];
        }
    }
    else if ([keyPath isEqualToString:@"player.currentItem.duration"]) {
        
        // Update timeSlider and enable/disable controls when duration > 0.0
        
        // Handle NSNull value for NSKeyValueChangeNewKey, i.e. when player.currentItem is nil
        NSValue *newDurationAsValue = change[NSKeyValueChangeNewKey];
        CMTime newDuration = [newDurationAsValue isKindOfClass:[NSValue class]] ? newDurationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;
        
        self.timeSlider.maximumValue = newDurationSeconds;
        self.timeSlider.value = hasValidDuration ? CMTimeGetSeconds(self.currentTime) : 0.0;
       
        self.playPauseButton.enabled = hasValidDuration;
        self.timeSlider.enabled = hasValidDuration;
        self.startTimeLabel.enabled = hasValidDuration;
        self.durationLabel.enabled = hasValidDuration;
        int wholeMinutes = (int)trunc(newDurationSeconds / 60);
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];
        
        [self.player play];
        
    }
    else if ([keyPath isEqualToString:@"player.rate"]) {
        // Update playPauseButton image
        
        double newRate = [change[NSKeyValueChangeNewKey] doubleValue];
        UIImage *buttonImage = (newRate == 1.0) ? [UIImage imageNamed:@"PauseButton"] : [UIImage imageNamed:@"PlayButton"];
        [self.playPauseButton setImage:buttonImage forState:UIControlStateNormal];
        
    }
    else if ([keyPath isEqualToString:@"player.currentItem.status"]) {
        // Display an error if status becomes Failed
        
        // Handle NSNull value for NSKeyValueChangeNewKey, i.e. when player.currentItem is nil
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed) {
            [self handleErrorWithMessage:self.player.currentItem.error.localizedDescription error:self.player.currentItem.error];
        }else if(newStatus == AVPlayerStatusReadyToPlay){
            
        }
        
    }else if ([keyPath isEqualToString:@"player.currentItem.loadedTimeRanges"]) {  //监听播放器的下载进度
        
        NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        //NSLog(@"下载进度：%.2f", timeInterval / totalDuration);
        self.loadBufView.progress = timeInterval / totalDuration;
        NSLog(@"下载进度：%.2f", timeInterval);
        
        
        
        int progress = (timeInterval - CMTimeGetSeconds(self.playerItem.currentTime)) * 1000.0 / 60.0;
        if (progress < 100 && (progress > 0)) {
            NSLog(@"加载进度：%d%%", progress);
            self.bufProgress.text = [NSString stringWithFormat:@"(%d%%)",progress];
            
        }
        
    } else if ([keyPath isEqualToString:@"player.currentItem.playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        
        NSLog(@"缓冲不足暂停了");
        [self.loadingView startAnimating];
        self.bufProgress.hidden = NO;
        
        
    } else if ([keyPath isEqualToString:@"player.currentItem.playbackLikelyToKeepUp"]) {
        
        NSLog(@"缓冲达到可播放程度了");
        [self.loadingView stopAnimating];
        self.bufProgress.hidden = YES;
        
        //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        [self.player play];
        
        
        NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        
        NSLog(@"%s---%f", __func__,timeInterval - CMTimeGetSeconds(self.playerItem.currentTime));
        
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)addObserver{
    [self addObserver:self forKeyPath:@"asset" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    
    
    [self addObserver:self forKeyPath:@"player.currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.playbackBufferEmpty" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (AVPlayer *)player {
    if (!_player)
        _player = [[AVPlayer alloc] init];
    return _player;
}
- (CMTime)currentTime {
    return self.player.currentTime;
}
- (void)setCurrentTime:(CMTime)newCurrentTime {
    [self.player seekToTime:newCurrentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (CMTime)duration {
    return self.player.currentItem ? self.player.currentItem.duration : kCMTimeZero;
}

- (void)setPlayerItem:(AVPlayerItem *)newPlayerItem {
    if (_playerItem != newPlayerItem) {
        
        _playerItem = newPlayerItem;
        
        // If needed, configure player item here before associating it with a player
        // (example: adding outputs, setting text style rules, selecting media options)
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    }
}

- (float)rate {
    return self.player.rate;
}
- (void)setRate:(float)newRate {
    self.player.rate = newRate;
}

// Will attempt load and test these asset keys before playing
+ (NSArray *)assetKeysRequiredToPlay {
    return @[ @"playable", @"hasProtectedContent" ];
}

// Trigger KVO for anyone observing our properties affected by player and player.currentItem
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"duration"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.duration" ]];
    } else if ([key isEqualToString:@"currentTime"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.currentTime" ]];
    } else if ([key isEqualToString:@"rate"]) {
        return [NSSet setWithArray:@[ @"player.rate" ]];
    } else {
        return [super keyPathsForValuesAffectingValueForKey:key];
    }
}

// MARK: - Error Handling

- (void)handleErrorWithMessage:(NSString *)message error:(NSError *)error {
    NSLog(@"Error occured with message: %@, error: %@.", message, error);
    
    NSString *alertTitle = NSLocalizedString(@"alert.error.title", @"Alert title for errors");
    NSString *defaultAlertMesssage = NSLocalizedString(@"error.default.description", @"Default error message when no NSError provided");
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:alertTitle message:message ?: defaultAlertMesssage preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *alertActionTitle = NSLocalizedString(@"alert.error.actions.OK", @"OK on error alert");
    UIAlertAction *action = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
//    [self presentViewController:controller animated:YES completion:nil];
}


@end


@implementation UITabBarController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden{
    return self.selectedViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.selectedViewController.prefersHomeIndicatorAutoHidden;
}
@end
@implementation UINavigationController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden{
    return self.topViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.topViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.topViewController.prefersHomeIndicatorAutoHidden;
}
@end
static char kSPStatusBarStyleKey;
static char kSPStatusBarHiddenKey;
static char kSPHomeIndicatorAutoHiddenKey;
@implementation UIViewController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    
    NSString *className = NSStringFromClass([self class]);
    NSArray * fullScreenViewControllers = @[
                                            @"UIViewController",
//                                            NSStringFromClass([DDWVCDD class]),
                                            @"AVPlayerViewController",
                                            @"AVFullScreenViewController",
                                            @"AVFullScreenPlaybackControlsViewController"
                                            ];
    if ([fullScreenViewControllers containsObject:className]){
        return YES;
    }
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    NSString *className = NSStringFromClass([self class]);
    NSArray * fullScreenViewControllers = @[
                                            @"UIViewController",
//                                            NSStringFromClass([DDWVCDD class]),
                                            @"AVPlayerViewController",
                                            @"AVFullScreenViewController",
                                            @"AVFullScreenPlaybackControlsViewController"
                                            ];
    if ([fullScreenViewControllers containsObject:className]){
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return self.ddStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.ddStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.ddHomeIndicatorAutoHidden;
}
// statusBarStyle
- (UIStatusBarStyle)ddStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kSPStatusBarStyleKey);
    return (UIStatusBarStyle)(style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}
- (void)setDdStatusBarStyle:(UIStatusBarStyle)spStatusBarStyle{
    objc_setAssociatedObject(self, &kSPStatusBarStyleKey, @(spStatusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

//StatusBarHidden
- (BOOL)ddStatusBarHidden {
    id isHidden = objc_getAssociatedObject(self, &kSPStatusBarHiddenKey);
    return (isHidden != nil) ? [isHidden boolValue] : NO;
}
- (void)setDdStatusBarHidden:(BOOL)spStatusBarHidden{
    objc_setAssociatedObject(self, &kSPStatusBarHiddenKey, @(spStatusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}
//HomeIndicatorAutoHidden
- (BOOL)ddHomeIndicatorAutoHidden {
    id isHidden = objc_getAssociatedObject(self, &kSPHomeIndicatorAutoHiddenKey);
    return (isHidden != nil) ? [isHidden boolValue] : NO;
}
- (void)setDdHomeIndicatorAutoHidden:(BOOL)spHomeIndicatorAutoHidden{
    objc_setAssociatedObject(self, &kSPHomeIndicatorAutoHiddenKey, @(spHomeIndicatorAutoHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}
@end


@implementation UIView (Player)
//FIXME:  -  View获取所在的Controller
- (UIViewController *)dd_viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (UIViewController *)dd_topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
        
    }
    return resultVC;
}
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end




