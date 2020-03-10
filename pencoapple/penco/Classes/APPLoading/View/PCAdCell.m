//
//  PCAdCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/21.
//  Copyright © 2019 toceansoft. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import "PCAdCell.h"
@interface PCAdCell ()
@property (weak, nonatomic) IBOutlet UIWebView *adWeb;
@property (nonatomic, weak)AVPlayer *player;
@property (nonatomic, weak)AVPlayerLayer *avLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@end
@implementation PCAdCell
- (void)loadData:(NSDictionary*)info{
//    [self.adWeb removeFromSuperview];
//    if (self.player) {
//        [self.player pause];
//        [self.avLayer removeFromSuperlayer];
//    }
//    NSString *sourceType = [info objectForKey:@"sourceType"];
//    if ([sourceType isEqualToString:@"video"]) {
//        [self loadVedio:[info objectForKey:@"url"]];
//    }else{
//        UIWebView *web = [UIWebView new];
//        self.adWeb = web;
//        [self addSubview:self.adWeb];
//        [self.adWeb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.mas_equalTo(0);
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//        }];
//        NSURL *url =[NSURL URLWithString:[info objectForKey:@"url"]];
//        NSURLRequest *request =[NSURLRequest requestWithURL:url];
//        [self.adWeb loadRequest:request];
//    }
    UIImageView *image = [UIImageView new];
    [self addSubview:image];
    self.imgV = image;
     [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"url"]]];
}

-(void)loadVedio:(NSString*)videoPath{
    
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:videoPath]];
    
    // 视频的相关控制操作, 都是由AVPlayer来负责
    
    // `AVPlayerLayer`会将`AVPlayer`的内容显示到它的图层上
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.player = player;
    self.avLayer = layer;
    // 注意: 没有设置frame值
    
    [layer setFrame:self.bounds];
    
    [self.layer addSublayer:layer];
    //执行播放动作(音频或者视频)
    [self.player play];
}

@end
