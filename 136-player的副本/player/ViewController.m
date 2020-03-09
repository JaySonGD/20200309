//
//  ViewController.m
//  player
//
//  Created by xin on 2019/6/23.
//  Copyright © 2019年 Adc. All rights reserved.
//

#import "ViewController.h"

#import "AAPlayer.h"
#import "AATSDownloader.h"

#import "AASegmentSlider.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AASegmentSlider *s;
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
    
    
    [av playWithURL:@"http://zy.kubozy-youku-163-aiqi.com/20190406/4978_a7388ea7/index.m3u8" backTitle:@"一千个夜晚"];
    _av = av;
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kDownloadProgressNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        NSLog(@"%s--%@", __func__,note.userInfo);
//    }];
    
    [[AATSDownloader sharedManager] dowloadWithUrl:@"http://zy.kubozy-youku-163-aiqi.com/20190406/4978_a7388ea7/index.m3u8" fileName:@"555" processBlock:^(float p, float pf) {
        
    } completionBlock:^(NSError *error) {
        
    }];
    
//    self.s.segment = 0.6;//@[@0.2,@0.4,@0.6,@0.65];
//    [self.s setThumbImage:[UIImage imageNamed:@"pb-seek-bar-btn"] forState:UIControlStateNormal];
//    [self.s setMinimumTrackImage:[UIImage imageNamed:@"pb-seek-bar-fr"] forState:UIControlStateNormal];
//    [self.s setMaximumTrackImage:[UIImage imageNamed:@"pb-seek-bar-bg"] forState:UIControlStateNormal];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_av play:@"https://v7.438vip.com/2019/07/07/ZOwRZj7K03N2T97x/playlist.m3u8"];
    
}


//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
