//
//  WJStatusBarHUD.m
//  WJStatusBarHUD
//
//  Created by wj on 16/2/26.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "WJStatusBarHUD.h"

@interface ZZRHapticFeedbackManager : NSObject

#pragma mark -
#pragma mark - UINotificationFeedbackGenerator

+ (void)executeSuccessFeedback;
+ (void)executeWarningFeedback;
+ (void)excuteErrorFeedback;

#pragma mark -
#pragma mark - UIImpactFeedbackGenerator

+ (void)excuteLightFeedback;
+ (void)excuteMediumFeedback;
+ (void)excuteHeavyFeedback;

#pragma mark -
#pragma mark - UISelectionFeedbackGenerator

+ (void)excuteSelectionFeedback;

@end


@implementation WJStatusBarHUD

static UIWindow *window_;
static NSTimer *timer_;

/** HUD控件的高度 */

#define WJWindowH (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

/** HUD控件的动画持续时间 */
static CGFloat const WJAnimationDuration = 0.25;

/** HUD控件默认会停留多长时间 */
static CGFloat const WJHUDStayDuration = 2.0;

+ (void)showImage:(UIImage *)image text:(NSString *)text{
    
    // 停止定时器
    [timer_ invalidate];
    timer_ = nil;
    
    // 创建窗口
    window_.hidden = YES;
    window_ = [[UIWindow alloc]init];
    window_.backgroundColor = [UIColor blackColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.frame = CGRectMake(0, -WJWindowH, [UIScreen mainScreen].bounds.size.width, WJWindowH);
    window_.hidden = NO;
    
    // 创建按钮
    UIButton *button = [self createButtonWithText:text];
    
    // 图片
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    [window_ addSubview:button];
    
    // 动画
    [UIView animateWithDuration:WJAnimationDuration animations:^{
        CGRect frame = window_.frame;
        frame.origin.y = 0;
        window_.frame = frame;
    }];
    
    // 启动定时器
    timer_ = [NSTimer scheduledTimerWithTimeInterval:WJHUDStayDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];
    
}

+ (void)showImageName:(NSString *)imageName text:(NSString *)text{
    
    [self showImage:[UIImage imageNamed:imageName] text:text];
}

+ (void)showSuccessImageName:(NSString *)imageName text:(NSString *)text{
    [ZZRHapticFeedbackManager executeSuccessFeedback];
    [self showImage:[UIImage imageNamed:[self cheakSuccessImageName:imageName]] text:[self cheakSuccessText:text]];

}

+ (void)showErrorImageName:(NSString *)imageName text:(NSString *)text{
    [ZZRHapticFeedbackManager excuteErrorFeedback];
    [self showImage:[UIImage imageNamed:[self cheakErrorImageName:imageName]] text:[self cheakErrorText:text]];
}

+ (void)showWarningImageName:(NSString *)imageName text:(NSString *)text{
    [ZZRHapticFeedbackManager executeWarningFeedback];
    [self showImage:[UIImage imageNamed:[self cheakWarningImageName:imageName]] text:[self cheakWarningText:text]];
}

+ (void)showLoading:(NSString *)text{
    
    
    // 检查text
    if (text.length < 1 || text == nil || text == NULL) {
        text = @"loading";
    }
    
    // 停止定时器
    [timer_ invalidate];
    timer_ = nil;
    
    window_.hidden = YES;
    window_ = [[UIWindow alloc]init];
    window_.backgroundColor = [UIColor blackColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.frame = CGRectMake(0, -WJWindowH, [UIScreen mainScreen].bounds.size.width, WJWindowH);
    window_.hidden = NO;
    

    UIButton *button = [self createButtonWithText:text];


    
    [window_ addSubview:button];
    button.userInteractionEnabled = NO;
    
    // 菊花
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(button.titleLabel.frame.origin.x-20, button.center.y);
    [window_ addSubview:loadingView];
    
    // 动画
    [UIView animateWithDuration:WJAnimationDuration animations:^{
        CGRect frame = window_.frame;
        frame.origin.y = 0;
        window_.frame = frame;
    }];
    
}

+ (NSString *)cheakSuccessText:(NSString *)text{
    
    if (text.length < 1 || text == nil || text == NULL) {
        text = @"加载数据成功";
    }
    return text;
    
}

+ (NSString *)cheakSuccessImageName:(NSString *)imageName{
    
    if (imageName.length < 1 || imageName == nil || imageName == NULL) {
        imageName = @"WJStatusBarHUD_success";
    }
    return imageName;
}


+ (NSString *)cheakErrorText:(NSString *)text{
    
    if (text.length < 1 || text == nil || text == NULL) {
        text = @"加载数据失败";
    }
    return text;
    
}

+ (NSString *)cheakErrorImageName:(NSString *)imageName{
    
    if (imageName.length < 1 || imageName == nil || imageName == NULL) {
        imageName = @"WJStatusBarHUD_error";
    }
    return imageName;
}

+ (NSString *)cheakWarningImageName:(NSString *)imageName{
    
    if (imageName.length < 1 || imageName == nil || imageName == NULL) {
        imageName = @"WJStatusBarHUD_warning";
    }
    return imageName;
}

+ (NSString *)cheakWarningText:(NSString *)text{
    
    if (text.length < 1 || text == nil || text == NULL) {
        text = @"警告";
    }
    return text;
}

+ (UIButton *)createButtonWithText:(NSString *)text{
    
    // 添加按钮
    UIButton *button = [[UIButton alloc] init];
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    button.frame = CGRectMake(0, statusBarHeight, window_.bounds.size.width, window_.bounds.size.height-statusBarHeight);

    // 文字
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.imageView.backgroundColor = [UIColor clearColor];
    [window_ addSubview:button];
    button.userInteractionEnabled = NO;
    return button;
}

+ (void)hide{
    [timer_ invalidate];
    timer_ = nil;
    [UIView animateWithDuration:WJAnimationDuration animations:^{
        CGRect frame = window_.frame;
        frame.origin.y = - WJWindowH;
        window_.frame = frame;
    }completion:^(BOOL finished) {
        window_ = nil;
    }];
}

@end


@implementation ZZRHapticFeedbackManager

#pragma mark -
#pragma mark - UINotificationFeedbackGenerator

+ (void)executeSuccessFeedback
{
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
}

+ (void)executeWarningFeedback
{
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:UINotificationFeedbackTypeWarning];
}

+ (void)excuteErrorFeedback
{
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:UINotificationFeedbackTypeError];
}

#pragma mark -
#pragma mark - UIImpactFeedbackGenerator

+ (void)excuteLightFeedback
{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
}

+ (void)excuteMediumFeedback
{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
}

+ (void)excuteHeavyFeedback
{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleHeavy];
    [generator prepare];
    [generator impactOccurred];
}


#pragma mark -
#pragma mark - UISelectionFeedbackGenerator


+ (void)excuteSelectionFeedback
{
    UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
    [generator selectionChanged];
}



@end
