//
//  TranscodeViewController.m
//  TestFFMpeg
//
//  Created by Apple on 16/6/21.
//  Copyright © 2016年 tuyaohui. All rights reserved.
//

#import "TranscodeViewController.h"
#import "ffmpeg.h"

@interface TranscodeViewController ()

@end

@implementation TranscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.transcode addTarget:self action:@selector(transcodeAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)transcodeAction
{
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd) object:nil] start];

    

}

- (void)runCmd{
    
    NSArray *list = @[
                      @{
                          @"url":@"http://vfile1.grtn.cn/2019/1561/0939/0633/156109390633.ssm/156109390633.m3u8?22",
                          @"name":@"1.mp4"
                          },
                      @{
                          @"url":@"http://127.0.0.1/tx/1.m3u8",
                          @"name":@"2.mp4"
                          },  @{
                          @"url":@"http://vfile1.grtn.cn/2019/1561/3898/3837/156138983837.ssm/156138983837.m3u8",
                          @"name":@"3.mp4"
                          }
                      ];
    NSDictionary *obj = list[1];
    
        NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        directory = @"/Users/jay/Desktop/";
        NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4",rand()]];
    
        NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -c copy -bsf:a aac_adtstoasc -y %@",obj[@"url"],filePath];
    
    NSString *soucePath = [[NSBundle mainBundle]pathForResource:@"sintel.mov" ofType:nil];
    NSString *targetPath  = [NSString stringWithFormat:@"%@/Documents/test.avi",NSHomeDirectory()];
    
    NSLog(@"%@",targetPath);
    
//    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -b:v 400k -s 1280x640 -y %@",soucePath,targetPath];
    //self.content.text = commond;
    
    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    int argc = (int)argv_array.count;
    char **argv = malloc(sizeof(char)*1024);
    //把我们写的命令转成c的字符串数组
    for (int i = 0; i < argc; i++) {
        argv[i] = (char *)malloc(sizeof(char)*1024);
        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
        
    }
    
    ffmpeg_main(argc, argv);
    
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);

}

@end
