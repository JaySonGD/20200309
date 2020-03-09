//
//  ViewController.m
//  HTTPServer
//
//  Created by Jay on 16/7/2019.
//  Copyright © 2019 Jay. All rights reserved.
//

#import "ViewController.h"
#import "FFTSDownloader.h"
#import <AVKit/AVKit.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, copy) NSString *url;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.url = @"http://yun.kubozy-youku-163.com/20190715/17153_75c1686f/index.m3u8"; ;//@"http://zy.kubozy-youku-163-aiqi.com/20190710/13979_c1e699f0/index.m3u8";//@"http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8";

}
- (IBAction)d:(id)sender {
   
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1/app/public/api/d?debug=99&url=%@",self.url]]];
    
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    NSArray *listArr = obj[@"ts"];
    CGFloat total = [obj[@"total"] floatValue];
    
    [[FFTSDownloader sharedManager] dowloadWithTs:listArr url:self.url total:total fileName:@"333" processBlock:^(float p, float kbs) {
        self.progress.progress = p;
        
    } completionBlock:^(NSError *rr) {
        
    }];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSURL *webVideoUrl = [FFTSDownloader getURL:self.url];//[NSURL URLWithString:@"http://127.0.0.1:9479/b6c7607e92d52ae0923b5b73ccef12ae.m3u8"];//[NSURL fileURLWithPath:file];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    
    return;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1/app/public/api/d?debug=99&url=%@",self.url]]];
    
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    NSArray *listArr = obj[@"ts"];
    CGFloat total = [obj[@"total"] floatValue];
    
    [[FFTSDownloader sharedManager] dowloadWithTs:listArr url:self.url total:total fileName:@"333" processBlock:^(float p, float kbs) {
        self.progress.progress = p;
        
    } completionBlock:^(NSError *rr) {
        
    }];
}


@end
