//
//  ViewController.m
//  震动
//
//  Created by Jay on 3/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "YTStatusBarHUD.h"
#import "AATouch.h"

#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
/** <##> */
@property (nonatomic, strong) AATouch *AA;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    UIImageView *red = [UIImageView new];
//    red.frame = CGRectMake(200,200,64,64);
//    red.backgroundColor = [UIColor redColor];
//
//    red.image = [UIImage imageNamed:@"1"];
//    //red.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"1024"].CGImage);
//
//    [self.view addSubview:red];
//
    
    self.AA = [AATouch new];
//    [self.AA test:red title:@[@"333",@"444"] icon:@[@"333",@"444"]];
    
    
    UIView *red2 = [UIView new];
    red2.frame = CGRectMake(250,250,64,64);
    red2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:red2];
    red2.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"1"].CGImage);
    red2.layer.cornerRadius  = 10;
    red2.layer.masksToBounds = YES;

    
    
    [self.AA popTouchView:red2 title:@[@"333",@"444",@"333"] icon:@[@"分组_3 copy 2",@"分组_3 copy 3",@"分组_4 copy 2"] actionBlock:^(NSInteger buttonIndex) {
        NSLog(@"%s---%ld", __func__,(long)buttonIndex);
    }];
    
}

- (void)longAction:(UILongPressGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:0.5 animations:^{
                sender.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];//重度
                [generator prepare];
                [generator impactOccurred];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = [UIScreen mainScreen].bounds;
                [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
                
                UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,btn.bounds.size.width,btn.bounds.size.height)];
                toolbar.barStyle   = UIBarStyleBlack;
                toolbar.alpha = 0.0;
                toolbar.userInteractionEnabled = NO;

                [btn addSubview:toolbar];
                [[UIApplication sharedApplication].keyWindow addSubview:btn];

                CGRect rectInWindow = [sender.view convertRect:sender.view.bounds toView:btn];
                [sender.view removeFromSuperview];
                sender.view.frame = rectInWindow;
                [btn addSubview:sender.view];
                
                [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
                    sender.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    sender.view.userInteractionEnabled = NO;
                    toolbar.alpha = 0.9;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"%s", __func__);
            break;

        default:
            break;
    }
}

- (void)close:(UIButton *)sender{
    
    CGRect rectInWindow = [sender.subviews.lastObject convertRect:sender.subviews.lastObject.bounds toView:self.view];
    UIView *red = sender.subviews.lastObject;
    [red removeFromSuperview];
    red.frame = rectInWindow;
    [self.view addSubview:red];
    
    [UIView animateWithDuration:0.25 animations:^{
        sender.subviews.firstObject.alpha = 0.0;
        red.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        red.userInteractionEnabled = YES;
        [sender removeFromSuperview];
    }];
}

- (IBAction)clickInfo:(UIButton *)sender {
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    //  UINotificationFeedbackTypeSuccess,
    //  UINotificationFeedbackTypeWarning,
    //  UINotificationFeedbackTypeError
    
    switch (sender.tag) {
        case 101:{
            [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
            [YTStatusBarHUD showSuccessImageName:nil text:nil];
        }
            break;
        case 102:{
            [generator notificationOccurred:UINotificationFeedbackTypeError];
            [YTStatusBarHUD showErrorImageName:nil text:nil];
        }
            break;
        case 103:{
            [generator notificationOccurred:UINotificationFeedbackTypeWarning];
            [YTStatusBarHUD showWarningImageName:nil text:nil];
        }
            break;
        case 104:{
            [YTStatusBarHUD showLoading:nil];
        }
            break;
        case 105:{
            [YTStatusBarHUD hide];
        }
            break;
            
        default:
            break;
    }
    
    [generator prepare];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //长震
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //return;
    // 普通短震，3D Touch 中 Peek 震动反馈
    //AudioServicesPlaySystemSound(1519);
    
    // 普通短震，3D Touch 中 Pop 震动反馈
    //AudioServicesPlaySystemSound(1520);
    //return;
    // 连续三次短震
    //AudioServicesPlaySystemSound(1521);
    
//    UIFeedbackGenerator 可以帮助你实现 haptic feedback。它的要求是：
//    支持 Taptic Engine 机型 (iPhone 7 以及 iPhone 7 Plus).
//    app 需要在前台运行
//    系统 Haptics setting 需要开启
//    
//    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];//重度
//    [generator prepare];
//    [generator impactOccurred];
//    return;
    UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
    [generator prepare];
    [generator selectionChanged];
    
//    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    //  UINotificationFeedbackTypeSuccess,
    //  UINotificationFeedbackTypeWarning,
    //  UINotificationFeedbackTypeError

//    [generator notificationOccurred:UINotificationFeedbackTypeError];
//    [generator prepare];
}

@end
