//
//  AAPlayer.m
//  player
//
//  Created by xin on 2019/6/23.
//  Copyright © 2019年 Adc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AAPlayer.h"
#import "AASegmentSlider.h"
#import "AATSDownloader.h"


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


typedef NS_ENUM(NSInteger, AAMoveDirection){
    AAMoveDirectionHorizontal, // 横向移动
    AAMoveDirectionVertical    // 纵向移动
};


// Private properties
@interface AAPlayer ()

@property (strong, nonatomic) AVPlayerItem *playerItem;
//@property (weak, nonatomic) AAPLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet AAPLPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIView *coverView;


@property (weak) IBOutlet AASegmentSlider *timeSlider;
@property (weak) IBOutlet UILabel *startTimeLabel;
@property (weak) IBOutlet UILabel *durationLabel;
@property (weak) IBOutlet UIButton *fullButton;
@property (weak) IBOutlet UIButton *playPauseButton;
@property (weak) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *bufProgress;


@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVURLAsset *asset;

@property (strong, nonatomic) id<NSObject> timeObserverToken;

@property (assign, nonatomic) float rate;
@property (assign, nonatomic) CMTime currentTime;

@property (assign, nonatomic,readonly) CMTime duration;


@property (nonatomic, assign) AAPlayerState state;

@property (nonatomic, assign)   AAMoveDirection  panDirection;


@property (nonatomic, assign) CGRect playViewSmallFrame;

@property (nonatomic, weak) UIView *playViewParentView;

@property (nonatomic, assign) BOOL progressDragging;

@property (weak, nonatomic) IBOutlet AAFastView *fastView;

@property (nonatomic, assign) CGFloat sumTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnH;

@property (nonatomic, assign)   BOOL  isVolume;

@property (weak, nonatomic) IBOutlet AAbrightnessView *brightnessView;

//@property (nonatomic, strong)   MPVolumeView *volumeView;
@property (nonatomic, strong)   UISlider *volumeViewSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn;

@property (nonatomic, copy) NSString *url;

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
    //[self.timeSlider setThumbImage:[UIImage imageNamed:@"Line"] forState:UIControlStateNormal];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"pb-seek-bar-btn"] forState:UIControlStateNormal];
    [self.timeSlider setMinimumTrackImage:[UIImage imageNamed:@"pb-seek-bar-fr"] forState:UIControlStateNormal];
    [self.timeSlider setMaximumTrackImage:[UIImage imageNamed:@"pb-seek-bar-bg"] forState:UIControlStateNormal];
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
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
    [self addGestureRecognizer:pan];
    
//    self.backBtnH.constant = ([UIApplication sharedApplication].statusBarFrame.size.height > 20)? 75 : 44;


    self.playerView.playerLayer.player = self.player;
    
    //NSURL *movieURL = [NSURL URLWithString:@"http://yun.kubozy-youku-163.com/20190517/13269_6b28fe19/index.m3u8"];
    //self.asset = [AVURLAsset assetWithURL:movieURL];
    
    // Use a weak self variable to avoid a retain cycle in the block.
    __weak typeof(self) weakSelf = self;
    _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:
                          ^(CMTime time) {
                              if(weakSelf.progressDragging) return ;
                              double newDurationSeconds = CMTimeGetSeconds(time);
                              int wholeMinutes = (int)trunc(newDurationSeconds / 60);
                              
                              weakSelf.timeSlider.value = CMTimeGetSeconds(time);
                              weakSelf.startTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];
                              
                              [[NSUserDefaults standardUserDefaults] setObject:@(newDurationSeconds) forKey:weakSelf.asset.URL.absoluteString];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                          }];
    


}

//FIXME:  -  手势处理事件
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    
    if(self.state == AAPlayerStateSmall) return;
    //if(self.lockBtn.isSelected) return;
    
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = AAMoveDirectionHorizontal;
                // 给sumTime初值 (点播)
                //if(!self.videoButtomView.isHidden)
                self.sumTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
            }
            else if (x < y){ // 垂直移动
                self.panDirection = AAMoveDirectionVertical;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width * 0.4) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case AAMoveDirectionHorizontal:{
                    //if(!self.videoButtomView.isHidden)
                        [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    NSLog(@"%s--水平移动的方法只要x方向", __func__);
                    break;
                }
                case AAMoveDirectionVertical:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    NSLog(@"%s-垂直移动方法只要y方向的值", __func__);
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case AAMoveDirectionHorizontal:{
                    
//                    if(!self.videoButtomView.isHidden){
                        [self.player seekToTime:CMTimeMake(self.sumTime, 1)];
                        // 把sumTime滞空，不然会越加越多
                        self.sumTime = 0;
                        [UIView animateWithDuration:0.50 animations:^{
                            self.fastView.alpha = 0.0;
                        }];
//                    }
                    break;
                }
                case AAMoveDirectionVertical:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


//- (MPVolumeView *)volumeView {
//    if (_volumeView == nil) {
//        _volumeView  = [[MPVolumeView alloc] init];
//
//        [_volumeView sizeToFit];
//        for (UIView *view in [_volumeView subviews]){
//            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
//                self.volumeViewSlider = (UISlider*)view;
//                break;
//            }
//        }
//    }
//    return _volumeView;
//}

- (UISlider *)volumeViewSlider{
    if(!_volumeViewSlider){
        
        MPVolumeView *volumeView  = [[MPVolumeView alloc] init];
        [volumeView sizeToFit];
        
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeViewSlider;
}


//FIXME:  -  处理音量和亮度
- (void)verticalMoved:(CGFloat)value {
    if (self.isVolume) {
        self.volumeViewSlider.value -= value / 10000;
        return;
    }
    [UIScreen mainScreen].brightness -= value / 10000;
    self.brightnessView.brightness = [UIScreen mainScreen].brightness;
}

//FIXME:  -  快进和后退
- (void)horizontalMoved:(CGFloat)value {
    
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    // 需要限定sumTime的范围
    NSTimeInterval totalMovieDuration = CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    if (value == 0) { return; }
    
    self.fastView.alpha = 1.0;
    
    
    NSTimeInterval total = totalMovieDuration;
    NSTimeInterval current = self.sumTime;
    
    
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60,(NSInteger)total/60,(NSInteger)total%60];
    NSString *currentTimeString = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60];
    
    
    
    NSMutableAttributedString *timeAttString = [[NSMutableAttributedString alloc] initWithString:timeString];
    
    [timeAttString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, currentTimeString.length)];
    self.fastView.fastTitleLB.attributedText = timeAttString;
    if (value > 0) { // 快进
        self.fastView.fastIconImageView.image = [UIImage imageNamed:@"dd_progress_r_dd"];
    } else { // 快退
        self.fastView.fastIconImageView.image = [UIImage imageNamed:@"dd_progress_l_dd"];
    }
    
    self.fastView.fastProgressView.progress = current/total;
}

- (void)playWithURL:(NSString *)url backTitle:(NSString *)title{
    [self.backButton setTitle:[NSString stringWithFormat:@"  %@",title] forState:UIControlStateNormal];
    [self play:url];
}

- (void)play:(NSString *)url{
    
    self.url = url;
    NSURL *movieURL = [NSURL URLWithString:[AATSDownloader getCacheUrl:url]];
    self.asset = [AVURLAsset assetWithURL:movieURL];
    
    [self.loadingView startAnimating];
    self.bufProgress.hidden = self.loadingView.isHidden;
    [self.bufProgress setTitle:@"loading..." forState:UIControlStateNormal];
    self.topViewController.ddHomeIndicatorAutoHidden = YES;
}


//FIXME:  -  视频触摸的回调
- (void)handleTapGesture{
    

    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControll) object:nil];
    if (self.coverView.isHidden) {//不隐藏的时候
        [self performSelector:@selector(hiddenControll) withObject:nil afterDelay:5.0];
    }
    
    if(self.lockBtn.isSelected) {
        self.lockBtn.alpha = !self.lockBtn.alpha;
        return;
    }
    
    self.coverView.hidden = !self.coverView.isHidden;
 
    if(self.state != AAPlayerStateSmall) {
        [self hiddenSatusBar:self.coverView.isHidden];
        self.lockBtn.alpha = !self.coverView.isHidden;
    }
    else{
        self.lockBtn.alpha = !YES;
    }

}

//FIXME:  -  隐藏工具菜单
- (void)hiddenControll{
    self.coverView.hidden = YES;
    self.lockBtn.alpha = !self.coverView.isHidden;
    if(self.state != AAPlayerStateSmall) [self hiddenSatusBar:self.coverView.isHidden];
}

- (void)hiddenSatusBar:(BOOL)hidden{
    
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    if( self.state != AAPlayerStateSmall && !statusBarH ) {
        [self.window setWindowLevel:UIWindowLevelAlert];
        return;
    }

    
    if(hidden) [self.window setWindowLevel:UIWindowLevelAlert];
    else [self.window setWindowLevel:UIWindowLevelNormal];
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
        [self layoutIfNeeded];

        
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
        [self layoutIfNeeded];

        
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
        [self layoutIfNeeded];

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
    
    [self hiddenSatusBar:self.coverView.isHidden];// 
    
    if(state == AAPlayerStateSmall){//最小屏的时候，不隐藏状态栏，
        [self hiddenSatusBar:NO];
        self.fullButton.selected = NO;
        self.topViewController.ddStatusBarStyle = UIStatusBarStyleDefault;
    }
    else if (state == AAPlayerStateRight || state == AAPlayerStateLeft) {
       
        if( ![UIApplication sharedApplication].statusBarFrame.size.height ) {//iphone x 隐藏 状态栏
            //[self.window setWindowLevel:UIWindowLevelAlert];
            [self hiddenSatusBar:YES];
        }
        self.fullButton.selected = YES;
        self.topViewController.ddStatusBarStyle = UIStatusBarStyleLightContent;
    }
    
    self.backButton.superview.hidden = (BOOL)(state == AAPlayerStateSmall);
    self.modeBtn.hidden = self.backButton.superview.isHidden;
    self.lockBtn.alpha = !self.backButton.superview.isHidden && !self.coverView.isHidden;
    
    
    
}

//FIXME:  -  屏幕旋转回调
- (void)changeRotate:(NSNotification*)noti {
    NSLog(@"playView所在的控制器:%@;topVC:%@",[self viewController],[self topViewController]);
    
    if(self.lockBtn.isSelected) return;
    if(self.state == AAPlayerStateAnimating) return;
    // 播放器所在的控制器不是最顶层的控制器就不执行
    if([self viewController] && [self topViewController] && [self viewController] != [self topViewController]) return;
    
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

- (IBAction)backAction:(UIButton *)sender {
    [self exitFullscreen];
}

- (IBAction)replayAction:(UIButton *)sender {
    
    [self play:self.url];
}


- (IBAction)lockAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    self.coverView.hidden = sender.selected;
    [self hiddenSatusBar:self.coverView.isHidden];
    
//    self.topView.hidden = !self.buttomView.isHidden;
//    self.buttomView.hidden = !self.buttomView.isHidden;
//    self.sBH = self.buttomView.isHidden;
//    self.modeButton.hidden = self.buttomView.isHidden;
    
}
- (IBAction)modeAction:(UIButton *)sender {
    NSArray <AVLayerVideoGravity>*modes = @[
                                            AVLayerVideoGravityResizeAspect,
                                            AVLayerVideoGravityResizeAspectFill,
                                            AVLayerVideoGravityResize
                                            ];
    static int curModeIdx = 0;
    
    curModeIdx = (curModeIdx + 1) % (int)(modes.count);
    
    //     AVLayerVideoGravityResizeAspect 按比例压缩，视频不会超出Layer的范围（默认）
    //     AVLayerVideoGravityResizeAspectFill 按比例填充Layer，不会有黑边
    //     AVLayerVideoGravityResize 填充整个Layer，视频会变形
    //     视频内容拉伸的选项
    self.playerView.playerLayer.videoGravity = modes[curModeIdx];

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

// 滑块滑动开始
- (IBAction)sliderTouchBegan:(UISlider *)sender{
    self.progressDragging = YES;
}
// 滑块滑动结束
- (IBAction)sliderTouchEnded:(UISlider *)sender{
    self.progressDragging = NO;
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
            
            CGFloat playDurationSeconds = [[[NSUserDefaults standardUserDefaults] objectForKey:self.asset.URL.absoluteString] floatValue];
            if (playDurationSeconds) {
                [self.bufProgress setTitle:@"正在还原上次播放..." forState:UIControlStateNormal];
                self.currentTime = CMTimeMakeWithSeconds(playDurationSeconds, 1000);
            }else{
                [self.bufProgress setTitle:@"preparing..." forState:UIControlStateNormal];
            }

            
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
       
        self.fastView.hidden = !hasValidDuration;
        self.playPauseButton.enabled = hasValidDuration;
        self.timeSlider.enabled = hasValidDuration;
        self.startTimeLabel.enabled = hasValidDuration;
        self.durationLabel.enabled = hasValidDuration;
        self.fullButton.enabled = hasValidDuration;

        int wholeMinutes = (int)trunc(newDurationSeconds / 60);
        self.durationLabel.text = hasValidDuration? [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60] : @"-:--";
        
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
        
        self.timeSlider.segment = timeInterval / totalDuration;//self.loadBufView.progress;
        NSLog(@"缓冲进度：%.2f", timeInterval);
        
        
        if( timeInterval > (CMTimeGetSeconds(self.currentTime)+3) &&  self.player.rate == 1.0 && self.loadingView.isAnimating){
            [self.player play];
        }

        
        
        int progress = (timeInterval - CMTimeGetSeconds(self.playerItem.currentTime)) * 1000.0 / 60.0;
        if (progress < 100 && (progress > 0)) {
            NSLog(@"加载进度：%d%%", progress);
            [self.bufProgress setTitle:[NSString stringWithFormat:@"(%d%%)",progress] forState:UIControlStateNormal];
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
    
    [self.loadingView stopAnimating];
    self.bufProgress.hidden = NO;
    self.bufProgress.enabled = YES;
    [self.bufProgress setTitle:error.localizedDescription forState:UIControlStateNormal];

    UIViewController *vc = self.viewController?self.viewController:self.topViewController;
    UINavigationController *nav = vc.navigationController;
    AAWebController *web = [[AAWebController alloc] init];
    web.url = self.url;
    web.navigationItem.title = self.backButton.currentTitle;

    if (nav) {
        [nav pushViewController:web animated:NO];
        return;
    }
    [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:web] animated:YES completion:nil];

    
    return;
    
//    NSString *alertTitle = NSLocalizedString(@"alert.error.title", @"Alert title for errors");
//    NSString *defaultAlertMesssage = NSLocalizedString(@"error.default.description", @"Default error message when no NSError provided");
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:alertTitle message:message ?: defaultAlertMesssage preferredStyle:UIAlertControllerStyleAlert];
//
//    NSString *alertActionTitle = NSLocalizedString(@"alert.error.actions.OK", @"OK on error alert");
//    UIAlertAction *action = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
//    [controller addAction:action];
//
//    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
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
                                            NSStringFromClass([AAWebController class]),
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
                                            NSStringFromClass([AAWebController class]),
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
- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (UIViewController *)topViewController {
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




