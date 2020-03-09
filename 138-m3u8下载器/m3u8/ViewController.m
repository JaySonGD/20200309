//
//  ViewController.m
//  m3u8
//
//  Created by Jay on 24/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "FFmpegManager.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *kbs;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 沙盒路径
    NSString *directory = NSHomeDirectory();
    NSLog(@"沙盒路径 : %@", directory);
    
    directory = @"/Users/jay/Desktop/";
    NSString *url = @"http://yun.kubozy-youku-163.com/20190621/15575_cfedbee9/index.m3u8";
    NSString *file = [directory stringByAppendingPathComponent:@"8.mp4"];
    
    //ffmpeg -i https://host/really.m3u8 xinxijuzhiwang.mp4
    
    //ffmpeg -i http://yun.kubo-zy-youku.com/20180619/8Ne1BjmP/index.m3u8 -c copy -bsf:a aac_adtstoasc /Users/jay/Desktop/output.mp4

    //ffmpeg -i http://yun.kubo-zy-youku.com/20180619/8Ne1BjmP/index.m3u8 -c copy -bsf:a aac_adtstoasc -y /Users/jay/Desktop/output.mp4

    
    NSString *cmd = [NSString stringWithFormat:@"ffmpeg -i %@ -c copy -bsf:a aac_adtstoasc -y %@",url,file];
    //cmd = @"ffmpeg -i http://yun.kubo-zy-youku.com/20180619/8Ne1BjmP/index.m3u8 -c copy -bsf:a aac_adtstoasc -y /Users/jay/Desktop/output.mp4";
    [[FFmpegManager sharedManager] runCmd:cmd processBlock:^(float process,float kbs,long long size) {
        NSLog(@"%s--%f---%f---", __func__,process,kbs);
        self.progress.progress = process;
        self.kbs.text = [NSString stringWithFormat:@"%.2fKb/s",kbs];
    } completionBlock:^(NSError *error) {
        NSLog(@"%s", __func__);
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //步骤1：获取视频路径
    // 沙盒路径
    NSString *directory = NSHomeDirectory();
    NSLog(@"沙盒路径 : %@", directory);
    NSString *file = [directory stringByAppendingPathComponent:@"88.mp4"];
    
    NSURL *webVideoUrl = [NSURL fileURLWithPath:file];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
}

@end
