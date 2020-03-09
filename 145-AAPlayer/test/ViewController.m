//
//  ViewController.m
//  test
//
//  Created by xin on 2019/8/12.
//  Copyright © 2019年 Adc. All rights reserved.
//

#import "ViewController.h"
#import "AAPlayer.h"

@interface ViewController ()
@property (nonatomic, strong)AAPlayer *aa;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AAPlayer *aa = [AAPlayer player];
    [self.view addSubview:aa];

    aa.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width/16.0*9.0);
    
    [aa playWithURL:@"http://yun.kubozy-youku-163.com/20181226/1305_96ee31d2/index.m3u8" backTitle:@"222"];
    
    _aa = aa;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
//    [_aa playWithURL:@"http://stream1.grtn.cn/gdws/sd/live.m3u8?_upt=9410b5191565709095" backTitle:@"珠江频道"];

}



@end
