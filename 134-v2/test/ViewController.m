//
//  ViewController.m
//  test
//
//  Created by Jay on 5/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "ZKRBaiWeiAdManager.h"
#import "NSData+Compression.h"
#import "test-Swift.h"
#import "AARequest.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end


@implementation ViewController



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//- (void)viewDidLoad {
//    [super viewDidLoad];
    
    NSString *str = @"排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任排列和组合讲解 各位伙伴大家早上好，因为这个时间我是在上班路上不太方便跟大家直播， 所以我提前录了一个视频，也是完成永澄老师给我的这么一个任11";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    data = [[NSData alloc] initWithContentsOfFile:@""];
    
    NSData *encode = [data gzencode];
    NSData *decode = [encode gzdecode];
    NSString *str1 = [[NSString alloc] initWithData:decode encoding:NSUTF8StringEncoding];
    
    NSLog(@"原数据大小：%ld 字节",data.length);
    NSLog(@"压缩后大小：%ld 字节",encode.length);

    
    [[AARequest request] getJson:@"http://127.0.0.1/app/public/dsm/detail?debug=99&json&id=27" parameter:@{} success:^(id respones) {
        NSLog(@"%s--%@", __func__,respones);

    } error:^(NSError *error) {
        
    }];
    
}



- (void)touchesBegan1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
   ViewController22 *vc =  [ViewController22 new];
    [self presentViewController:vc animated:YES completion:nil];
//    [[ZKRBaiWeiAdManager shareManager] lancinateAnimateDefaultModeView:self.iv completeBlock:^{
//        NSLog(@"%s", __func__);
//
//
//    }];
}


@end
