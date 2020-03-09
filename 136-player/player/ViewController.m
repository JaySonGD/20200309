//
//  ViewController.m
//  player
//
//  Created by xin on 2019/6/23.
//  Copyright © 2019年 Adc. All rights reserved.
//

#import "ViewController.h"

#import "AAPlayer.h"
#import "FFTSDownloader.h"

#import "VSegmentSlider.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet VSegmentSlider *s;
@property (weak, nonatomic) IBOutlet UIProgressView *p;
@property (nonatomic, weak)  AAPlayer *av;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AAPlayer *av = [AAPlayer player];
    av.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    [self.view addSubview:av];

    NSString *url = [FFTSDownloader getCacheUrl:@"http://yun.kubozy-youku-163.com/20190717/17344_9b0bcf3b/index.m3u8"];

    [av play:url];
    _av = av;
////    return;
//    [[NSNotificationCenter defaultCenter] addObserverForName:kDownloadProgressNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        NSLog(@"%s--%@", __func__,note.userInfo);
//    }];
    
    NSLog(@"%s---%@", __func__,NSHomeDirectory());
    
    [[FFTSDownloader sharedManager] dowloadWithUrl:@"http://yun.kubozy-youku-163.com/20190717/17344_9b0bcf3b/index.m3u8" fileName:@"555" processBlock:^(float p, float pf) {
        
    } completionBlock:^(NSError *error) {
        
    }];
    
    self.s.segments = @[@0.2,@0.4,@0.6,@0.65];
    [self.s setThumbImage:[UIImage imageNamed:@"pb-seek-bar-btn"] forState:UIControlStateNormal];
    [self.s setMinimumTrackImage:[UIImage imageNamed:@"pb-seek-bar-fr"] forState:UIControlStateNormal];
    [self.s setMaximumTrackImage:[UIImage imageNamed:@"pb-seek-bar-bg"] forState:UIControlStateNormal];
}


- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
    
}




//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    //[_av play:@"https://v7.438vip.com/2019/07/07/ZOwRZj7K03N2T97x/playlist.m3u8"];
//
////    NSError *error;
////    [[NSString stringWithFormat:@"%d",rand()] writeToFile:@"/Users/jay/Desktop/ly.m3u8" atomically:YES encoding:NSUTF8StringEncoding error:&error];
////    NSLog(@"%s----%@", __func__,error);
//
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//    {
//        NSNumber *num = [[NSNumber alloc] initWithInt:UIInterfaceOrientationLandscapeLeft];
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
//    }
//    SEL selector=NSSelectorFromString(@"setOrientation:");
//    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//    [invocation setSelector:selector];
//    [invocation setTarget:[UIDevice currentDevice]];
//    int val = UIInterfaceOrientationLandscapeLeft;
//    [invocation setArgument:&val atIndex:2];
//    [invocation invoke];
//
//
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
